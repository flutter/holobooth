/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
import * as functions from 'firebase-functions';

import { download } from './';


jest.mock('firebase-admin', () => {
  return {
    storage: jest.fn(() => ({
      bucket: jest.fn(() => ({
        name: 'test-bucket',
        file: jest.fn((filePath) => ({
          exists: jest.fn(async () => {
            return [ filePath.indexOf('404') == -1 ];
          }),
          download: jest.fn(async () => {
            if (filePath.indexOf('fail') == -1) {
              return [ [ 1, 2 ] ];
            } else {
              throw Error('Error');
            }
          }),
        })),
      })),
    })),
  };
});

describe('Download API', () => {
  const baseReq = {
    path: '',
    protocol: 'http',
    get(_: string) {
      return 'localhost:5001';
    },
  } as functions.https.Request;

  test('Invalid path returns 404 and html', async () => {
    const req = Object.assign({}, baseReq);
    const res = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    await download(req, res as any);
    expect(res.status).toHaveBeenCalledWith(404);
    expect(res.send).toHaveBeenCalled();
  });

  test('Invalid file extension returns 404', async () => {
    const req = Object.assign({}, baseReq, {
      path: 'wrong.gif',
    });

    const res = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    await download(req, res as any);
    expect(res.status).toHaveBeenCalledWith(404);
    expect(res.send).toHaveBeenCalled();
  });

  test('returns 404 is a file does not exists', async () => {
    const req = Object.assign({}, baseReq, {
      path: '404.mp4',
    });

    const res = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    await download(req, res as any);
    expect(res.status).toHaveBeenCalledWith(400);
    expect(res.send).toHaveBeenCalled();
  });

  test('returns 404 with an invalid host', async () => {
    const req = Object.assign({}, baseReq, {
      get(_: string) {
        return null;
      },
    });

    const res = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    await download(req, res as any);
    expect(res.status).toHaveBeenCalledWith(404);
    expect(res.send).toHaveBeenCalled();
  });

  test('returns 500 if something goes wrong', async () => {
    const req = Object.assign({}, baseReq, {
      path: 'fail.mp4',
    });

    const res = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    await download(req, res as any);
    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.send).toHaveBeenCalled();
  });

  test('Valid file name returns 200 and html', async () => {
    const req = Object.assign({}, baseReq, {
      path: 'test.mp4',
    });

    const res = {
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    await download(req, res as any);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.send).toHaveBeenCalledWith([ 1, 2 ]);
  });
});
