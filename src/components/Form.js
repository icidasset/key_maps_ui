import { createElement } from 'react';
import styles from './Form.pcss';


const Form = (props) => (
  <form className={styles.Form} {...props} />
);


export default Form;
