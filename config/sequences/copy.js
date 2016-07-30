import { copy }  from 'static-base-contrib';
import { runWithMessageAndLimiter }  from 'static-base-preset';


export default (dest, pattern) => (d) => {
  const message = `Copying ${pattern}`;
  const limiter = d.priv.changedPath;

  return runWithMessageAndLimiter(message)(limiter)([copy, dest])(pattern, d.priv.root);
};
