import {
  CREATE_LISTING, GET_ADDRESS_VERIFICATION, GET_USER_PROFILE, LOGIN_USER, MANAGE_LISTING,
  SHOW_HANDY, UPDATE_ABOUT_TENANT_FORM_INFO, UPDATE_ACCOUNT_PHONE_INFO, UPDATE_ADDRESS_INFO,
  UPDATE_ALLOWED_PETS_INFO, UPDATE_BROWSED_HISTORY, UPDATE_CONTACT_PREF_INFO, UPDATE_CURRENT_STEP,
  UPDATE_DATE_AVAILABLE, UPDATE_DESCRIPTION, UPDATE_IMAGES, UPDATE_LEASE_DURATION_FORM_INFO,
  UPDATE_LISTING_DETAILS, UPDATE_LISTING_ERROR, UPDATE_LISTING_ID_HASH, UPDATE_LIVING_SPACE_FORM_INFO,
  UPDATE_MONTHLY_RENT_FORM_INFO, UPDATE_ROOMMATES_INFO, UPDATE_USER_INFO,
  VERIFY_USER_EMAIL
} from './action';

const parseListingDetails = (action) => {
  let details = {};
  let propKey = '';
  let data = {};
  let ajaxResponse = {};

  if (action.data) {
    data = action.data;
    for (propKey in data) {
      details[propKey] = data[propKey];
    }
  }

  // reset the ajax endpoint fetching flag
  ajaxResponse['is_fetching'] = false;
  details['ajaxResponse'] = ajaxResponse;

  // reset error
  details['error'] = '';

  return details;
};

export const listing = (state = {}, action) => {
  switch (action.type) {

  case CREATE_LISTING:
    return Object.assign({}, state, {
      ajaxResponse: {
        is_fetching: true
      }
    });

  case MANAGE_LISTING:
    return Object.assign({}, state, {
      ajaxResponse: {
        is_fetching: true
      }
    });

  case UPDATE_ADDRESS_INFO:
    return Object.assign({}, state, {
      address: action.address,
      show_address: action.show_address
    });

  case UPDATE_BROWSED_HISTORY:
    return Object.assign({}, state, {
      browsedHistory: action.browsedHistory
    });

  case UPDATE_CURRENT_STEP:
    return Object.assign({}, state, {
      currentStep: action.currentStep
    });

  case UPDATE_IMAGES:
    return Object.assign({}, state, {
      images: action.images
    });

  case UPDATE_MONTHLY_RENT_FORM_INFO:
    return Object.assign({}, state, {
      price: action.price,
      other_expense: action.other_expense,
      electricity: action.electricity,
      cable: action.cable,
      heating:action.heating,
      water: action.water,
      internet: action.internet,
      garbage: action.garbage
    });

  case UPDATE_LEASE_DURATION_FORM_INFO:
    return Object.assign({}, state, {
      lease_duration: action.lease_duration,
      property_type: action.property_type
    });

  case UPDATE_LIVING_SPACE_FORM_INFO:
    return Object.assign({}, state, {
      bedrooms: action.bedrooms,
      bathrooms: action.bathrooms,
      own_bathroom: action.own_bathroom
    });

  case UPDATE_ADDRESS_INFO:
    return Object.assign({}, state, {
      address: action.address,
      show_address: action.show_address
    });

  case UPDATE_LISTING_ERROR:
    // reset the ajax endpoint fetching flag
    let ajaxResponse = {};
    ajaxResponse['is_fetching'] = false;

    return Object.assign({}, state, {
      error: action.error,
      ajaxResponse: ajaxResponse
    });

  case UPDATE_LISTING_DETAILS:
    let details = parseListingDetails(action);
    return Object.assign({}, state, details);

  case GET_ADDRESS_VERIFICATION:
    return Object.assign({}, state, {
      ajaxResponse: {
        is_fetching: true
      }
    });

  case UPDATE_DATE_AVAILABLE:
    return Object.assign({}, state, {
      date_available: action.date_available
    });

  case UPDATE_ROOMMATES_INFO:
    return Object.assign({}, state, {
      roommate_tenant_count: action.roommate_tenant_count
    });

  case UPDATE_ALLOWED_PETS_INFO:
    return Object.assign({}, state, {
      pets: action.pets
    });

  case UPDATE_DESCRIPTION:
    return Object.assign({}, state, {
      description: action.description
    });

  case UPDATE_USER_INFO:
    let userInfo = {};

    for (let propName in action) {
      if (propName !== 'type') {
        userInfo[propName] = action[propName];
      }
    }

    return Object.assign({}, state, {
      user: userInfo,
      ajaxResponse: {
        is_fetching: false
      },
      error: ''
    });

  case VERIFY_USER_EMAIL:
    return Object.assign({}, state, {
      ajaxResponse: {
        is_fetching: true
      }
    });

  case LOGIN_USER:
    return Object.assign({}, state, {
      ajaxResponse: {
        is_fetching: true
      }
    });

  case UPDATE_ABOUT_TENANT_FORM_INFO:
    return Object.assign({}, state, {
      contact_name: action.contact_name,
      tenant_age: action.tenant_age,
      tenant_gender: action.tenant_gender,
      contact_email: action.contact_email
    });

  case UPDATE_CONTACT_PREF_INFO:
    return Object.assign({}, state, {
      pref_tenant_contact: action.pref_tenant_contact
    });

  case UPDATE_ACCOUNT_PHONE_INFO:
    return Object.assign({}, state, {
      phone: action.phone
    });

  case UPDATE_LISTING_ID_HASH:
    return Object.assign({}, state, {
      listing_id_hash: action.listing_id_hash
    });

  case SHOW_HANDY:
    return Object.assign({}, state, {
      show_handy: action.show_handy
    });

  default:
    return state;
  }
};