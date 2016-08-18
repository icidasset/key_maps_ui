import { connect } from 'react-redux';
import { retrieveMap } from '../../lib/utils/maps';


const mapStateToProps = (state, ownProps) => {
  const [ instMap, slug ] = retrieveMap(ownProps.params.slug, state.maps.collection);
  return { instMap, slug };
};


export default (component) => (
  connect(mapStateToProps)(component)
);
