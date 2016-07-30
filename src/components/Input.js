import { createElement } from 'react';
import { compose, defaultProps, componentFromProp, mapProps } from 'recompose';
import merge from 'lodash/fp/merge';
import omit from 'lodash/fp/omit';

import list from '../lib/tags/list';


const FIELD_PROPERTIES_TO_OMIT = list`
  active
  autofill
  autofilled
  dirty
  initialValue
  invalid
  onUpdate
  pristine
  touched
  valid
  visited
`;


const Input = compose(
  mapProps(props => {
    let attr = omit(['field'], props);

    if (props.field) {
      attr = merge(attr, omit(FIELD_PROPERTIES_TO_OMIT, props.field));
    }

    return attr;
  }),
  defaultProps({ component: 'input' }),
)(
  componentFromProp('component')
);


export default Input;
