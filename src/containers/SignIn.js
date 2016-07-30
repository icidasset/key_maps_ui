import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import pick from 'lodash/fp/pick';

import SignIn from '../components/SignIn';
import actions from '../actions';


const _actions = pick(['submitSignInForm'], actions);


const WithReduxForm = reduxForm({
  form: 'sign-in',
  fields: [
    'login',
    'password',
  ],
})(SignIn);


export default connect(null, _actions)(WithReduxForm);
