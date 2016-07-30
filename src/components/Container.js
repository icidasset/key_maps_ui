import { createElement } from 'react';
import styles from './Container.pcss';


const Container = ({ children }) => (
  <div className={styles.Container}>{children}</div>
);


export default Container;
