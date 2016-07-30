import { createElement } from 'react';
import { Link } from 'react-router';

import Button from './Button';
import CenterAbsolute from './CenterAbsolute';
import Container from './Container';
import Form from './Form';
import Input from './Input';
import Note from './Note';

import {
  handleFormSubmit
} from '../lib/utils/forms';


const SignIn = ({
  submitSignInForm,
  children,
  dispatch,
  fields: { login, password },
}) => (
  <CenterAbsolute>
    <Container>
      <section className="is-small">

        <Form onSubmit={ handleFormSubmit(
          dispatch,
          submitSignInForm
        )}>

          <section>
            <Input field={login} type="text" placeholder="email, or username" required />
            <Input field={password} type="password" placeholder="password" required />
          </section>

          <section style={{ textAlign: 'right' }}>
            <Button component="button" type="submit">Sign in</Button>
          </section>

          <Note>
            Looking for the <Link to="/sign-up">sign-up</Link> page?
          </Note>

        </Form>
      </section>
    </Container>
  </CenterAbsolute>
);


export default SignIn;
