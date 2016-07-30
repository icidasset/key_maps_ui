import { connect } from 'react-redux';

import { isSignedIn } from '../actions/auth';
import App from '../components/App';


const mapStateToProps = (state) => ({
  isSignedIn: isSignedIn()(null, () => state),
});


export default connect(mapStateToProps)(App);
