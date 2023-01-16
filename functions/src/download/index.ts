import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as path from 'path';

import { UPLOAD_PATH, ALLOWED_HOSTS } from '../config';

const VALID_VIDEO_EXT = [ '.mp4' ];

/**
 * Get the files and writes it on the response.
 * @param {Object} req - request object
 * @return {Object} share response
 */
export const download = functions.https.onRequest(async (req, res) => {
  try {
    const host = req.get('host') ?? '';
    const baseUrl = `${req.protocol}://${host}`;
    const { ext, base: videoFileName } = path.parse(req.path);

    if (!ALLOWED_HOSTS.includes(baseUrl) || !VALID_VIDEO_EXT.includes(ext)) {
      functions.logger.log('Bad host or video ext', { host, baseUrl, ext, videoFileName });
      res.status(400).send();
    } else {
      const videoBlobPath = `${UPLOAD_PATH}/${videoFileName}`;
      const file = await admin.storage().bucket().file(videoBlobPath);
      const videoExists = await file.exists();

      if (Array.isArray(videoExists) && videoExists[0]) {
        const download = await file.download();
        res.status(200).send(download[0]);
      } else {
        functions.logger.log('Video does not exist', { videoBlobPath });

        res.status(404).send();
      }
    }
  } catch (error) {
    functions.logger.error(error);
    res.status(500).send('Something went wrong');
  }
});
