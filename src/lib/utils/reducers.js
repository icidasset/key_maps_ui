import concat from 'lodash/fp/concat';
import filter from 'lodash/fp/filter';
import find from 'lodash/fp/find';
import flow from 'lodash/fp/flow';


const keepOther = col => item => filter(c => c.id !== item.id, col);


export const doCreate = (state, { payload }, manipulate) => ({
  ...state,

  collection: flow(
    keepOther(state.collection),
    concat(payload),
    manipulate
  )(payload),
});


export const doDelete = (state, { payload }, manipulate) => ({
  ...state,

  collection: flow(
    keepOther(state.collection),
    manipulate
  )(payload),
});


export const doFetch = (state, { payload }, manipulate) => ({
  ...state,

  collection: manipulate(payload),
});


export const doUpdate = doCreate;
