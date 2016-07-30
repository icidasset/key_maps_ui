export function showErrorScreen(error, options, replace) {
  console.error(error);

  error = error.toString();
  options = { origin: 'Somewhere in the matrix', ...options };

  if (error.includes('Failed to fetch')) {
    error = 'Could not reach the API';
  } else if (error.includes('TypeError: ')) {
    error = error.replace('TypeError: ', '');
  }

  (replace || browserHistory.push)({
    pathname: '/fatality',
    state: {
      error: error.replace(/\w+ \/ /, ''),
      origin: options.origin,
    },
  });
}
