import sortBy from 'lodash/fp/sortBy';

import { CREATE_MAP, FETCH_MAPS, REMOVE_MAP, RESET } from '../lib/types';
import { doClear, doCreate, doDelete, doFetch } from '../lib/utils/reducers';


const initialState = {
  collection: [],
};


export default function(state = initialState, action) {
  switch (action.type) {

  case RESET: return { ...initialState };
  case CREATE_MAP: return doCreate(state, action, sort);
  case FETCH_MAPS: return doFetch(state, action, sort);
  case REMOVE_MAP: return doDelete(state, action, sort);

  default:
    return state;

  }
}


function sort(collection) {
  return sortBy('name', collection);
}
