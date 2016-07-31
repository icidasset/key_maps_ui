import { browserHistory } from 'react-router';
import { getValues } from 'redux-form';

import { AUTHENTICATE, DEAUTHENTICATE, RESET } from '../lib/types';
import { AUTH_TOKEN_STORAGE_KEY, AUTH_USER_STORAGE_KEY } from '../lib/constants';
import * as api from '../lib/api';

import { fetchMaps } from './maps';


export const authenticate = (attr) => (dispatch) => {
  localStorage.setItem(AUTH_TOKEN_STORAGE_KEY, attr.token);
  localStorage.setItem(AUTH_USER_STORAGE_KEY, JSON.stringify(attr.user));

  dispatch({ type: AUTHENTICATE, ...attr });
  dispatch(fetchMaps());

  return null;
};


export const deauthenticate = () => (dispatch) => {
  localStorage.removeItem(AUTH_TOKEN_STORAGE_KEY);
  localStorage.removeItem(AUTH_USER_STORAGE_KEY);

  dispatch({ type: DEAUTHENTICATE });
  dispatch({ type: RESET });
  dispatch({ type: 'APOLLO_STORE_RESET' });

  return null;
};


export const authenticateFromStorage = () => (dispatch) => {
  const storedToken = localStorage.getItem(AUTH_TOKEN_STORAGE_KEY);
  const storedUserData = localStorage.getItem(AUTH_USER_STORAGE_KEY);

  if (storedToken && storedToken.length > 0) {
    const attr = {
      token: storedToken,
      user: storedUserData && JSON.parse(storedUserData),
    };

    return validateToken(storedToken)
      .then(() => dispatch(authenticate(attr)))
      .catch(() => dispatch(deauthenticate()));
  }

  return Promise.resolve();
};


const validateToken = token => {
  return api.http('GET', `/validate-token?token=${token}`);
};


/**
 * Getters
 */
export const isSignedIn = () => (_, getState) => {
  return getState().auth.token && localStorage.getItem(AUTH_TOKEN_STORAGE_KEY);
};


/**
 * Form handlers
 */
export const submitSignInForm = () => (dispatch, getState) => {
  const params = getValues(getState().form['sign-in']);

  return api.http('POST', '/sign-in', params).then(data => {
    dispatch(authenticate(data));
    browserHistory.push('/');
    return data;
  });
};


export const submitSignUpForm = () => (dispatch, getState) => {
  const params = getValues(getState().form['sign-up']);

  return api.http('POST', '/sign-up', params).then(data => {
    dispatch(authenticate(data));
    browserHistory.push('/');
    return data;
  });
};
