import { connect } from 'react-redux';
import Fatality from '../components/Fatality';


const mapStateToProps = (_, ownProps) => ({
  error: { __html: (ownProps.location.state && ownProps.location.state.error) },
});


export default connect(mapStateToProps)(Fatality);
