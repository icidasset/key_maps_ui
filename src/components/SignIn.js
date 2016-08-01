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
  fields: { email },
}) => (
  <CenterAbsolute>
    <Container>
      <section className="is-small">

        <Form onSubmit={ handleFormSubmit(
          dispatch,
          submitSignInForm
        )}>

          <section>
            <Input field={email} type="text" placeholder="email" required />
          </section>

          <section style={{ textAlign: 'right' }}>
            <Button component="button" type="submit">Sign in/up</Button>
          </section>

        </Form>
      </section>
    </Container>
  </CenterAbsolute>
);


export default SignIn;
