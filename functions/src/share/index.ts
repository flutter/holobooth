import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as path from 'path';
import * as querystring from 'querystring';
import mustache from 'mustache';

import { UPLOAD_PATH, ALLOWED_HOSTS } from '../config';
import notFoundTmpl from './templates/notfound';
import shareTmpl from './templates/share';
import footerTmpl from './templates/footer';
import stylesTmpl from './templates/styles';
import scriptsTmpl from './templates/scripts';
import gaTmpl from './templates/ga';


const VALID_VIDEO_EXT = [ '.mp4' ];

const BaseHTMLContext: Record<string, string | Record<string, string>> = {
  appUrl: '',
  shareUrl: '',
  shareVideoUrl: '',
  assetUrls: {
    favicon: bucketPathForFile('public/favicon.png'),
    bg: bucketPathForFile('public/background.png'),
    playArrowIcon: bucketPathForFile('public/play-arrow.png'),
    shareIcon: bucketPathForFile('public/share.png'),
    flutterForwardLogo: bucketPathForFile('public/flutter-forward-logo.png'),
    videoFrame: bucketPathForFile('public/video-frame.png'),
    flutterIcon: bucketPathForFile('public/flutter-icon.png'),
    firebaseIcon: bucketPathForFile('public/firebase-icon.png'),
    tensorflowIcon: bucketPathForFile('public/tensorflow-icon.png'),
    holocard: bucketPathForFile('public/holocard.png'),
    notFoundBg: bucketPathForFile('public/not-found-bg.png'),
    notFoundMobileBg: bucketPathForFile('public/not-found-mobile-bg.png'),
  },
  meta: {
    title: 'Google I/O Photo Booth',
    desc: (
      'Take a photo in the I/O Photo Booth with your favorite Google Developer Mascots! ' +
      'Built with Flutter & Firebase for Google I/O 2021.'
    ),
  },
  ga: gaTmpl,
  styles: '',
  scripts: '',
  footer: '',
};


/**
 * Returns bucket path
 * @param {string} filename
 * @return {string}
 */
function bucketPathForFile(filename: string): string {
  return (
    'https://firebasestorage.googleapis.com/v0' +
    `/b/${admin.storage().bucket().name}` +
    `/o/${querystring.escape(filename)}?alt=media`
  );
}

/**
 * Return a local file HTML template built with context
 * @param {string} tmpl - html template string
 * @param {Object} context - html context dict
 * @return {string} HTML template string
 */
function renderTemplate(
  tmpl: string, context: Record<string, string | Record<string, string>>
): string {
  context.styles = mustache.render(stylesTmpl, context);
  context.scripts = mustache.render(scriptsTmpl, context);
  context.footer = mustache.render(footerTmpl, context);
  return mustache.render(tmpl, context);
}

/**
 * Render the 404 html page
 * @param {string} videoFileName - filename of storage video
 * @param {string} baseUrl - http base fully qualified URL
 * @return {string} HTML string
 */
function renderNotFoundPage(videoFileName: string, baseUrl: string): string {
  const context = Object.assign({}, BaseHTMLContext, {
    appUrl: baseUrl,
    shareUrl: `${baseUrl}/share/${videoFileName}`,
    shareVideoUrl: bucketPathForFile(`${UPLOAD_PATH}/${videoFileName}`),
  });
  return renderTemplate(notFoundTmpl, context);
}

/**
 * Populate and return the share page HTML for given path
 * @param {string} videoFileName - filename of storage video
 * @param {string} baseUrl - http base fully qualified URL
 * @return {string} HTML string
 */
function renderSharePage(videoFileName: string, baseUrl: string): string {
  const context = Object.assign({}, BaseHTMLContext, {
    appUrl: baseUrl,
    shareUrl: `${baseUrl}/share/${videoFileName}`,
    shareVideoUrl: bucketPathForFile(`${UPLOAD_PATH}/${videoFileName}`),
  });
  return renderTemplate(shareTmpl, context);
}

/**
 * Get share response
 * @param {Object} req - request object
 * @return {Object} share response
 */
export async function getShareResponse(
  req: functions.https.Request
): Promise<{ status: number; send: string }> {
  try {
    const host = req.get('host') ?? '';
    const baseUrl = `${req.protocol}://${host}`;
    const { ext, base: videoFileName } = path.parse(req.path);

    if (!ALLOWED_HOSTS.includes(host) || !VALID_VIDEO_EXT.includes(ext)) {
      functions.logger.log('Bad host or video ext', { host, baseUrl, ext, videoFileName });
      return {
        status: 404,
        send: renderNotFoundPage(videoFileName, baseUrl),
      };
    }

    const videoBlobPath = `${UPLOAD_PATH}/${videoFileName}`;
    const videoExists = await admin.storage().bucket().file(videoBlobPath).exists();

    if (Array.isArray(videoExists) && videoExists[0]) {
      return {
        status: 200,
        send: renderSharePage(videoFileName, baseUrl),
      };
    }

    functions.logger.log('Video does not exist', { videoBlobPath });

    // NOTE 200 status so that default share meta tags work,
    // where twitter does not show meta tags on a 404 status
    return {
      status: 200,
      send: renderNotFoundPage(videoFileName, baseUrl),
    };
  } catch (error) {
    functions.logger.error(error);
    return {
      status: 500,
      send: 'Something went wrong',
    };
  }
}


/**
 * Public sharing function
 */
export const shareVideo = functions.https.onRequest(async (req, res) => {
  const { status, send } = await getShareResponse(req);
  res.set('Access-Control-Allow-Origin', '*');
  res.status(status).send(send);
});
