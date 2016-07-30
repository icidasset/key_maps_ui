import { createElement } from 'react';
import { lifecycle } from 'recompose';


const SignOut = lifecycle({

  componentWillMount() {
    this.props.actions.signOut();
  },

})(
  () => null
);


export default SignOut;
