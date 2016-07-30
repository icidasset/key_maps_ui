import { createElement } from 'react';
import Center from 'react-center';
import styles from './CenterAbsolute.pcss';


const CenterAbsolute = ({ children }) => (
  <Center className={styles.CenterAbsolute}>{children}</Center>
);


export default CenterAbsolute;
