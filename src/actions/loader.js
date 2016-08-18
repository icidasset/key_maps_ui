import { HIDE_LOADER, SHOW_LOADER } from '../lib/types';


export const showLoader = () => {
  clss('add', 'show-loader');
  setTimeout(() => clss('add', 'fadein-loader'), 50);
  return { type: SHOW_LOADER };
};


export const hideLoader = () => {
  clss('remove', 'fadein-loader');
  setTimeout(() => clss('remove', 'show-loader'), 550);
  return { type: HIDE_LOADER };
};


function clss(method, klass) {
  document.body.classList[method](klass);
}
