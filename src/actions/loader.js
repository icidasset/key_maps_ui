import { HIDE_LOADER, SHOW_LOADER } from '../lib/types';


export const showLoader = () => ({ type: SHOW_LOADER });
export const hideLoader = () => ({ type: HIDE_LOADER });
