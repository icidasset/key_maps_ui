import { resolve } from 'path';
import { exec } from 'static-base-preset';

import sequences from './sequences';


exec(
  sequences,
  {
    rootDirectory: resolve(__dirname, '../'),
  }
);
