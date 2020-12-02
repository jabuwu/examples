import { S3 } from 'aws-sdk';
import { createReadStream, ReadStream } from 'fs';
import * as path from 'path';

const S3_ACCESS_KEY = '';
const S3_SECRET_KEY = '';
const S3_BUCKET = '';

const s3 = new S3({
  accessKeyId: S3_ACCESS_KEY,
  secretAccessKey: S3_SECRET_KEY,
  region: 'us-east-1'
});

export async function uploadReadStream(key: string, stream: ReadStream) {
  await s3.upload({
    Bucket: S3_BUCKET,
    Key: key,
    Body: stream
  }).promise();
}

export async function uploadString(key: string, string: string) {
  await s3.putObject({
    Bucket: S3_BUCKET,
    Key: key,
    Body: string
  }).promise();
}

(async() => {
  let rs = createReadStream(path.join(process.cwd(), 'package.json'));
  await uploadReadStream('package.json', rs);
  await uploadString('hello.txt', 'hello, world');
})();