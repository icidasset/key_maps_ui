import { createElement } from 'react';
import styles from './CommandBar.pcss';


const CommandBar = ({ actions }) => (
  <div className={styles.CommandBar}>
    {actions.map((action, idx) => (
      <span key={idx} className={styles.action} onClick={action.onClick}>
        {action.label}
      </span>
    ))}
  </div>
);


export default CommandBar;
