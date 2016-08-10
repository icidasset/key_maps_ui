import { createElement } from 'react';
import { browserHistory } from 'react-router';
import { compose, lifecycle, withState } from 'recompose';
import fget from 'lodash/fp/get';
import map from 'lodash/fp/map';

import { urlifyMapName } from '../../lib/utils/maps';
import styles from './Show.pcss';

import PlusIcon from 'react-icons/lib/go/plus';
import TrashCanIcon from 'react-icons/lib/go/trashcan';

import Button from '../Button';
import CommandBar from '../CommandBar';
import Container from '../Container';
import EmptyState from '../EmptyState';
import Form from '../Form';
import Label from '../Label';
import LabelBlock from '../LabelBlock';

import ListMapItems from '../MapItems/List';
import NewMapItem from '../MapItems/New';


const remove = (mapID, removeMap) => () => {
  if (confirm('Are you sure you want to remove this map?')) {
    browserHistory.push('/');
    removeMap(mapID);
  }
};


const updateSetting = (instMap, updateMap, key) => (event) => {
  updateMap(
    instMap.id,
    { settings: { ...instMap.settings, [key]: event.target.value }}
  );
};


const actions = (instMap) => [
  {
    onClick: () => browserHistory.push(`/maps/${urlifyMapName(instMap.name)}/add`),
    label: (<span><PlusIcon /> Add item</span>),
  },
];


// <Container>
//   <section>
//     <h2>Add new item</h2>
//     <NewMapItem
//       dispatch={dispatch}
//       instMap={instMap}
//       submitNewMapItemForm={submitNewMapItemForm}
//     />
//   </section>
//
//   <section>
//     <h2>Settings</h2>
//
//     <Form>
//       <p>
//         <Label>Sort by</Label>
//         <select
//           defaultValue={fget('settings.uiSortBy', instMap)}
//           onChange={updateSetting(instMap, updateMap, 'uiSortBy')}
//         >
//           <option value="">---</option>
//           {map(k => (
//             <option key={k} value={k}>{k}</option>
//           ), Object.keys(instMap.types))}
//         </select>
//       </p>
//     </Form>
//
//     <p>
//       <br />
//       <Label>Delete</Label>
//       <div>
//         <Button onClick={remove(instMap.id, removeMap)} classNames={['is-destructive']}>
//           <TrashCanIcon /> Remove from existence
//         </Button>
//       </div>
//     </p>
//   </section>
// </Container>


const Show = ({
  dispatch,
  instMap,
  instMapItems,
  removeMap,
  removeMapItem,
  submitNewMapItemForm,
  updateMap,
  url,
}) => (
  <div>

    { /* TITLE */ }
    <Container>
      <section>
        <h1 className={styles.title}>{instMap.name}</h1>

        <div className={styles.url}>
          <LabelBlock>URL</LabelBlock>
          <a href={url}>{url}</a>
        </div>

        <CommandBar actions={actions(instMap)} />
      </section>
    </Container>


    { /* ITEMS */ }
    <Container>
      <section>
        {
          instMapItems.length

          ?

          <ListMapItems
            items={instMapItems}
            removeMapItem={removeMapItem}
          />

          :

          <EmptyState>
            No items found
          </EmptyState>
        }
      </section>
    </Container>

  </div>
);


function fetchMapItems() {
  if (this.props.instMap && !this.props.didFetchItems) {
    this.props.fetchMapItems(this.props.instMap.name);
    this.props.setDidFetchItems(true);
  }
}


export default compose(
  withState('didFetchItems', 'setDidFetchItems', false),
  lifecycle({

    componentWillMount() { fetchMapItems.call(this); },
    componentWillReceiveProps() { fetchMapItems.call(this); },

  })
)(props => {
  if (props.instMap) return Show(props);
  return (<Container><section><EmptyState>Loading ...</EmptyState></section></Container>);

});
