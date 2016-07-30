import { webpack, write } from 'static-base-contrib';
import { runWithMessageAndLimiter } from 'static-base-preset';

import webpackConfig from '../webpack';


export default function(data) {
  const message = `Compiling webpack assets`;
  const limiter = data.priv.changedPath;
  const pattern = '{src/**/*.js,src/**/*.pcss,src/**/*.pug}';

  return runWithMessageAndLimiter(message)(limiter, pattern)(
    [webpack, webpackConfig()],
    [write, 'build']
  )();
}
