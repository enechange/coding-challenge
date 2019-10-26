import ValidateForm from './_modules/_validateForm';
import SetViewport from './_modules/_setViewport';

window.Promise = Promise;

(() => {
  const validateForm = new ValidateForm();
  $(() => {
    validateForm.init();
  });

  const setViewport = new SetViewport(); // eslint-disable-line no-unused-vars
})();
