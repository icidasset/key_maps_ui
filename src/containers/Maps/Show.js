import { connect } from 'react-redux';
import find from 'lodash/fp/find';
import filter from 'lodash/fp/filter';
import pick from 'lodash/fp/pick';

import { urlifyMapName } from '../../lib/utils/maps';
import Maps__Show from '../../components/Maps/Show';
import actions from '../../actions';


const _actions = pick([
  'fetchMapItems',
  'removeMap',
  'removeMapItem',
  'submitNewMapItemForm',
], actions);


const mapStateToProps = (state, ownProps) => {
  const instMap = find(
    m => urlifyMapName(m.name) === ownProps.params.slug,
    state.maps.collection
  );

  const instMapItems = instMap && filter(
    i => i.map_id === instMap.id,
    state.mapItems.collection
  );

  return {
    instMap,
    instMapItems,
  };
};


export default connect(mapStateToProps, _actions)(Maps__Show);
