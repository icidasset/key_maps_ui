import { createElement } from 'react';
import map from 'lodash/fp/map';
import toPairs from 'lodash/fp/toPairs';
import TrashCan from 'react-icons/lib/go/trashcan';

import Table from '../Table';
import styles from './List.pcss';


const remove = (mapItemID, removeMapItem) => () => {
  if (confirm('Are you sure you want to remove this item?')) {
    removeMapItem(mapItemID);
  }
};


const List = ({ items, removeMapItem }) => (
  <div className={styles.List}>

    <Table>
      <thead>
        <tr>
          <th>Data</th>
          <th data-action>&nbsp;</th>
        </tr>
      </thead>
      <tbody>
        {map(i => (
          <tr key={i.id}>
            <td>
            {
              map(
                x => (<div key={x[0]}><strong>{x[0]}</strong>: <span>{x[1]}</span><br /></div>),
                toPairs(i.attributes)
              )
            }
            </td>
            <td data-action>
              <a onClick={remove(i.id, removeMapItem)}>
                <TrashCan />
              </a>
            </td>
          </tr>
        ), items)}
      </tbody>
    </Table>

  </div>
);


export default List;
