import thunk from 'redux-thunk';
import promises from 'redux-promise';
import { applyMiddleware, combineReducers, createStore } from 'redux';
import { routerReducer as routing } from 'react-router-redux';
import { reducer as form } from 'redux-form';
import { reducer as toastr } from 'react-redux-toastr';

import * as reducers from '../reducers';
import { _gql } from './api';


const apollo = _gql.reducer();
const apolloMiddleware = _gql.middleware();


export default createStore(
  combineReducers({ ...reducers, form, routing, toastr, apollo }),
  applyMiddleware(thunk, promises, apolloMiddleware)
);
