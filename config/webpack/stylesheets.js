import { isDevelopmentEnv } from 'static-base-preset';
import ExtractTextPlugin from 'extract-text-webpack-plugin';
import path from 'path';

import cssnext from 'postcss-cssnext';
import functions from 'postcss-functions';
import mixins from 'postcss-mixins';
import normalize from 'postcss-normalize';
import partialImport from 'postcss-partial-import';
import propertyLookup from 'postcss-property-lookup';
import simpleVars from 'postcss-simple-vars';


import list from '../../src/lib/tags/list';


const cssConfig = list`
  modules
  importLoaders=1
  localIdentName=[name]__[local]___[hash:base64:5]
`.join('&');


const cssChain = `css?${cssConfig}!postcss`;


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.pcss$/,
        include: path.resolve(__dirname, '../../src'),
        exclude: path.resolve(__dirname, '../../src/components/App.pcss'),
        loader: ExtractTextPlugin.extract(
          'style',
          `${cssChain}`
        ),
      }, {
        test: /\.pcss$/,
        include: path.resolve(__dirname, '../../src/components/App.pcss'),
        loader: ExtractTextPlugin.extract(
          'style',
          `${cssChain}?pack=withNormalize`
        ),
      }],
    },

    postcss: () => {
      const defaults = [
        partialImport({
          extension: 'pcss',
          prefix: '',
        }),

        functions({
          functions: {

            // 12px: grid
            // 16px: default font-size
            grid(number) {
              const sizeInRem = parseFloat(number) * (12 / 16);
              // e.g. 1 = 1 column of 12px
              return sizeInRem.toString() + 'rem';
            },

            rem(pixels) {
              const sizeInRem = parseFloat(pixels.replace(/px$/, '')) / 16;
              return sizeInRem.toString() + 'rem';
            },

          },
        }),

        mixins,
        propertyLookup,
        simpleVars,
        cssnext({
          features: {
            rem: false,
          },
        }),
      ];

      return {
        defaults,
        withNormalize: [normalize, ...defaults],
      };
    },

    plugins: [
      new ExtractTextPlugin(
        isDevelopmentEnv() ?
          'assets/[name].css' :
          'assets/[name].[hash].css'
      ),
    ],
  };
}
