import { createElement } from 'react';
import { browserHistory } from 'react-router';
import { reduxForm } from 'redux-form';

import ContentEditable from 'react-contenteditable';
import TrashCanIcon from 'react-icons/lib/go/trashcan';

import slug from 'slug';

import Button from '../Button';
import ButtonGroup from '../ButtonGroup';
import Form from '../Form';
import Input from '../Input';
import Label from '../Label';
import Table from '../Table';
import TableSuffix from '../TableSuffix';

import {
  handleFormSubmit
} from '../../lib/utils/forms';


/**
 * Constants
 */
const ATTRIBUTE_TYPES = ['string', 'text', 'number'];
const SAMPLE_ATTRIBUTE = { name: 'example', type: ATTRIBUTE_TYPES[0] };


/**
 * Utils
 */
function slugifyName(t) {
  return slug(
    t.trim().replace(/(&nbsp;|<div>|<br>|<\/div>|\s)+/g, ''),
    { lower: true, replacement: '_', remove: /[-]/g }
  );
}


/**
 * Render
 */
const New = ({
  dispatch,
  returnTo,
  submitNewMapForm,

  fields: { attributes, name },
}) => (
  <Form onSubmit={ handleFormSubmit(
    dispatch,
    submitNewMapForm,
    "New map created",
  )}>

    <section>
      <Input type="text" placeholder="Map name" field={name} />
    </section>

    <section>
      <Label>Attributes</Label>
      <Table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
            <th data-action>&nbsp;</th>
          </tr>
        </thead>
        <tbody>
          {attributes.map((a, idx) => (
            <tr key={idx}>
              <td>
                <ContentEditable
                  html={a.name.value}
                  onChange={e => {
                    const name = slugifyName(e.target.value);
                    a.name.onChange(name);
                  }}
                />
              </td>
              <td>
                <select
                  value={a.type.value}
                  onChange={e => {
                    a.type.onChange(e.target.value);
                  }}
                >
                  {ATTRIBUTE_TYPES.map((t, idx) => (
                    <option key={idx} value={t}>{t}</option>
                  ))}
                </select>
              </td>
              <td data-action>
                <a onClick={() => attributes.removeField(idx)}>
                  <TrashCanIcon />
                </a>
              </td>
            </tr>
          ))}
        </tbody>
      </Table>
      <TableSuffix>
        <a onClick={() => attributes.addField(SAMPLE_ATTRIBUTE)}>
          + Add new attribute
        </a>
      </TableSuffix>
    </section>

    <section style={{ textAlign: 'right' }}>
      <ButtonGroup>
        <Button
          onClick={() => browserHistory.push(returnTo)}
          classNames={['is-destructive']}
        >Cancel</Button>
        <Button component="button" type="submit">Create map</Button>
      </ButtonGroup>
    </section>

  </Form>
);


export default reduxForm({
  form: 'maps/new',
  fields: [
    'name',
    'attributes[].name',
    'attributes[].type',
  ],
}, () => ({
  initialValues: {
    attributes: [SAMPLE_ATTRIBUTE]
  },
}))(New);
