import { createElement } from 'react';
import { syncHistoryWithStore } from 'react-router-redux';
import { Router, IndexRoute, Route, browserHistory } from 'react-router';
import { bindActionCreators } from 'redux';
import qs from 'query-string';
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

        { /* Modals */ }
        <Route onEnter={t.isModal}>
          <Route path="maps/new" component={c.Maps__New} onEnter={t.requireAuth} />
        </Route>

        { /* Other */ }
        <Route path="maps/:slug" component={c.Maps__Show} onEnter={t.requireAuth} />

        <Route path="sign-in" component={c.SignIn} />
        <Route path="sign-out" component={c.SignOut} />

        <Route path="state/error" component={c.State__Error} />
        <Route path="state/message" component={c.State__Message} />

      </Route>
    </Router>
  );
};


const buildTransitions = (store) => ({
  isModal: isModal(),
  requireAuth: requireAuth(store),
  preflight: preflight(store),
});


/**
 * Transitions
 */
function isModal() {
  return (nextState, replace) => {
    const loc = nextState.location;
    if (!(loc.state && loc.state.modal)) {
      replace({ pathname: loc.pathname, state: { ...loc.state, modal: true }});
    }
  };
}


function preflight(store) {
  const a = bindActionCreators(
    pick(['authenticateFromStorage', 'exchangeAuth0Token'], actions),
    store.dispatch
  );

  return (_, replace, callback) => {
    const parsedHash = qs.parse(window.location.hash.substr(1));
    const idToken = parsedHash.id_token;

    if (parsedHash.error_description) {
      errorUtils.showErrorScreen(parsedHash.error_description, {}, replace);
      callback();

    } else if (idToken) {
      replace('/');

      a.exchangeAuth0Token(idToken)
        .catch(err => errorUtils.showErrorScreen(err, {}, replace))
        .finally(callback);

    } else {
      a.authenticateFromStorage().then(callback);

    }
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
