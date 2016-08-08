import { createElement } from 'react';

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

        <EmptyState>
          No maps found
        </EmptyState>

      }

    </section>
  </Container>
);


export default Dashboard;
