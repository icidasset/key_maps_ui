import sortBy from 'lodash/fp/sortBy';

import { CREATE_MAP_ITEM, FETCH_MAP_ITEMS, REMOVE_MAP_ITEM, RESET } from '../lib/types';
import { doClear, doCreate, doDelete, doFetch } from '../lib/utils/reducers';


const initialState = {
  collection: [],
};


export default function(state = initialState, action) {
  switch (action.type) {

  case RESET: return { ...initialState };
  case CREATE_MAP_ITEM: return doCreate(state, action, sort);
  case FETCH_MAP_ITEMS: return doFetch(state, action, sort);
  case REMOVE_MAP_ITEM: return doDelete(state, action, sort);

  default:
    return state;

  }
}


function sort(collection) {
  return sortBy('map_id', collection);
}
