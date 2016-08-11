import { createElement } from 'react';
import { browserHistory } from 'react-router';
import { reduxForm } from 'redux-form';
import map from 'lodash/fp/map';

import Button from '../Button';
import ButtonGroup from '../ButtonGroup';
import EmptyState from '../EmptyState';
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
  slug,
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
        <Button component="button" type="submit">Add item</Button>
      </ButtonGroup>
    </section>

  </Form>
);


const NewForm = reduxForm({
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


export default (props) => (
  props.instMap ?
    (<NewForm {...props} />) :
    (<EmptyState>Loading ...</EmptyState>)
);
