import { connect } from 'react-redux';
import StateMessage from '../../components/State/Message';


const mapStateToProps = (_, ownProps) => ({
  message: { __html: (ownProps.location.state && ownProps.location.state.message) },
});


export default connect(mapStateToProps)(StateMessage);
