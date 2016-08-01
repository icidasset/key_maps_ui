import ApolloClient, { createNetworkInterface } from 'apollo-client';
import { AUTH_TOKEN_STORAGE_KEY } from './constants';


// Transform a non-bluebird promise to a bluebird.js promise.
// Our local Promise is automatically transformed by a babel-js plugin.
const transformPromise = p => Promise.resolve(p);


/**
 * Endpoint
 */
export const endpoint = process.env.API_URL;


/**
 * GraphQL
 */
const n = createNetworkInterface(`${endpoint}/api`);

n.use([

  {
    applyMiddleware(req, next) {
      req.options.headers = req.options.headers || {};
      req.options.headers.authorization = localStorage.getItem(AUTH_TOKEN_STORAGE_KEY);

      next();
    }
  },

]);

export const _gql = new ApolloClient({
  networkInterface: n,
  shouldBatch: false, // TODO: set to true and fix the issues
});

const _handleGQL = (method) => (...args) => {
  return transformPromise(_gql[method](...args)).then(r => {
    const name = r.data && Object.keys(r.data)[0];
    if (name && r.data[name]) return r.data[name];
    throw new Error(r.errors[0].message);
  });
};

export const gql = {
  query: _handleGQL('query'),
  mutate: _handleGQL('mutate'),
};


/**
 * HTTP
 */
export const http = (method, path, params) => {
  const p = fetch(`${endpoint}${path}`, {
    method,
    body: params ? JSON.stringify(params) : undefined,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': localStorage.getItem(AUTH_TOKEN_STORAGE_KEY),
    },
  })
  .then(res => res.json())
  .then(res => {
    if (res.data) return res.data;
    else if (res.errors) throw new Error(res.errors[0].message);
    return res;
  });

  return transformPromise(p);
};
