import { manageListing, updateListingError, updateMonthlyRentFormInfo } from '../listing/action';
import MonthlyRentForm from './component';
import { PropTypes } from 'react';
import { connect } from 'react-redux';


const mapStateToProps = (state, ownProps) => {
  return {
    host: state.config.host,
    csrf_token: state.config.csrf_token,
    navigation: ownProps.navigation,
    error: state.listing.error,
    isFetching: state.listing.ajaxResponse.is_fetching,
    ad_id: state.listing.ad_id,
    price: state.listing.price,
    other_expense: state.listing.other_expense,
    electricity: state.listing.electricity,
    cable: state.listing.cable,
    heating: state.listing.heating,
    water: state.listing.water,
    internet: state.listing.internet,
    garbage: state.listing.garbage
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    'manageListing': (
      host, ad_id, data, csrf_token
    ) => {
      return dispatch(manageListing(host, ad_id, data, csrf_token));
    },
    'updateMonthlyRentFormInfo': (
      price, other_expense, electricity,
      cable, heating, water, internet, garbage
    ) => {
      return dispatch(updateMonthlyRentFormInfo(
        price, other_expense, electricity,
        cable, heating, water, internet, garbage
      ));
    },
    'updateListingError': (errors) => {
      return dispatch(updateListingError(errors));
    }
  };
};

const MonthlyRentFormContainer = connect(mapStateToProps, mapDispatchToProps)(MonthlyRentForm);

MonthlyRentFormContainer.propTypes = {
  navigation: PropTypes.object,
  tracking_handler: PropTypes.object.isRequired
};

export default MonthlyRentFormContainer;