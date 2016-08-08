import { createElement } from 'react';
import { browserHistory } from 'react-router';
import ReactModal from 'react-modal';

import styles from './Modal.pcss';


const Modal = ({ children, isOpen, options = {}, returnTo }) => (
  <ReactModal
    isOpen={isOpen}
    className={styles.ModalContainer}
    overlayClassName={styles.Modal}
    onRequestClose={() => browserHistory.push(returnTo)}
    closeTimeoutMS={250 + 50}
  >
    {children}
  </ReactModal>
);


export default Modal;
