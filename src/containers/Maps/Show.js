import { connect } from 'react-redux';
import find from 'lodash/fp/find';
import pick from 'lodash/fp/pick';

import { urlifyMapName } from '../../lib/utils/maps';
import Maps__Show from '../../components/Maps/Show';
import actions from '../../actions';


const _actions = pick(['removeMap', 'submitNewMapItemForm'], actions);


const mapStateToProps = (state, ownProps) => ({
  instMap: find(m => urlifyMapName(m.name) === ownProps.params.slug, state.maps.collection),
  items: [],
});


export default connect(mapStateToProps, _actions)(Maps__Show);
