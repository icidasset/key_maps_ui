import { HIDE_LOADER, SHOW_LOADER } from '../lib/types';


const initialState = {
  isShown: true,
  timeoutIds: [],
};


function ldr(method, klass) {
  document.body.classList[method](`loader-overlay--${klass}`);
}


function clearTimeouts(state) {
  state.timeoutIds.forEach(id => clearTimeout(id));
}


export default function(state = initialState, action) {
  let id;

  switch (action.type) {

  case HIDE_LOADER:
    clearTimeouts(state);
    ldr('remove', 'fadein');
    id = setTimeout(() => ldr('remove', 'show'), 550);
    return { ...state, isShown: false, timeoutIds: [id] };

  case SHOW_LOADER:
    clearTimeouts(state);
    ldr('add', 'show');
    id = setTimeout(() => ldr('add', 'fadein'), 50);
    return { ...state, isShown: true, timeoutIds: [id] };

  default: return state;

  }
}
