import { createElement } from 'react';
import styles from './Table.pcss';


const Table = ({ children }) => (
  <table className={styles.Table}>{children}</table>
);


export default Table;
