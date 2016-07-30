import { createElement } from 'react';
import { Link } from 'react-router';

import Button from './Button';
import CenterAbsolute from './CenterAbsolute';
import Container from './Container';
import Form from './Form';
import Note from './Note';

import {
  handleFormSubmit
} from '../lib/utils/forms';


const SignUp = ({
  children,
  dispatch,
  submitSignUpForm,

  fields: { email, password, username },
}) => (
  <CenterAbsolute>
    <Container>
      <section className="is-small">

        <Form onSubmit={ handleFormSubmit(
          dispatch,
          submitSignUpForm
        )}>

          <section>
            <input type="email" placeholder="email" {...email} required />
            <input type="password" placeholder="password" {...password} required />
            <input type="text" placeholder="username" {...username} required />
          </section>

          <section style={{ textAlign: 'right' }}>
            <Button component="button" type="submit">Sign up</Button>
          </section>

          <Note>
            Looking for the <Link to="/sign-in">sign-in</Link> page?
          </Note>

        </Form>

      </section>
    </Container>
  </CenterAbsolute>
);


export default SignUp;
