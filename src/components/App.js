import { cloneElement, createElement, Component } from 'react';
import ReduxToastr from 'react-redux-toastr';

import styles from './App.pcss';
import Header from './Header';
import Modal from './Modal';


const render = ({ children, isModal, isSignedIn, previousChildren, returnTo }) => (
  <div className={styles.App}>
    <Header isSignedIn={isSignedIn} />

    <div className={styles.wrapper}>
      {isModal ? previousChildren : children}

      <Modal
        isOpen={isModal}
        returnTo={returnTo}
      >
        {isModal ? children : previousChildren}
      </Modal>
    </div>

    <ReduxToastr />
  </div>
);


/**
 * Keep state for modals
 */
const processProps = (props) => {
  const { location, children, previousChildren, previousRoute } = props;
  let returnTo;

  // returnTo path is either the path given by state, the previous route or root
  // -> special case, returnTo can't be '/oops'
  returnTo = ((location.state && location.state.returnTo) || previousRoute || '/');
  returnTo = (returnTo.match(/^\/?state\/error/) ? '/' : returnTo);

  // result
  return {
    ...props,
    children: children && cloneElement(children, { returnTo }),
    isModal: !!(location.state && location.state.modal),
    previousChildren: previousChildren && cloneElement(previousChildren, { returnTo }),
    returnTo: returnTo,
  };
}


class App extends Component {

  componentWillMount() {
    this.processedProps = processProps(this.props);
  }


  componentWillReceiveProps(nextProps) {
    this.processedProps = processProps({
      ...nextProps,
      previousChildren: this.props.children,
      previousRoute: this.props.location && this.props.location.pathname,
    });
  }


  render() {
    return render(this.processedProps);
  }

}


export default App;
