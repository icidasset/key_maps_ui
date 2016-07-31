import { toastr } from 'react-redux-toastr';
import actions from '../../actions';


const { hideLoader, showLoader } = actions;


export function makeFormFieldValidatable(eventOrNode) {
  if (eventOrNode.target) eventOrNode.target.classList.add('is-validatable');
  else eventOrNode.classList.add('is-validatable');
}


export function checkFormValidity(formEl) {
  const isValid = formEl.checkValidity();

  [].slice
    .call(formEl.querySelectorAll('input, textarea'))
    .forEach(makeFormFieldValidatable);

  return isValid;
}


export function handleFormSubmit(dispatch, action, message, resetForm = null) {
  return (event) => {
    event.preventDefault();
    event.persist();

    // form is invalid, -> exit
    if (!checkFormValidity(event.target)) {
      toastr.error('I think you missed a spot');
      return;
    }

    // error handler
    const errorHandler = (error) => {
      console.error(error);
      toastr.error(error.toString().replace(/(E|e)rror\: /, ''));
    };

    // ---> moving on
    dispatch(showLoader());

    action(event)
      .then(() => {
        if (message) {
          toastr.success(message);
        }

        if (resetForm) {
          const fields = []
            .slice
            .call(event.target.querySelectorAll('input, textarea'));

          if (fields.length > 0) {
            fields.forEach(n => n.classList.remove('is-validatable'));
            fields[0].focus();
          }

          resetForm();
        }
      })
      .catch(errorHandler)
      .finally(() => dispatch(hideLoader()));
  };
};


export function handleInputChange(reduxFormObject) { return event => {
  reduxFormObject.onChange(event);
  makeFormFieldValidatable(event);
}};
