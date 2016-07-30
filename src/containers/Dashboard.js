import { connect } from 'react-redux';
import pick from 'lodash/fp/pick';

import Dashboard from '../components/Dashboard';
import actions from '../actions';


const _actions = pick(['submitNewMapForm'], actions);


const mapStateToProps = state => ({
  maps: state.maps.collection,
});


export default connect(mapStateToProps, _actions)(Dashboard);
