import { createElement } from 'react';
import { reduxForm } from 'redux-form';
import map from 'lodash/fp/map';

import EmptyState from '../EmptyState';
import Loader from '../Loader';
import Input from '../Input';
import Form, { FIELDS } from './Form';


/**
 * Render
 */
const Edit = (props) => (
  <Form
    {...props}
    submitHandler={props.submitEditMapItemForm}
    submitMessage={'Item updated'}
    buttonLabel="Update item"
  />
);


const EditForm = reduxForm({
  form: 'map_items/edit',
  fields: [...FIELDS, 'id'],
}, (state, ownProps) => ({
  initialValues: {
    attributes: map(
      k => ({
        type: ownProps.instMap.types[k],
        key: k,
        value: ownProps.instMapItem.attributes[k],
      }),
      Object.keys(ownProps.instMap.types)
    ),
    map_id: ownProps.instMap.id,
    id: ownProps.instMapItem.id,
  },
}))(Edit);


export default (props) => (
  props.instMap && props.instMapItem ?
    (<EditForm {...props} />) :
    (<EmptyState><Loader /></EmptyState>)
);
