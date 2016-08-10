import { createElement } from 'react';
import styles from './LabelBlock.pcss';


const LabelBlock = ({ children }) => (
  <label className={styles.LabelBlock}>{children}</label>
);


export default LabelBlock;
