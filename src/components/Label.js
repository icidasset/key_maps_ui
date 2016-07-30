import { createElement } from 'react';
import styles from './Label.pcss';


const Label = ({ children }) => (
  <label className={styles.Label}>{children}</label>
);


export default Label;
