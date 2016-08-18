import { connect } from 'react-redux';
import fget from 'lodash/fp/get';
import find from 'lodash/fp/find';
import filter from 'lodash/fp/filter';
import flow from 'lodash/fp/flow';
import pick from 'lodash/fp/pick';
import sortBy from 'lodash/fp/sortBy';

import { retrieveMap } from '../../lib/utils/maps';
import { endpoint } from '../../lib/api';
import Maps__Show from '../../components/Maps/Show';
import actions from '../../actions';


const _actions = pick([
  'fetchMapItems',
  'removeMap',
  'removeMapItem',
], actions);


const mapStateToProps = (state, ownProps) => {
  const [ instMap, slug ] = retrieveMap(ownProps.params.slug, state.maps.collection);

  // items
  const sortKey = (fget('settings.uiSortBy', instMap)) ||
                  (instMap && Object.keys(instMap.types)[0]);

  const instMapItems = instMap && flow(
    filter(i => i.map_id === instMap.id),
    sortBy(i => i.attributes[sortKey])
  )(
    state.mapItems.collection
  );

  // url
  const id = state.auth.user.id;
  const url = instMap && `${endpoint}/public/${id}/${slug}`;

  // ->
  return {
    instMap,
    instMapItems,
    url,
    slug,
  };
};


export default connect(mapStateToProps, _actions)(Maps__Show);
