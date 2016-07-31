import { AUTHENTICATE, DEAUTHENTICATE } from '../lib/types';


const initialState = {
  token: null,
  user: null,
};


export default function(state = initialState, action) {
  switch (action.type) {

  case AUTHENTICATE:
    return {
      ...state,

      token: action.token,
      user: action.user,
    };

  case DEAUTHENTICATE:
    return {
      ...initialState
    };

  default:
    return state;

  }
}
