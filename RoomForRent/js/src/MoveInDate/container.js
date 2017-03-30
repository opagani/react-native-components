import { manageListing, updateDateAvailable, updateListingError } from '../listing/action';
import MoveInForm from './component';
import { PropTypes } from 'react';
import { connect } from 'react-redux';

const mapStateToProps = (state, ownProps) => {
  return {
    host: state.config.host,
    csrf_token: state.config.csrf_token,
    navigation: ownProps.navigation,
    error: state.listing.error,
    isFetching: state.listing.ajaxResponse.is_fetching,
    date_available: state.listing.date_available,
    ad_id: state.listing.ad_id
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    'manageListing': (
      host, ad_id, data, csrf_token
    ) => {
      return dispatch(
        manageListing(
          host, ad_id, data, csrf_token
        )
      );
    },
    'updateDateAvailable': (date_available) => {
      return dispatch(updateDateAvailable(date_available));
    },
    'updateListingError': (errors) => {
      return dispatch(updateListingError(errors));
    }
  };
};

const MoveInFormContainer = connect(mapStateToProps, mapDispatchToProps)(MoveInForm);

MoveInFormContainer.propTypes = {
  navigation: PropTypes.object,
  tracking_handler: PropTypes.object.isRequired
};

export default MoveInFormContainer;