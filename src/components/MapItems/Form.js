import { createElement } from 'react';
import { browserHistory } from 'react-router';
import map from 'lodash/fp/map';

import Button from '../Button';
import ButtonGroup from '../ButtonGroup';
import Form from '../Form';
import Input from '../Input';
import Label from '../Label';

import {
  handleFormSubmit
} from '../../lib/utils/forms';


export const FIELDS = [
  'map_id',
  'attributes[].type',
  'attributes[].key',
  'attributes[].value',
];


export default ({
  buttonLabel,
  dispatch,
  resetForm,
  slug,

  submitMessage,
  submitHandler,

  fields: { attributes },
}) => (
  <Form onSubmit={ handleFormSubmit(
    dispatch,
    submitHandler,
    submitMessage,
    resetForm
  )}>

    <section>
      {map(a => {
        let component = 'input';
        let type = 'text';

        if (a.type.value === 'text') component = 'textarea';
        else if (a.type.value === 'number') type = 'number';

        const attr = {
          component: component,
          key: a.key.value,
          field: a.value,
          type: type,
          placeholder: a.key.value,
        };

        return (<Input {...attr} />);
      }, attributes)}
    </section>

    <section style={{ textAlign: 'right' }}>
      <ButtonGroup>
        <Button
          onClick={() => browserHistory.push(`/maps/${slug}`)}
          classNames={['is-destructive']}
        >Close</Button>
        <Button
          component="button"
          type="submit"
          classNames={['is-assisting']}
        >{buttonLabel}</Button>
      </ButtonGroup>
    </section>

  </Form>
);
