import { createElement } from 'react';
import ReduxToastr from 'react-redux-toastr';

import styles from './App.pcss';
import Header from './Header';


const App = ({ children, isSignedIn }) => (
  <div className={styles.App}>
    <Header isSignedIn={isSignedIn} />

    <div className={styles.wrapper}>
      {children}
    </div>

    <ReduxToastr />
  </div>
);


export default App;
