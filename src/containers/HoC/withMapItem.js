import { connect } from 'react-redux';


const mapStateToProps = (state, ownProps) => ({
  instMapItem: state.mapItems.collection.find(i => i.id === ownProps.params.id),
});


export default (component) => (
  connect(mapStateToProps)(component)
);
