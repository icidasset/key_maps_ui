import { createElement } from 'react';
import map from 'lodash/fp/map';
import toPairs from 'lodash/fp/toPairs';
import TrashCanIcon from 'react-icons/lib/go/trashcan';

import styles from './List.pcss';

import LabelBlock from '../LabelBlock';
import Table from '../Table';


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
                x => (
                  <div className={styles.dataRow} key={x[0]}>
                    <span>{x[0]}</span>
                    <div>{x[1]}</div>
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
        ), items)}
      </tbody>
    </Table>

  </div>
);


export default List;
