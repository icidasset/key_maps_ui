import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import pick from 'lodash/fp/pick';

import SignUp from '../components/SignUp';
import actions from '../actions';


const _actions = pick(['submitSignUpForm'], actions);


const WithReduxForm = reduxForm({
  form: 'sign-up',
  fields: [
    'email',
    'password',
    'username',
  ],
})(SignUp);


export default connect(null, _actions)(WithReduxForm);
