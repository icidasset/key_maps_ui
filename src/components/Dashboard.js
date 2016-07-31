import { createElement } from 'react';

import NewMap from './Maps/New';
import MapsList from './Maps/List';

import Container from './Container';
import EmptyState from './EmptyState';


const Dashboard = ({ dispatch, maps, submitNewMapForm }) => (
  <Container>

    <section>
      <h2>Existing maps</h2>
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


    <section>
      <h2>Add a new map</h2>
      <NewMap dispatch={dispatch} submitNewMapForm={submitNewMapForm} />
    </section>

  </Container>
);


export default Dashboard;
