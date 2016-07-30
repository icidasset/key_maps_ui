import { connect } from 'react-redux';
import { browserHistory } from 'react-router';

import * as authActions from '../actions/auth';
import SignOut from '../components/SignOut';


const mapDispatchToProps = (dispatch) => ({
  actions: {
    signOut: () => {
      dispatch(authActions.deauthenticate());
      browserHistory.push('/');
    },
  },
});


export default connect(null, mapDispatchToProps)(SignOut);
