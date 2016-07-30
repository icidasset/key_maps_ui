import { join } from 'path';
import { buildDefinition } from 'static-base/lib/dictionary';
import { metadata, read, templates, write } from 'static-base-contrib';
import { runWithMessageAndLimiter } from 'static-base-preset';

import applyFilter from 'static-base-contrib/lib/utils/filter';
import pug from 'pug';
import pick from 'lodash/fp/pick';


export default function(data) {
  const message = 'Building pages';
  const limiter = data.priv.changedPath;

  return runWithMessageAndLimiter(message)(limiter)(
    [read],

    // rename to 'index.html',
    // and make a copy with the name '200.html'
    (files) => {
      const content = files[0].content;
      const path = n => files[0].path.replace('application.pug', n);
      const deps = pick(['pattern', 'wd', 'root'], files[0]);

      return [
        { ...buildDefinition(path('index.html'), deps), content },
        { ...buildDefinition(path('200.html'), deps), content },
      ];
    },

    [metadata, data],
    [templates, render],
    [write, 'build']
  )(
    'src/application.pug',
    data.priv.root
  );
}


function render(template, data) {
  return pug.render(template, {
    ...data,
    filename: data.basename,
  });
}
