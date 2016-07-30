import { metadata }  from 'static-base-preset';

import pages from './pages';
import webpack from './webpack';


const comboSequence = (initial) => {
  return webpack(initial)
    .then(assets => metadata({ ...initial, assets }))
    .then(extended => pages(extended));
};


export default [
  comboSequence,
];
