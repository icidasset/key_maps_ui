import { createElement } from 'react';
import { browserHistory, Link } from 'react-router';
import { compose, lifecycle, withState } from 'recompose';
import fget from 'lodash/fp/get';

import styles from './Show.pcss';

import ImportIcon from 'react-icons/lib/go/clippy';
import SettingsIcon from 'react-icons/lib/go/settings';
import PlusIcon from 'react-icons/lib/go/plus';
import TrashCanIcon from 'react-icons/lib/go/trashcan';

import Button from '../Button';
import CommandBar from '../CommandBar';
import Container from '../Container';
import EmptyState from '../EmptyState';
import Label from '../Label';
import LabelBlock from '../LabelBlock';
import Loader from '../Loader';

import ListMapItems from '../MapItems/List';
import NewMapItem from '../MapItems/New';


const remove = (mapID, removeMap) => () => {
  if (confirm('Are you sure you want to remove this map?')) {
    browserHistory.push('/');
    removeMap(mapID);
  }
};


const actions = (slug, instMap, removeMap) => [
  {
    onClick: () => browserHistory.push(`/maps/${slug}/new`),
    label: (<span><PlusIcon /> Add item</span>),
  },
  {
    onClick: () => browserHistory.push(`/maps/${slug}/import`),
    label: (<span><ImportIcon /> Import data</span>),
  },
  {
    onClick: () => browserHistory.push(`/maps/${slug}/settings`),
    label: (<span><SettingsIcon /> Settings</span>),
  },
  {
    onClick: remove(instMap.id, removeMap),
    label: (<span><TrashCanIcon /> Remove map</span>),
  },
];


const Show = ({
  instMap,
  instMapItems,
  isFetching,
  removeMap,
  removeMapItem,
  slug,
  submitNewMapItemForm,
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

        <CommandBar actions={actions(slug, instMap, removeMap)} />
      </section>
    </Container>


    { /* ITEMS */ }
    <Container>
      <section>
        {
          isFetching

          ?

          <EmptyState>
            <Loader />
          </EmptyState>

          :

          (

            instMapItems.length

            ?

            <ListMapItems
              items={instMapItems}
              removeMapItem={removeMapItem}
              sortedBy={fget('settings.uiSortBy', instMap)}
              mapSlug={slug}
            />

            :

            <Link to={`/maps/${slug}/new`}>
              <EmptyState>
                <PlusIcon />
                Nothing here yet<br />
                Click to add something
              </EmptyState>
            </Link>

          )
        }
      </section>
    </Container>

  </div>
);


export default props => {
  if (props.instMap) return Show(props);
  return null;
};
