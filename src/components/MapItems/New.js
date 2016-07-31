import { createElement } from 'react';
import { reduxForm } from 'redux-form';
import map from 'lodash/fp/map';

import Button from '../Button';
import Form from '../Form';
import Input from '../Input';
import Label from '../Label';

import {
  handleFormSubmit
} from '../../lib/utils/forms';


/**
 * Render
 */
const New = ({
  dispatch,
  instMap,
  resetForm,
  submitNewMapItemForm,

  fields: { attributes },
}) => (
  <Form onSubmit={ handleFormSubmit(
    dispatch,
    submitNewMapItemForm,
    `Added new item to the map "${instMap.name}"`,
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
          required: true,
        };

        return (<Input {...attr} />);
      }, attributes)}
    </section>

    <section style={{ textAlign: 'right' }}>
      <Button component="button" type="submit">Add item</Button>
    </section>

  </Form>
);


export default reduxForm({
  form: 'map_items/new',
  fields: [
    'map_id',
    'attributes[].type',
    'attributes[].key',
    'attributes[].value',
  ],
}, (state, ownProps) => ({
  initialValues: {
    attributes: map(
      k => ({ type: ownProps.instMap.types[k], key: k, value: undefined }),
      Object.keys(ownProps.instMap.types)
    ),
    map_id: ownProps.instMap.id,
  },
}))(New);
