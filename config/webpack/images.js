import { resolve } from 'path';


export default function() {
  return {
    module: {
      loaders: [{
        test: /\.(gif|jpe?g|png|tiff|svg)$/,
        include: resolve(__dirname, '../../src/images'),
        loader: 'url?limit=10000&name=assets/images/[hash:base64:5]-[name].[ext]',
      }],
    },
  };
}
