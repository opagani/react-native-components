import { getAddressVerification, updateAddressInfo, updateListingError } from '../listing/action';
import AddressSearch from './component';
import { PropTypes } from 'react';
import { connect } from 'react-redux';

const mapStateToProps = (state, ownProps) => {
  return {
    navigation: ownProps.navigation,
    content_only: ownProps.content_only,
    tracking_handler: ownProps.tracking_handler,
    host: state.config.host,
    error: state.listing.error,
    isFetching: state.listing.ajaxResponse.is_fetching,
    address: state.listing.address,
    show_address: state.listing.show_address
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    'getAddressVerification': (host, address) => {
      return dispatch(getAddressVerification(host, address));
    },
    'updateAddressInfo': (address, show_address) => {
      return dispatch(updateAddressInfo(address, show_address));
    },
    'updateListingError': (errors) => {
      return dispatch(updateListingError(errors));
    }
  };
};

const AddressSearchContainer = connect(mapStateToProps, mapDispatchToProps)(AddressSearch);

AddressSearchContainer.propTypes = {
  navigation: PropTypes.object,
  content_only: PropTypes.number,
  hide_address_switch: PropTypes.bool,
};

export default AddressSearchContainer;