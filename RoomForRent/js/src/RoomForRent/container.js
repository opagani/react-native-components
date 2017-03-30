import { getUserProfile, updateBrowsedHistory, updateCurrentStep, updateListingDetails } from '../listing/action';
import { PropTypes } from 'react';
import RoomForRentMain from './component';
import { connect } from 'react-redux';
import { setConfigSettings } from '../config/action';

// initialize the configuration
const updateConfigSettings = (dispatch, config) => {
  return dispatch(setConfigSettings(config));
};

const mapStateToProps = (state, ownProps) => {
  return {
    host: ownProps.host || state.config.host,
    embed_address: ownProps.embed_address,
    tracking_handler: ownProps.tracking_handler,
    browsedHistory: state.listing.browsedHistory,
    currentStep: state.listing.currentStep,
    isFetching: state.listing.ajaxResponse.is_fetching,
    listing: state.listing,
    address: state.listing.address,
    show_handy: state.show_handy,
    show_partner_promo: ownProps.show_partner_promo || state.config.show_partner_promo
  };
};

const mapDispatchToProps = (dispatch, ownProps) => {

  /**
   * We only want to setup all the config value once
   */
  if (ownProps && ownProps.host) {
    let config = {
      host: ownProps.host || '',
      csrf_token: ownProps.csrf_token || '',
      auth_host: ownProps.auth_host || '',
      auth_token: ownProps.auth_token || '',
      fb_app_id: ownProps.fb_app_id || '',
    };

    if (ownProps.show_partner_promo === true || ownProps.show_partner_promo === false) {
      config = Object.assign(config, {
        show_partner_promo: ownProps.show_partner_promo
      });
    }

    updateConfigSettings(dispatch, config);
  }

  return {
    'updateBrowsedHistory': (browsedHistory) => {
      return dispatch(updateBrowsedHistory(browsedHistory));
    },
    'updateCurrentStep': (currentStep) => {
      return dispatch(updateCurrentStep(currentStep));
    },
    'updateListingDetails': (data) => {
      return dispatch(updateListingDetails(data));
    }
  };
};

const RoomForRentContainer = connect(mapStateToProps, mapDispatchToProps)(RoomForRentMain);

RoomForRentContainer.propTypes = {
  host: PropTypes.string.isRequired,
  csrf_token: PropTypes.string.isRequired,
  auth_host: PropTypes.string,
  auth_token: PropTypes.string,
  fb_app_id: PropTypes.string,
  embed_address: PropTypes.bool,
  tracking_handler: PropTypes.object.isRequired,
  show_partner_promo: PropTypes.bool
};

export default RoomForRentContainer;