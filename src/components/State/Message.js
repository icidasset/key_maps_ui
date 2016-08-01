import { createElement } from 'react';
import CSSModules from 'react-css-modules';

import styles from './Message.pcss';
import CenterAbsolute from '../CenterAbsolute';
import Container from '../Container';


const StateMessage = ({ message }) => (
  <CenterAbsolute>
    <Container>
      <section styleName="Message">

        <p dangerouslySetInnerHTML={message} />

      </section>
    </Container>
  </CenterAbsolute>
);


export default CSSModules(StateMessage, styles);
