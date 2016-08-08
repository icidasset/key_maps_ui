import { createElement } from 'react';
import styles from './ButtonGroup.pcss';


const ButtonGroup = ({ children }) => (
  <div className={styles.ButtonGroup}>{children}</div>
);


export default ButtonGroup;
