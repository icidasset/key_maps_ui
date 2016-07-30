import { AUTHENTICATE, DEAUTHENTICATE } from '../lib/types';


const initialState = {
  token: null,
};


export default function(state = initialState, action) {
  switch (action.type) {

  case AUTHENTICATE:
    return { ...state, token: action.token };

  case DEAUTHENTICATE:
    return { ...initialState };

  default:
    return state;

  }
}
