import { createElement } from 'react';
import { Link } from 'react-router';
import CSSModules from 'react-css-modules';
import map from 'lodash/fp/map';

import { urlifyMapName } from '../../lib/utils/maps';
import styles from './List.pcss';


const List = ({ items }) => (
  <div styleName="List">
    {map(m => {
      const slug = urlifyMapName(m.name);

      return (
        <Link to={`/maps/${slug}`} styleName="item" key={m.id}>
          <span styleName="name">{m.name}</span>
          <span styleName="info"></span>
        </Link>
      );
    }, items)}
  </div>
);


export default CSSModules(List, styles);
