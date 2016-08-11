import { connect } from 'react-redux';
import find from 'lodash/fp/find';
import pick from 'lodash/fp/pick';

import { urlifyMapName } from '../../lib/utils/maps';
import MapItems__New from '../../components/MapItems/New';
import actions from '../../actions';


const _actions = pick(['submitNewMapItemForm'], actions);


const mapStateToProps = (state, ownProps) => {
  const slug = urlifyMapName(ownProps.params.slug);
  const instMap = find(m => urlifyMapName(m.name) === slug, state.maps.collection);

  // ->
  return {
    instMap,
    slug,
  };
};


export default connect(mapStateToProps, _actions)(MapItems__New);
