import { SET_CONFIG_SETTINGS } from './action';

export const config = (state = {}, action) => {
  switch (action.type) {
  case SET_CONFIG_SETTINGS:
    let additionalObj = {};
    if (action.show_partner_promo === true || action.show_partner_promo === false) {
      additionalObj = {
        show_partner_promo: action.show_partner_promo
      };
    }

    return Object.assign({}, state, {
      host: action.host,
      csrf_token: action.csrf_token,
      auth_host: action.auth_host,
      auth_token: action.auth_token,
      fb_app_id: action.fb_app_id
    }, additionalObj);
  default:
    return state;
  }
};