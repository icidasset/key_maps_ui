import { createElement } from 'react';
import { browserHistory } from 'react-router';
import TrashCan from 'react-icons/lib/go/trashcan';

import Button from '../Button';
import Container from '../Container';
import EmptyState from '../EmptyState';
import NewMapItem from '../MapItems/New';


const remove = (mapID, removeMap) => () => {
  if (confirm('Are you sure you want to remove this map?')) {
    browserHistory.push('/');
    removeMap(mapID);
  }
};


const Show = ({ dispatch, instMap, items, removeMap, submitNewMapItemForm }) => (
  <div>

    { /* TITLE */ }
    <Container>
      <h1>{instMap.name}</h1>
    </Container>


    { /* ITEMS */ }
    <Container>
      <section>
        <h2>Add new item</h2>
        <NewMapItem
          dispatch={dispatch}
          instMap={instMap}
          submitNewMapItemForm={submitNewMapItemForm}
        />
      </section>

      <section>
        <h2>Manage</h2>

        <Button onClick={remove(instMap.id, removeMap)} classNames={['is-destructive']}>
          <TrashCan /> Remove from existence
        </Button>
      </section>
    </Container>


    { /* ITEMS */ }
    <Container>
      <section>
        <h2>Items</h2>

        {
          items.length

          ?

          []

          :

          <EmptyState>
            No items found
          </EmptyState>
        }
      </section>
    </Container>

  </div>
);


export default props => {
  if (props.instMap) return Show(props);
  return (<EmptyState>Loading ...</EmptyState>);
};
