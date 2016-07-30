import { getValues } from 'redux-form';
import fromPairs from 'lodash/fp/fromPairs';
import gql from 'graphql-tag';

import capitalize from 'lodash/fp/capitalize';
import map from 'lodash/fp/map';

import { CREATE_MAP_ITEM, FETCH_MAP_ITEMS } from '../lib/types';
import * as api from '../lib/api';


export const createMapItem = (mapObj, attributes) => {
  const types = map((v, k) => `$${k}: ${capitalize(v)}`, mapObj.types);
  const varsMap = map((_, k) => `${k}: $${k}`, mapObj.types);

  return api.gql.mutate({
    mutation: gql`
      mutation _ (${types}) {
        createMapItem (${varsMap}) {
          id,
          map_id,
          attributes
        }
      }
    `,
    variables: {
      ...attributes,

      map: mapObj.name,
    },
  }).then(
    payload => ({ type: CREATE_MAP_ITEM, payload }),
  );
};


export const fetchMapItems = (mapName) => api.gql.query({
  query: gql`
    query _ ($name: String) {
      mapItems(name: $name) {
        id,
        map_id,
        attributes
      }
    }
  `,
  variables: {
    name: mapName,
  },
}).then(
  payload => ({ type: FETCH_MAP_ITEMS, payload }),
);


/**
 * Form handlers
 */
export const submitNewMapItemForm = () => (dispatch, getState) => {
  const params = getValues(getState().form['map_items/new']);

  console.log(params);

  return Promise.resolve({});
};
