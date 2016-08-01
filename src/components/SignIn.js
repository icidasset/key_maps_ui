import { createElement } from 'react';
import { Link } from 'react-router';

import Button from './Button';
import CenterAbsolute from './CenterAbsolute';
import Container from './Container';
import Form from './Form';
import Label from './Label';
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
            <Label>Email</Label>
            <Input field={email} type="email" placeholder="example@gmail.com" required />
          </section>

          <section style={{ textAlign: 'right' }}>
            <Button component="button" type="submit">
              Sign in &nbsp;&nbsp;|&nbsp;&nbsp; sign up
            </Button>
          </section>

        </Form>
      </section>
    </Container>
  </CenterAbsolute>
);


export default SignIn;
