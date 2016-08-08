import { connect } from 'react-redux';
import pick from 'lodash/fp/pick';

import Maps__New from '../../components/Maps/New';
import actions from '../../actions';


const _actions = pick(['submitNewMapForm'], actions);


export default connect(null, _actions)(Maps__New);
