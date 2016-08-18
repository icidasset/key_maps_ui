import { createElement } from 'react';
import { browserHistory } from 'react-router';
import { reduxForm } from 'redux-form';

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
const Import = ({
  dispatch,
  instMap,
  resetForm,
  slug,
  submitImportForm,

  fields: { json },
}) => (
  <Form onSubmit={ handleFormSubmit(
    dispatch,
    submitImportForm,
    `Data added to the map "${instMap.name}"`,
    resetForm
  )}>

    <section>
      <Input
        component="textarea"
        field={json}
        placeholder={`[ { "key": "value" }, ... ]`}
      />
    </section>

    <section style={{ textAlign: 'right' }}>
      <ButtonGroup>
        <Button
          onClick={() => browserHistory.push(`/maps/${slug}`)}
          classNames={['is-destructive']}
        >Close</Button>
        <Button component="button" type="submit">Import</Button>
      </ButtonGroup>
    </section>

  </Form>
);


const ImportForm = reduxForm({
  form: 'map_items/import',
  fields: [
    'map_id',
    'json',
  ],
}, (state, ownProps) => ({
  initialValues: {
    map_id: ownProps.instMap.id,
    json: '',
  },
}))(Import);


export default (props) => (
  props.instMap ?
    (<ImportForm {...props} />) :
    (<EmptyState>Loading ...</EmptyState>)
);
