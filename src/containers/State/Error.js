import { connect } from 'react-redux';
import StateError from '../../components/State/Error';


const mapStateToProps = (_, ownProps) => ({
  error: { __html: (ownProps.location.state && ownProps.location.state.error) },
});


export default connect(mapStateToProps)(StateError);
