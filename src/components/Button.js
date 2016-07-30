import { createElement } from 'react';
import { compose, defaultProps, componentFromProp, mapProps } from 'recompose';
import omit from 'lodash/fp/omit';

import styles from './Button.pcss';


const Button = compose(
  mapProps(props => {
    const classNames = [ ...(props.classNames || []), styles.Button ];
    return omit(['classNames'], { ...props, className: classNames.join(' ') });
  }),
  defaultProps({ component: 'a' }),
)(
  componentFromProp('component')
);


export default Button;
