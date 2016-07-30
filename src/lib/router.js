import { createElement } from 'react';
import { syncHistoryWithStore } from 'react-router-redux';
import { Router, IndexRoute, Route, browserHistory } from 'react-router';
import { bindActionCreators } from 'redux';
import pick from 'lodash/fp/pick';

import * as containers from '../containers';
import * as errorUtils from './utils/errors';
import actions from '../actions';


export default function router(store) {
  const h = syncHistoryWithStore(browserHistory, store);
  const t = buildTransitions(store);
  const c = containers;

  return (
    <Router history={h}>
      <Route path="/" component={c.App} onEnter={t.preflight}>
        <IndexRoute component={c.Dashboard} onEnter={t.requireAuth} />
        <Route path="maps/:slug" component={c.Maps__Show} onEnter={t.requireAuth} />

        <Route path="sign-in" component={c.SignIn} />
        <Route path="sign-up" component={c.SignUp} />
        <Route path="sign-out" component={c.SignOut} />
        <Route path="fatality" component={c.Fatality} />

      </Route>
    </Router>
  );
};


function buildTransitions(store) {
  return { requireAuth: requireAuth(store), preflight: preflight(store) };
}


/**
 * Transitions
 */
function preflight(store) {
  const a = bindActionCreators(
    pick(['authenticateFromStorage'], actions),
    store.dispatch
  );

  return (_, replace, callback) => {
    a.authenticateFromStorage().then(callback);
  };
}


function requireAuth(store) {
  const a = bindActionCreators(
    pick(['deauthenticate', 'isSignedIn'], actions),
    store.dispatch
  );

  return (_, replace) => {
    if (!a.isSignedIn()) {
      a.deauthenticate();
      replace({ pathname: '/sign-in' });
    }
  };
}
