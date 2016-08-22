import { createElement } from 'react';
import { Link } from 'react-router';
import PlusIcon from 'react-icons/lib/go/plus';

import MapsList from './Maps/List';

import Container from './Container';
import EmptyState from './EmptyState';


const Dashboard = ({ dispatch, maps, submitNewMapForm }) => (
  <Container>
    <section>

      {

        maps.length

        ?

        <MapsList
          items={maps}
        />

        :

        <Link to="/maps/new">
          <EmptyState>
            <PlusIcon />
            Nothing here yet<br />
            Click to create a map
          </EmptyState>
        </Link>

      }

    </section>
  </Container>
);


export default Dashboard;
