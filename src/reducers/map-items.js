import sortBy from 'lodash/fp/sortBy';

import {
  doClear,
  doCreate,
  doCreateMultiple,
  doDelete,
  doFetchWithoutReset,
  doUpdate,
} from '../lib/utils/reducers';

import {
  CREATE_MAP_ITEM,
  CREATE_MAP_ITEMS,
  FETCH_MAP_ITEMS,
  FETCHING_MAP_ITEMS,
  REMOVE_MAP_ITEM,
  RESET,
  UPDATE_MAP_ITEM,
} from '../lib/types';


const initialState = {
  collection: [],
  isFetching: false,
  fetchedFor: [],     // list of mapIDs that we fetched the items for
};


export default function(state = initialState, action) {
  switch (action.type) {

  case RESET: return { ...initialState };
  case CREATE_MAP_ITEM: return doCreate(state, action, sort);
  case CREATE_MAP_ITEMS: return doCreateMultiple(state, action, sort);
  case FETCH_MAP_ITEMS: return { ...doFetchWithoutReset(state, action, sort), isFetching: false };
  case REMOVE_MAP_ITEM: return doDelete(state, action, sort);
  case UPDATE_MAP_ITEM: return doUpdate(state, action, sort);

  case FETCHING_MAP_ITEMS: return {
    ...state,

    isFetching: true,
    fetchedFor: [...state.fetchedFor, action.mapName],
  };

  default:
    return state;

  }
}


function sort(collection) {
  return collection;
}
