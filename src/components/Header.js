import { createElement } from 'react';
import { IndexLink, Link } from 'react-router';

import styles from './Header.pcss';
import Container from './Container';


const Header = ({ isSignedIn }) => (
  <header className={styles.Header}>
    <Container>

      <IndexLink to="/" className={styles.logo} tabIndex="-1">Key Maps</IndexLink>

      {
        isSignedIn &&

        (
          <div className={styles.links}>
            <IndexLink to="/" activeClassName="is-active">Dashboard</IndexLink>
            <Link to="/sign-out">Sign out</Link>
          </div>
        )
      }

    </Container>
  </header>
);


export default Header;
