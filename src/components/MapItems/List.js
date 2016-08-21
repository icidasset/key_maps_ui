import { createElement } from 'react';
import map from 'lodash/fp/map';
import toPairs from 'lodash/fp/toPairs';

import Infinite from 'react-list';
import TrashCanIcon from 'react-icons/lib/go/trashcan';

import styles from './List.pcss';

import LabelBlock from '../LabelBlock';
import Table from '../Table';


const remove = (mapItemID, removeMapItem) => () => {
  if (confirm('Are you sure you want to remove this item?')) {
    removeMapItem(mapItemID);
  }
};


const renderItem = ({ items, removeMapItem, sortedBy }) => (idx, key) => {
  const i = items[idx];

  return (
    <tr key={key}>
      <td>
      {
        map(
          x => (
            <div className={styles.dataRow} key={x[0]}>
              <span>{x[0]}</span>
              <div>{x[0] === sortedBy ? <strong>{x[1]}</strong> : x[1]}</div>
            </div>
          ),
          toPairs(i.attributes)
        )
      }
      </td>
      <td data-action>
        <a onClick={remove(i.id, removeMapItem)}>
          <TrashCanIcon />
        </a>
      </td>
    </tr>
  );
};


const List = (props) => (
  <div className={styles.List}>
    <Table>
      <thead>
        <tr>
          <th>Data</th>
          <th data-action>&nbsp;</th>
        </tr>
      </thead>
      <Infinite
        itemRenderer={renderItem(props)}
        itemsRenderer={(items, ref) => <tbody ref={ref}>{items}</tbody>}
        length={props.items.length}
      />
    </Table>
  </div>
);


export default List;
