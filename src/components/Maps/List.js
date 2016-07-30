import { createElement } from 'react';
import { Link } from 'react-router';
import CSSModules from 'react-css-modules';
import styles from './List.pcss';

import { urlifyMapName } from '../../lib/utils/maps';


const List = ({ maps }) => (
  <div styleName="List">
    {maps.map((m, idx) => {
      const slug = urlifyMapName(m.name);

      return (
        <Link to={`/maps/${slug}`} styleName="item" key={idx}>
          <span styleName="name">{m.name}</span>
          <span styleName="info"></span>
        </Link>
      );
    })}
  </div>
);


export default CSSModules(List, styles);
