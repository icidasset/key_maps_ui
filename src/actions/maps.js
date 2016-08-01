import { getValues } from 'redux-form';
import gql from 'graphql-tag';

import fromPairs from 'lodash/fp/fromPairs';
import map from 'lodash/fp/map';

import { CREATE_MAP, FETCH_MAPS, REMOVE_MAP, UPDATE_MAP } from '../lib/types';
import * as api from '../lib/api';


// CREATE
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


// FETCH
export const fetchMaps = () => api.gql.query({
  query: gql`
    {
      maps {
        id,
        name,
        attributes,
        types,
        settings
      }
    }
  `
}).then(
  payload => ({ type: FETCH_MAPS, payload }),
);


// REMOVE
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


// UPDATE
export const updateMap = (mapID, params) => api.gql.mutate({
  mutation: gql`
    mutation _ (
      $id: Int,

      $name: String,
      $attributes: Array,
      $types: Object,
      $settings: Object
    ) {
      updateMap (
        id: $id,

        name: $name,
        attributes: $attributes,
        types: $types,
        settings: $settings
      ) {
        id,
        name,
        attributes,
        types,
        settings
      }
    }
  `,
  variables: {
    id: mapID,
    name: params.name,
    attributes: params.attributes,
    types: params.types,
    settings: params.settings,
  },
}).then(
  payload => ({ type: UPDATE_MAP, payload }),
);


/**
 * Form handlers
 */
export const submitNewMapForm = () => (dispatch, getState) => {
  const params = getValues(getState().form['maps/new']);
  const attributes = map(a => a.name, params.attributes);
  const types = fromPairs(map(a => [a.name, a.type], params.attributes));

  return dispatch(createMap(params.name, attributes, types));
};
