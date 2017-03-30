import {
  createListing, manageListing, updateLeaseDurationFormInfo,
  updateListingError
} from '../listing/action';
import LeaseDurationForm from './component';
import { PropTypes } from 'react';
import { connect } from 'react-redux';
import { createListingRequest } from '../listing/action';

const mapStateToProps = (state, ownProps) => {
  return {
    host: state.config.host,
    csrf_token: state.config.csrf_token,
    navigation: ownProps.navigation,
    tracking_handler: ownProps.tracking_handler,
    error: state.listing.error,
    isFetching: state.listing.ajaxResponse.is_fetching,
    ad_id: state.listing.ad_id,
    address: state.listing.address,
    show_address: state.listing.show_address,
    lease_duration: state.listing.lease_duration,
    unit: state.listing.unit,
    property_type: state.listing.property_type
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    'createListing': (host,
                      lease_duration, property_type,
                      address, show_address,
                      unit, csrf_token
    ) => {
      return dispatch(
        createListing(host,
                      lease_duration, property_type,
                      address, show_address,
                      unit, csrf_token
        )
      );
    },
    'manageListing': (host, ad_id, data, csrf_token) => {
      return dispatch(
        manageListing(host, ad_id, data, csrf_token)
      );
    },
    'updateLeaseDurationFormInfo': (lease_duration, property_type) => {
      return dispatch(updateLeaseDurationFormInfo(lease_duration, property_type));
    },
    'updateListingError': (errors) => {
      return dispatch(updateListingError(errors));
    }
  };
};

const LeaseDurationFormContainer = connect(mapStateToProps, mapDispatchToProps)(LeaseDurationForm);

LeaseDurationFormContainer.propTypes = {
  navigation: PropTypes.object,
  tracking_handler: PropTypes.object.isRequired
};

export default LeaseDurationFormContainer;