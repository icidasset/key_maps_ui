import { createElement } from 'react';
import { IndexLink, Link } from 'react-router';

import styles from './Header.pcss';
import Container from './Container';


const Header = ({ isSignedIn }) => (
  <header className={styles.Header}>
    <Container>

      <IndexLink to="/" className={styles.logo} tabIndex="-1">Key Maps</IndexLink>

      <IndexLink to="/" activeClassName="is-active">Dashboard</IndexLink>
      { isSignedIn && <Link to="/sign-out">Sign out</Link> }

    </Container>
  </header>
);


export default Header;
