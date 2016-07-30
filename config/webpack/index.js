import { isProductionEnv } from 'static-base-preset';
import partial from 'webpack-partial';
import path from 'path';
import webpack from 'webpack';

import logsConfig from './logs';
import imagesConfig from './images';
import stylesheetsConfig from './stylesheets';
import javascriptsConfig from './javascripts';


const root = path.resolve(__dirname, '../../');


export default () => partial(
  {
    context: root,
    devTool: 'eval',

    entry: {
      application: './src/application.js',
    },

    output: {
      filename: (
        isProductionEnv() ?
          'assets/[name].[hash].js' :
          'assets/[name].js'
      ),
      path: path.join(root, 'build'),
      publicPath: '/',
    },

    plugins: [
      isProductionEnv() ?
        [ new webpack.optimize.UglifyJsPlugin({ minimize: true }) ] :
        [],

      new webpack.DefinePlugin({
        'process.env.NODE_ENV': `"${process.env.ENV}"`,
      }),
    ],
  },

  logsConfig,
  imagesConfig,
  stylesheetsConfig,
  javascriptsConfig
);
