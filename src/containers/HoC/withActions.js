import { connect } from 'react-redux';
import pick from 'lodash/fp/pick';

import actions from '../../actions';


export default (component, actionNames) => (
  connect(null, pick(actionNames, actions))(component)
);
