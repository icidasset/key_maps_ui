import { resolve } from 'path';


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.jsx?$/,
        include: resolve(__dirname, '../../src'),
        loader: 'babel',
      }],
    },
  };
}
