import { read, svgSprite, write } from 'static-base-contrib';
import { runWithMessageAndLimiter } from 'static-base-preset';


export default function(data) {
  const message = 'Building svg-sprite';
  const limiter = data.priv.changedPath;

  return runWithMessageAndLimiter(message)(limiter)(
    [read],
    [svgSprite, spriteConfig],
    [write, 'build/assets']
  )(
    'src/icons/**/*.svg',
    data.priv.root
  );
}


const iconPlugin = {
  iconPlugin: {
    type: 'perItem',
    fn: item => {
      if (item.elem) {
        item.eachAttr(attr => {
          if ([ 'fill', 'stroke' ].indexOf(attr.name) > -1) {
            // if (attr.value === '#000') {
            //   attr.value = 'currentColor';
            // } else if (attr.value === '#F00') {
            //   item.removeAttr(attr.name);
            // }
            attr.value = 'currentColor';
          }
        });

        var hasStroke = item.computedAttr('stroke');
        var miterLimit = item.computedAttr('stroke-miterlimit');
        var lineJoinIsMiter = [ 'bevel', 'round' ]
          .indexOf(item.computedAttr('stroke-linejoin')) === -1;

        if (hasStroke && !miterLimit && lineJoinIsMiter) {
          item.addAttr({
            name: 'stroke-miterlimit',
            value: '5',
            prefix: '',
            local: 'stroke-miterlimit',
          });
        }
      }
    },
  },
};


const svgoConfig = {
  plugins: [
    iconPlugin,
    { removeDimensions: true },
    { removeTitle: true },
    { removeUselessDefs: false },
    { removeAttrs: {
      attrs: ['stroke-width'],
    }},
  ],
};


const spriteConfig = {
  shape: {
    align: { '*': { '%s': .5 }},
    transform: [{ svgo: svgoConfig }],
  },
  mode: { symbol: {
    dest: '.',
    sprite: 'sprite.svg',
  }},
};
