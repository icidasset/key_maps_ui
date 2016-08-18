import { createElement } from 'react';
import { syncHistoryWithStore } from 'react-router-redux';
import { Router, IndexRoute, Route, browserHistory } from 'react-router';
import { bindActionCreators } from 'redux';
import qs from 'query-string';
import pick from 'lodash/fp/pick';

import * as containers from '../containers';
import * as errorUtils from './utils/errors';
import actions from '../actions';


import maps_New from '../components/Maps/New';
import maps_Settings from '../components/Maps/Settings';

import mapItems_Import from '../components/MapItems/Import';
import mapItems_New from '../components/MapItems/New';


export default function router(store) {
  const h = syncHistoryWithStore(browserHistory, store);
  const t = buildTransitions(store);
  const c = containers;
  const r = (_p, _c) => (<Route path={_p} component={_c} />);

  const wa = c.withActions;
  const wm = c.withMap;

  return (
    <Router history={h}>
      <Route path="/" component={c.App} onEnter={t.preflight}>
        <Route onEnter={t.requireAuth}>

          <IndexRoute component={c.Dashboard} />

          { /* Modals */ }
          <Route onEnter={t.isModal}>
            { r("maps/new",             wa(maps_New,            ['submitNewMapForm']))      }
            { r("maps/:slug/new",       wa(wm(mapItems_New),    ['submitNewMapItemForm']))  }
            { r("maps/:slug/settings",  wa(wm(maps_Settings),   ['updateMap']))             }
            { r("maps/:slug/import",    wa(wm(mapItems_Import), ['submitImportForm']))      }
          </Route>

          { /* Other */ }
          <Route path="maps/:slug" component={c.Maps__Show} />

        </Route>

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
    pick(['authenticateFromStorage', 'exchangeAuth0Token', 'hideLoader'], actions),
    store.dispatch
  );

  return (_, replace, _callback) => {
    const parsedHash = qs.parse(window.location.hash.substr(1));
    const idToken = parsedHash.id_token;
    const callback = () => {
      a.hideLoader();
      return _callback();
    };

    // if ERROR
    if (parsedHash.error_description) {
      errorUtils.showErrorScreen(parsedHash.error_description, {}, replace);
      callback();

    // if NEED_TO_AUTHENTICATE
    } else if (idToken) {
      replace('/');

      a.exchangeAuth0Token(idToken)
        .catch(err => errorUtils.showErrorScreen(err, {}, replace))
        .finally(callback);

    // OTHERWISE
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
