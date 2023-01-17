import * as admin from 'firebase-admin';

// Apparently eslint doesn't "understand" how the v2 is exported by
// the firebase-functions package, so we are ignoring this lint.
// More on: https://stackoverflow.com/a/69959606
//
// eslint-disable-next-line import/no-unresolved
import * as functions from 'firebase-functions/v2';
import * as path from 'path';

import { UPLOAD_PATH, ALLOWED_HOSTS } from '../config';
import ffmpeg from 'fluent-ffmpeg';
import Jimp from 'jimp';

import fs from 'fs';
import os from 'os';
import _busboy from 'busboy';
import { v4 as uuidv4 } from 'uuid';
import { Readable } from 'stream';

export const errorMessage = 'Something went wrong';

/**
 * Public convert function
 */
export const convert = functions.https.onRequest(
  { memory: '1GiB' },
  async (req, res) => {
    try {
      const { status, videoUrl, gifUrl, thumbnailUrl } = await convertImages(req);

      res.set('Access-Control-Allow-Origin', '*');
      res.status(status).send({
        video_url: videoUrl,
        gif_url: gifUrl,
        thumbnail_url: thumbnailUrl,
      });
    } catch (error) {
      functions.logger.error(error);
      res.status(500).send(errorMessage);
    }
  }
);

export async function convertImages(
  req: functions.https.Request,
): Promise<{
  status: number,
  videoUrl: string,
  gifUrl: string,
  thumbnailUrl: string,
}> {
  let tempDir: string | null = null;

  try {
    const host = req.get('origin') ?? '';

    if (!ALLOWED_HOSTS.includes(host)) {
      functions.logger.log('Bad host', {
        host,
      });
      throw new Error('Bad host');
    }

    const userId = uuidv4();
    tempDir = await createTempDirectory(userId);
    const busboy = _busboy({ headers: req.headers });
    const frames = await readFramesFromRequest(busboy, req, tempDir);

    const thumbnailUrl = await uploadFile(userId + '.png', frames[0]);
    const videoPath = await convertToVideo(ffmpeg(), frames, tempDir);
    const gifPath = await convertVideoToGif(ffmpeg(), videoPath, tempDir);

    const [ videoUrl, gifUrl ] = await Promise.all([
      uploadFile(userId + '.mp4', videoPath),
      uploadFile(userId + '.gif', gifPath),
    ]);

    return { status: 200, videoUrl, gifUrl, thumbnailUrl };
  } catch (error) {
    functions.logger.error(error);
    throw error;
  } finally {
    if (tempDir != null) {
      fs.rmdir(tempDir, () => null);
    }
  }
}

export async function createTempDirectory(userId: string): Promise<string> {
  const tmpdir = os.tmpdir();
  return fs.mkdtempSync(path.join(tmpdir, userId));
}


export async function readFramesFromRequest(
  busboy: _busboy,
  req: functions.https.Request,
  folder: string
): Promise<string[]> {
  const paths: string[] = [];
  const fileWrites =new Map<string, Promise<string>>();

  return new Promise<string[]>((resolve, reject) => {
    busboy
      .on('file', (_, file, { filename }) => {
        const filepath = path.join(folder, filename);
        paths.push(filepath);
        fileWrites[filepath] = proceedFile(filepath, file);
      })
      .on('finish', async () => {
        await Promise.all([ ...fileWrites.values() ]);
        resolve(paths);
      })
      .on('error', function(error) {
        functions.logger.error(error);
        reject(error);
      });

    busboy.end(req.rawBody);
  });
}

export async function proceedFile(
  filepath: string,
  file: Readable
): Promise<string> {
  return new Promise((resolve, reject) => {
    const writeStream = fs.createWriteStream(filepath);
    file.pipe(writeStream)
      .on('error', (error) => {
        functions.logger.error(error);
        reject(error);
      })
      .on('end', () => {
        writeStream.end();
      });

    writeStream
      .on('end', () => resolve(filepath))
      .on('close', () => resolve(filepath))
      .on('error', function(error) {
        functions.logger.error(error);
        return reject(error);
      });
  });
}

function adjustDimensions(width: number, height: number): {
  width: number,
  height: number,
} {
  const w = width % 2 == 0 ? width : width - 1;
  const h = height % 2 == 0 ? height : height - 1;

  return { width: w, height: h };
}

export async function convertToVideo(
  ffmpeg: ffmpeg,
  frames: string[],
  folder: string
): Promise<string> {
  const videoPath = `${folder}/video.mp4`;

  const image = await Jimp.read(frames[0]);
  const adjustedDimensions = adjustDimensions(
    image.bitmap.width,
    image.bitmap.height,
  );

  const scaleArg = `${adjustedDimensions.width}x${adjustedDimensions.height}`;

  return new Promise((resolve, reject) => {
    ffmpeg
      .addInput(folder + '/frame_%d.png')
      .addOptions([ '-codec:v libx264', `-s ${scaleArg}`, '-pix_fmt yuv420p' ])
      .inputFPS(frames.length / 5)
      .mergeToFile(videoPath)
      .on('end', () => {
        frames.forEach((frame) => {
          fs.unlinkSync(frame);
        });
        resolve(videoPath);
      })
      .on('error', function(error) {
        functions.logger.error(error);
        return reject( error);
      });
  });
}

export async function convertVideoToGif(
  ffmpeg: ffmpeg,
  videoPath: string,
  folder: string
): Promise<string> {
  const gifPath = `${folder}/video.gif`;
  return new Promise((resolve, reject) => {
    ffmpeg
      .addInput(videoPath)
      .videoFilters('fps=10,split [o1] [o2];[o1] palettegen [p]; [o2] fifo [o3];[o3] [p] paletteuse')
      .addOutput(gifPath)
      .on('end', () => {
        resolve(gifPath);
      })
      .on('error', function(error) {
        functions.logger.error(error);
        return reject( error);
      })
      .run();
  });
}

export function uploadFile(
  videoName: string,
  path: string
): Promise<string> {
  return new Promise((resolve, reject) => {
    const bucket = admin.storage().bucket();
    const file = bucket.file(`${UPLOAD_PATH}/${videoName}`);

    fs.createReadStream(path)
      .pipe(file.createWriteStream())
      .on('finish', function() {
        file
          .makePublic()
          .then(() => {
            resolve(
              `https://storage.googleapis.com/${bucket.name}/${file.name}`
            );
          })
          .catch((error) => {
            reject(new Error(error.message));
          });
      })
      .on('error', function(error) {
        functions.logger.error(error);
        return reject(error);
      });
  });
}
