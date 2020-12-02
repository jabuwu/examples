import * as Minio from 'minio';
import { createReadStream, ReadStream } from 'fs';
import * as path from 'path';

const MINIO_USE_S3 = false;
const MINIO_USE_SSL = false;
const MINIO_ENDPOINT = '';
const MINIO_PORT = 9000;
const MINIO_ACCESS_KEY = '';
const MINIO_SECRET_KEY = '';
const MINIO_BUCKET = '';

const minio = new Minio.Client(MINIO_USE_S3 ? {
  endPoint: 's3.amazonaws.com',
  useSSL: true,
  accessKey: MINIO_ACCESS_KEY,
  secretKey: MINIO_SECRET_KEY
} : {
  endPoint: MINIO_ENDPOINT,
  port: MINIO_PORT,
  useSSL: MINIO_USE_SSL,
  accessKey: MINIO_ACCESS_KEY,
  secretKey: MINIO_SECRET_KEY
});

export async function uploadReadStream(key: string, stream: ReadStream) {
  await minio.putObject(MINIO_BUCKET, key, stream);
}

export async function uploadString(key: string, string: string) {
  await minio.putObject(MINIO_BUCKET, key, string);
}

(async() => {
  let rs = createReadStream(path.join(process.cwd(), 'package.json'));
  await uploadReadStream('package.json', rs);
  await uploadString('hello.txt', 'hello, world');
})();