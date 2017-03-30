/**
 * This is the file to combine all the reducers
 */
import { combineReducers } from 'redux';
import { config } from './config/reducer';
import { listing } from './listing/reducer';

export const reducers = combineReducers({
  config,
  listing
});