import { createElement } from 'react';
import { browserHistory } from 'react-router';
import fget from 'lodash/fp/get';
import map from 'lodash/fp/map';

import Button from '../Button';
import EmptyState from '../EmptyState';
import Form from '../Form';
import Label from '../Label';


const updateSetting = (instMap, updateMap, key) => (event) => {
  updateMap(
    instMap.id,
    { settings: { ...instMap.settings, [key]: event.target.value }}
  );
};


const Settings = ({
  instMap,
  slug,
  updateMap,
}) => (
  <Form>
    <section>
      <Label>Sort by</Label>
      <select
        defaultValue={fget('settings.uiSortBy', instMap)}
        onChange={updateSetting(instMap, updateMap, 'uiSortBy')}
      >
        <option value="">---</option>
        {map(k => (
          <option key={k} value={k}>{k}</option>
        ), Object.keys(instMap.types))}
      </select>
    </section>

    <section style={{ textAlign: 'right' }}>
      <Button
        onClick={() => browserHistory.push(`/maps/${slug}`)}
        classNames={['is-destructive']}
      >Close</Button>
    </section>
  </Form>
);


export default (props) => (
  props.instMap ?
    (Settings(props)) :
    (<EmptyState>Loading ...</EmptyState>)
);
