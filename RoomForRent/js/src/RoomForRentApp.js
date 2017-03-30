import React, { PropTypes } from 'react';
import RoomForRentContainer from './RoomForRent/container';
import { Provider } from 'react-redux';
import configureStore from './store';

const store = configureStore;

export default class RoomForRentApp extends React.Component {
  render() {
    return (
      <Provider store={ store }>
        <RoomForRentContainer
          host={ this.props.host }
          csrf_token={ this.props.csrf_token }
          auth_host={ this.props.auth_host }
          auth_token={ this.props.auth_token }
          fb_app_id={ this.props.fb_app_id }
          embed_address={ this.props.embed_address }
          tracking_handler={ this.props.tracking_handler }
          show_partner_promo={ this.props.show_partner_promo }
        />
      </Provider>
    );
  }
}

RoomForRentApp.propTypes = {
  host: PropTypes.string,
  csrf_token: PropTypes.string.isRequired,
  auth_host: PropTypes.string,
  auth_token: PropTypes.string,
  fb_app_id: PropTypes.string,
  embed_address: PropTypes.bool,
  tracking_handler: PropTypes.object.isRequired,
  show_partner_promo: PropTypes.bool
};