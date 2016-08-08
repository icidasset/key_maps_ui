import { createElement } from 'react';
import { IndexLink, Link } from 'react-router';

import styles from './Header.pcss';
import Container from './Container';

import DashboardIcon from 'react-icons/lib/go/database';
import PlusIcon from 'react-icons/lib/go/plus';
import SignOutIcon from 'react-icons/lib/go/squirrel';


const Header = ({ isSignedIn }) => (
  <header className={styles.Header}>
    <Container>

      <IndexLink to="/" className={styles.logo} tabIndex="-1">Key Maps</IndexLink>

      {
        isSignedIn &&

        (
          <div className={styles.links}>
            <Link to="/maps/new" activeClassName="is-active" title="Add new map">
              <PlusIcon />
            </Link>
            <IndexLink to="/" activeClassName="is-active" title="Dashboard">
              <DashboardIcon />
            </IndexLink>
            <Link className="is-less-important" to="/sign-out" title="Sign out">
              <SignOutIcon />
            </Link>
          </div>
        )
      }

    </Container>
  </header>
);


export default Header;
