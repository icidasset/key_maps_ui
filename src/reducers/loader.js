import { HIDE_LOADER, SHOW_LOADER } from '../lib/types';


const initialState = {
  isShown: false, // TODO: When you show the loader by default, set this to 'true'
};


export default function(state = initialState, action) {
  switch (action.type) {

  case HIDE_LOADER: return { ...state, isShown: false };
  case SHOW_LOADER: return { ...state, isShown: true };
  default: return state;

  }
}
