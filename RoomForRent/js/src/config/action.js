export const SET_CONFIG_SETTINGS = 'SET_CONFIG_SETTINGS';

export const setConfigSettings = (config) => {
  return {
    type: SET_CONFIG_SETTINGS,
    host: config.host,
    csrf_token: config.csrf_token,
    auth_host: config.auth_host,
    auth_token: config.auth_token,
    fb_app_id: config.fb_app_id,
    show_partner_promo: config.show_partner_promo
  };
};