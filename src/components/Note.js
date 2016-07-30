import { createElement } from 'react';
import styles from './Note.pcss';


const Note = ({ children }) => (
  <div className={styles.Note}>{children}</div>
);


export default Note;
