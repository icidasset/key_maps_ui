import concat from 'lodash/fp/concat';
import filter from 'lodash/fp/filter';
import find from 'lodash/fp/find';
import flow from 'lodash/fp/flow';


const keepOther = col => item => filter(c => c.id !== item.id, col);


export const doCreate = (state, { payload }, sort) => ({
  ...state,

  collection: flow(
    keepOther(state.collection),
    concat(payload),
    sort
  )(payload),
});


export const doDelete = (state, { payload }, sort) => ({
  ...state,

  collection: flow(
    keepOther(state.collection),
    sort
  )(payload),
});


export const doFetch = (state, { payload }, sort) => ({
  ...state,

  collection: sort(payload),
});


export const doUpdate = doCreate;
