import { createElement } from 'react';
import { Provider } from 'react-redux';
import ReactDOM from 'react-dom';

import 'isomorphic-fetch';

import router from './lib/router';
import store from './lib/store';


// render react
ReactDOM.render(
  <Provider store={store}>{ router(store) }</Provider>,
  document.getElementById('react-mount')
);
