import * as convert from './index';
import * as functions from 'firebase-functions';
import { mockDeep } from 'jest-mock-extended';
import ffmpeg from 'fluent-ffmpeg';
import _busboy from 'busboy';
import * as stream from 'stream';

const userId = 'test-user-id';
const tempDir = 'test-temp-dir';

let mockReadStream;
let mockWriteStream;
let fileMakePublicFunction;
let ffmpeg: ffmpeg;
let busboy: _busboy;

function setUpMockReadStream(currentEvent: string) {
  return mockReadStream = {
    pipe: jest.fn().mockReturnThis(),
    end: jest.fn(),
    on: jest.fn((event, handler) => {
      if (currentEvent == event && event === 'error') {
        handler(Error());
      } else if (currentEvent == event && event === 'finish') {
        handler();
      } else if (currentEvent == event && event === 'end') {
        handler('file');
      }
      return mockReadStream;
    }),
  };
}

function setUpMockWriteStream(currentEvent: string) {
  return mockWriteStream = {
    pipe: jest.fn().mockReturnThis(),
    once: jest.fn(),
    emit: jest.fn(),
    close: jest.fn().mockReturnThis(),
    end: jest.fn(),
    on: jest.fn((event, handler) => {
      if (currentEvent == event && event === 'error') {
        handler(Error());
      } else if (currentEvent == event && event === 'end') {
        handler('file');
      } else if (currentEvent == event && event === 'close') {
        handler();
      }
      return mockWriteStream;
    }),
  };
}


function setUpFileMakePublicFunction(returnValue) {
  fileMakePublicFunction = jest.fn(async () => {
    if (returnValue instanceof Error) {
      throw Error();
    } else {
      return [ returnValue ];
    }
  });
}

function setUpFfmpeg(currentEvent: string) {
  ffmpeg = mockDeep<ffmpeg>({
    addInput: jest.fn().mockReturnThis(),
    addOutput: jest.fn().mockReturnThis(),
    addOptions: jest.fn().mockReturnThis(),
    inputFPS: jest.fn().mockReturnThis(),
    videoFilters: jest.fn().mockReturnThis(),
    run: jest.fn().mockReturnThis(),
    mergeToFile: jest.fn().mockReturnThis(),
    on: jest.fn((event, handler) => {
      if (currentEvent == event && event === 'error') {
        handler(Error());
      } else if (currentEvent == event && event === 'end') {
        handler();
      }
      return ffmpeg;
    }),
  });
}


function setUpBusboy(currentEvent: string, fileEvent: string) {
  return busboy = mockDeep<_busboy>({
    end: jest.fn(),
    on: jest.fn((event, handler) => {
      setUpMockReadStream('finish');
      setUpMockWriteStream('close');

      if (currentEvent == event && event === 'finish') {
        handler();
      } else if (currentEvent == event && event === 'error') {
        handler(Error());
      } else if (currentEvent == event && event === 'file') {
        handler('', setUpReadable(fileEvent), { filename: 'filename' });
        busboy = setUpBusboy('finish', fileEvent);
      }
      return busboy;
    }),
  });
}

function setUpReadable(currentEvent: string) {
  const readable = mockDeep<stream.Readable>({
    pipe: jest.fn().mockReturnThis(),
    on: jest.fn((event, handler) => {
      if (currentEvent == event && event === 'error') {
        handler(Error());
      } else if (currentEvent == event && event === 'end') {
        handler('file');
      } else if (currentEvent == event && event === 'close') {
        handler();
      }
      return readable;
    }),
  });
  return readable;
}

jest.mock('busboy', () => () => {
  return {
    end: jest.fn(),
    on: jest.fn((event, handler) =>{
      setUpMockReadStream('finish');

      if (event === 'finish') {
        handler('done');
      }
      return busboy;
    }),
  };
});

jest.mock('jimp', () => {
  return {
    read: jest.fn().mockImplementation((name) => {
      const _name = name || '';
      return {
        bitmap: {
          width: _name.indexOf('odd') != -1 ? 501 : 600,
          height: _name.indexOf('odd') != -1 ? 301 : 400,
        },
      };
    }),
  };
});

jest.mock('fluent-ffmpeg', () => () => {
  return {
    addInput: jest.fn().mockReturnThis(),
    addOutput: jest.fn().mockReturnThis(),
    run: jest.fn().mockReturnThis(),
    addOptions: jest.fn().mockReturnThis(),
    inputFPS: jest.fn().mockReturnThis(),
    videoFilters: jest.fn().mockReturnThis(),
    mergeToFile: jest.fn().mockReturnThis(),
    on: jest.fn((event, handler) => {
      if (event === 'end') {
        handler();
      }
      return ffmpeg;
    }),
  };
});

jest.mock('fs', () => {
  return {
    mkdtempSync: jest.fn(() => `${tempDir}/${userId}`),
    createReadStream: jest.fn(() => mockReadStream),
    createWriteStream: jest.fn(() => mockWriteStream),
    stat: jest.fn(),
    unlinkSync: jest.fn(),
    rmdir: jest.fn(),
  };
});

jest.mock('os', () => {
  return {
    tmpdir: jest.fn(() => tempDir),
    platform: jest.fn(() => ''),
  };
});

jest.mock('firebase-admin', () => {
  return {
    storage: jest.fn(() => ({
      bucket: jest.fn(() => ({
        name: 'test-bucket',
        file: jest.fn(() => ({
          name: 'test-file',
          exists: jest.fn(async () => {
            return [ true ];
          }),
          createWriteStream: jest.fn(() => mockWriteStream),
          makePublic: fileMakePublicFunction,
        })),
      })),
    })),
  };
});

describe('convert', () => {
  it('returns response with status 200 on success', async () => {
    const mockRequest = mockDeep<functions.https.Request>();
    mockRequest.get.mockReturnValue('localhost:5001');
    mockRequest.protocol = 'https';
    setUpBusboy('finish', 'end');
    setUpFfmpeg('end');
    setUpMockReadStream('finish');
    setUpFileMakePublicFunction(true);

    const mockResponse = mockDeep<functions.Response>({
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    });

    await convert.convert(mockRequest, mockResponse);

    expect(mockResponse.status).toHaveBeenCalledWith(200);
    expect(mockResponse.send).toHaveBeenCalledWith({
      video_url: 'https://storage.googleapis.com/test-bucket/test-file',
      gif_url: 'https://storage.googleapis.com/test-bucket/test-file',
    });
  });

  it('returns status 500 on error', async () => {
    const mockRequest = mockDeep<functions.https.Request>();
    mockRequest.get.mockReturnValue('localhost:5001');
    mockRequest.protocol = 'https';
    setUpBusboy('error', 'error');


    const mockResponse = mockDeep<functions.Response>({
      status: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    });
    await convert.convert(mockRequest, mockResponse);

    expect(mockResponse.status).toHaveBeenCalledWith(500);
  });
});


describe('convertImages', () => {
  it('throws error on bad host', async () => {
    const mockRequest = mockDeep<functions.https.Request>();
    mockRequest.protocol ='https';

    await expect(convert.convertImages(mockRequest)).rejects.toThrow();
  });

  it('returns response with status 200 and file url on success', async () => {
    const mockRequest = mockDeep<functions.https.Request>();
    mockRequest.get.mockReturnValue('localhost:5001');
    mockRequest.protocol = 'https';

    setUpBusboy('finish', 'end');
    setUpFfmpeg('end');
    setUpMockReadStream('finish');
    setUpFileMakePublicFunction(true);

    const { status, videoUrl } = await convert.convertImages(mockRequest);
    expect(status).toEqual(200);
    expect(videoUrl).toEqual('https://storage.googleapis.com/test-bucket/test-file');
  });
});


describe('createTempDirectory', () => {
  it('returns path to temp directory', async () => {
    const testPath = tempDir + '/' + userId;

    const expectedPath = await convert.createTempDirectory(userId);
    expect(expectedPath).toEqual(testPath);
  });
});

describe('readFramesFromRequest', () => {
  const mockRequest = mockDeep<functions.https.Request>();

  it('returns list of frames for request', async () => {
    setUpBusboy('file', 'close');

    await expect(
      convert.readFramesFromRequest(busboy, mockRequest, tempDir)
    ).resolves.toStrictEqual([ 'test-temp-dir/filename' ]);
  });


  it('throws error when unable to read frames.', async () => {
    setUpBusboy('error', 'error');

    await expect(
      convert.readFramesFromRequest(busboy, mockRequest, tempDir)
    ).rejects.toThrow();
  });
});

describe('proceedFile', () => {
  const filePath = `${tempDir}/frame_1.png`;

  describe('returns path for the file', () => {
    it('on close', async () => {
      setUpMockWriteStream('close');

      await expect(
        convert.proceedFile(filePath, setUpReadable('close'))
      ).resolves.toBe(filePath);
    });

    it('on end', async () => {
      setUpMockWriteStream('end');

      await expect(convert.proceedFile(filePath, setUpReadable('end'))).resolves.toBe(filePath);
    });
  });


  describe('rejects on error', () => {
    it('in file', async () => {
      const files = convert.proceedFile(filePath, setUpReadable('error'));

      await expect(files).rejects.toThrow();
    });

    it('in write stream', async () => {
      setUpMockWriteStream('error');
      const files = convert.proceedFile(filePath, setUpReadable('end'));

      await expect(files).rejects.toThrow();
    });
  });


  it('throws error when unable to read file.', async () => {
    setUpMockWriteStream('error');

    await expect(
      convert.proceedFile(filePath, setUpReadable('end'))
    ).rejects.toThrow();
  });
});

describe('convertToVideo', () => {
  it('returns path for the file', async () => {
    setUpFfmpeg('end');

    await expect(
      convert.convertToVideo(ffmpeg, [ `${tempDir}/frame_1.png` ], tempDir)
    ).resolves.toBe(`${tempDir}/video.mp4`);
  });

  describe('when the dimensions of the image are even', () => {
    it('keeps the dimension on the scale flag', async () => {
      setUpFfmpeg('end');
      await convert.convertToVideo(ffmpeg, [ `${tempDir}/frame_1.png` ], tempDir)

      expect(ffmpeg.addOptions).toHaveBeenCalledWith([
        '-codec:v libx264',
        '-s 600x400',
        '-pix_fmt yuv420p',
      ]);
    });
  });

  describe('when the dimensions of the image are odd', () => {
    it('uses the nearest (down) even number', async () => {
      setUpFfmpeg('end');

      await convert.convertToVideo(ffmpeg, [ `${tempDir}/frame_odd.png` ], tempDir)

      expect(ffmpeg.addOptions).toHaveBeenCalledWith([
        '-codec:v libx264',
        '-s 500x300',
        '-pix_fmt yuv420p',
      ]);
    });
  });

  it('throws error when unable to convert frames.', async () => {
    setUpFfmpeg('error');

    await expect(
      convert. convertToVideo(ffmpeg, [ `${tempDir}/frame_1.png` ], tempDir)
    ).rejects.toThrow();
  });
});

describe('convertVideoToGif', () => {
  it('returns path for the file', async () => {
    setUpFfmpeg('end');

    await expect(
      convert.convertVideoToGif(ffmpeg, `${tempDir}/video.mp4`, tempDir)
    ).resolves.toBe(`${tempDir}/video.gif`);
  });

  it('throws error when unable to convert video.', async () => {
    setUpFfmpeg('error');

    await expect(
      convert.convertVideoToGif(ffmpeg, `${tempDir}/video.mp4`, tempDir)
    ).rejects.toThrow();
  });
});

describe('uploadFile', () => {
  const videoName = 'test-video-name';
  const videoPath = 'test-path';

  it('throws error when unable to write file to storage.', async () => {
    setUpMockReadStream('error');

    await expect(convert.uploadFile(videoName, videoPath)).rejects.toThrow();
  });

  it('throws error when make a file public throws.', async () => {
    setUpMockReadStream('finish');
    setUpFileMakePublicFunction(Error());

    await expect(convert.uploadFile(videoName, videoPath)).rejects.toThrow();
  });

  it('returns path for the file.', async () => {
    setUpMockReadStream('finish');
    setUpFileMakePublicFunction(true);

    await expect(convert.uploadFile(videoName, videoPath)).resolves.toBe(
      'https://storage.googleapis.com/test-bucket/test-file'
    );
  });
});
