import { createElement } from 'react';
import styles from './EmptyState.pcss';


const EmptyState = ({ children }) => (
  <div className={styles.EmptyState}>{children}</div>
);


export default EmptyState;
