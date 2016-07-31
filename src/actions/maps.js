import { getValues } from 'redux-form';
import fromPairs from 'lodash/fp/fromPairs';
import gql from 'graphql-tag';
import map from 'lodash/fp/map';

import { CREATE_MAP, FETCH_MAPS, REMOVE_MAP } from '../lib/types';
import * as api from '../lib/api';


export const createMap = (name, attributes, types) => api.gql.mutate({
  mutation: gql`
    mutation _ (
      $name: String,
      $attributes: Array,
      $types: Object
    ) {
      createMap (
        name: $name,
        attributes: $attributes,
        types: $types
      ) {
        id,
        name,
        attributes,
        types
      }
    }
  `,
  variables: {
    name,
    attributes,
    types,
  },
}).then(
  payload => ({ type: CREATE_MAP, payload }),
);


export const fetchMaps = () => api.gql.query({
  query: gql`
    {
      maps {
        id,
        name,
        attributes,
        types
      }
    }
  `
}).then(
  payload => ({ type: FETCH_MAPS, payload }),
);


export const removeMap = (id) => (dispatch) => {
  dispatch({ type: REMOVE_MAP, payload: { id }});

  return api.gql.mutate({
    mutation: gql`
      mutation _ ($id: ID) {
        removeMap (id: $id) { id }
      }
    `,
    variables: {
      id,
    },
  });
};


/**
 * Form handlers
 */
export const submitNewMapForm = () => (dispatch, getState) => {
  const params = getValues(getState().form['maps/new']);
  const attributes = map(a => a.name, params.attributes);
  const types = fromPairs(map(a => [a.name, a.type], params.attributes));

  return dispatch(createMap(params.name, attributes, types));
};
