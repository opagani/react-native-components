import { createListingRequest, manageListingRequest } from './fetcher';
import { userEmailRequest, userLoginRequest, userProfileRequest } from '../user/fetcher';
import { fetchAddressVerification } from '../address/fetcher';
import { siftScienceTracking } from '../fraud/fetcher';

export const CREATE_LISTING = 'CREATE_LISTING';
export const GET_ADDRESS_VERIFICATION = 'GET_ADDRESS_VERIFICATION';
export const GET_USER_PROFILE = 'GET_USER_PROFILE';
export const LOGIN_USER = 'LOGIN_USER';
export const MANAGE_LISTING = 'MANAGE_LISTING';
export const UPDATE_ABOUT_TENANT_FORM_INFO = 'UPDATE_ABOUT_TENANT_FORM_INFO';
export const UPDATE_ACCOUNT_PHONE_INFO = 'UPDATE_ACCOUNT_PHONE_INFO';
export const UPDATE_ADDRESS_INFO = 'UPDATE_ADDRESS_INFO';
export const UPDATE_ALLOWED_PETS_INFO = 'UPDATE_ALLOWED_PETS_INFO';
export const UPDATE_BROWSED_HISTORY = 'UPDATE_BROWSED_HISTORY';
export const UPDATE_CONTACT_PREF_INFO = 'UPDATE_CONTACT_PREF_INFO';
export const UPDATE_CURRENT_STEP = 'UPDATE_CURRENT_STEP';
export const UPDATE_DATE_AVAILABLE = 'UPDATE_DATE_AVAILABLE';
export const UPDATE_DESCRIPTION = 'UPDATE_DESCRIPTION';
export const UPDATE_LEASE_DURATION_FORM_INFO = 'UPDATE_LEASE_DURATION_FORM_INFO';
export const UPDATE_LISTING_DETAILS = 'UPDATE_LISTING_DETAILS';
export const UPDATE_LISTING_ERROR = 'UPDATE_LISTING_ERROR';
export const UPDATE_LISTING_ID_HASH = 'UPDATE_LISTING_ID_HASH';
export const UPDATE_LIVING_SPACE_FORM_INFO = 'UPDATE_LIVING_SPACE_FORM_INFO';
export const UPDATE_MONTHLY_RENT_FORM_INFO = 'UPDATE_MONTHLY_RENT_FORM_INFO';
export const UPDATE_IMAGES = 'UPDATE_IMAGES';
export const UPDATE_ROOMMATES_INFO = 'UPDATE_ROOMMATES_INFO';
export const UPDATE_USER_INFO = 'UPDATE_USER_INFO';
export const VERIFY_USER_EMAIL = 'VERIFY_USER_EMAIL';
export const SHOW_HANDY = 'SHOW_HANDY';

export const showHandyIntegration = (showHandy) => {
  return {
    type: SHOW_HANDY,
    show_handy: showHandy
  };
};

export const updateBrowsedHistory = (browsedHistory) => {
  return {
    type: UPDATE_BROWSED_HISTORY,
    browsedHistory: browsedHistory
  };
};

export const updateCurrentStep = (currentStep) => {
  return {
    type: UPDATE_CURRENT_STEP,
    currentStep: currentStep
  };
};

export const updateImages = (images) => {
  return {
    type: UPDATE_IMAGES,
    images: images
  };
};

export const updateListingDetails = (data) => {
  let listingDetails = data;
  listingDetails.type = UPDATE_LISTING_DETAILS;

  return listingDetails;
};

export const updateListingError = (errors) => {
  return {
    type: UPDATE_LISTING_ERROR,
    error: errors.join('')
  };
};

export const getAddressVerification = (host, address) => (dispatch => {
  dispatch({
    type: GET_ADDRESS_VERIFICATION
  });

  return fetchAddressVerification(host, address).then((data) => {
    let errors = [];

    if (data.success) {
      return dispatch(updateListingDetails(data));
    } else {
      if (data.errors && data.errors.Address) {
        errors = data.errors.Address;
      }
      return dispatch(updateListingError(errors));
    }
  });
});

export const updateAddressInfo = (address, show_address) => {
  return {
    type: UPDATE_ADDRESS_INFO,
    address: address,
    show_address: show_address
  };
};

export const updateLeaseDurationFormInfo = (lease_duration, property_type) => {
  return {
    type: UPDATE_LEASE_DURATION_FORM_INFO,
    lease_duration: lease_duration,
    property_type: property_type
  };
};

export const updateLivingSpaceFormInfo = (bedrooms, bathrooms, own_bathroom) => {
  return {
    type: UPDATE_LIVING_SPACE_FORM_INFO,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    own_bathroom: own_bathroom
  };
};

export const updateDateAvailable = (date_available) => {
  return {
    type: UPDATE_DATE_AVAILABLE,
    date_available: date_available
  };
};

export const updateMonthlyRentFormInfo = (
  price, other_expense, electricity,
  cable, heating, water, internet, garbage
) => {
  return {
    type: UPDATE_MONTHLY_RENT_FORM_INFO,
    price: price,
    other_expense: other_expense,
    electricity: electricity,
    cable: cable,
    heating: heating,
    water: water,
    internet: internet,
    garbage: garbage
  };
};

export const updateRoommatesInfo = (roommate_tenant_count) => {
  return {
    type: UPDATE_ROOMMATES_INFO,
    roommate_tenant_count: roommate_tenant_count
  };
};

export const updateAllowedPetsInfo = (pets) => {
  return {
    type: UPDATE_ALLOWED_PETS_INFO,
    pets: pets
  };
};

export const updateDescription = (description) => {
  return {
    type: UPDATE_DESCRIPTION,
    description: description
  };
};

export const updateAboutTenantFormInfo = (
  contact_name, tenant_age, tenant_gender, contact_email
) => {
  return {
    type: UPDATE_ABOUT_TENANT_FORM_INFO,
    contact_name: contact_name,
    tenant_age: tenant_age,
    tenant_gender: tenant_gender,
    contact_email: contact_email
  };
};

export const updateContactPrefInfo = (pref_tenant_contact) => {
  return {
    type: UPDATE_CONTACT_PREF_INFO,
    pref_tenant_contact: pref_tenant_contact
  };
};

export const updateAccountPhoneInfo = (phone) => {
  return {
    type: UPDATE_ACCOUNT_PHONE_INFO,
    phone: phone
  };
};

export const updateListingIdHash = (listing_id_hash) => {
  return {
    type: UPDATE_LISTING_ID_HASH,
    listing_id_hash: listing_id_hash
  };
};

export const manageListing = (host, ad_id, data, csrf_token) => (dispatch => {
  dispatch({
    type: MANAGE_LISTING
  });

  return manageListingRequest(host, ad_id, data, csrf_token).then((data) => {
    let errors = [];

    if (data.success && data.listing) {
      let resp = { 'data': data.listing };

      return dispatch(updateListingDetails(resp));
    } else {
      // this is the manage listing failure error msg
      if (data.errors && data.errors.Listing) {
        errors = data.errors.Listing;
      } else {
        // this could be a User authentication error or a token error or something else
        errors = 'We are experiencing some technical difficulties. The list cannot be created';
      }
      return dispatch(updateListingError(errors));
    }
  });
});

export const createListing = (
  host,
  lease_duration, property_type,
  address, show_address,
  unit, csrf_token
) => (dispatch => {
  dispatch({
    type: CREATE_LISTING
  });

  return createListingRequest(
    host,
    lease_duration, property_type,
    address, show_address,
    unit, csrf_token
  ).then((data) => {
    let errors = [];

    if (data.success && data.listing) {
      let resp = {
        data: {
          ad_id: data.listing.ad_id
        }
      };

      return dispatch(updateListingDetails(resp));
    } else {
      // this is the create listing failure error msg
      if (data.errors && data.errors.Listing) {
        errors = data.errors.Listing;
      } else {
        // this could be a User authentication error or a token error or something else
        errors = 'We are experiencing some technical difficulties. The list cannot be created';
      }
      return dispatch(updateListingError(errors));
    }
  });
});

export const getUserProfile = (host) => (dispatch => {
  dispatch({
    type: GET_USER_PROFILE
  });

  return userProfileRequest(host).then((json) => {
    let errors = [];
    let profile = {};

    if (json.success && json.profile) {
      profile['data'] = {
        'contact_email': json.profile.email,
        'contact_name': json.profile.name
      };

      return dispatch(updateListingDetails(profile));
    } else {
      if (json.errors) {
        errors = json.errors;
      } else {
        // this could be a User authentication error or a token error or something else
        errors = 'We are experiencing some technical difficulties. The list cannot be created';
      }
      return dispatch(updateListingError(errors));
    }
  });
});

export const updateUserInfo = (user) => {
  let userInfo = user;
  userInfo['type'] = UPDATE_USER_INFO;

  return userInfo;
};

export const verifyUserEmail = (
  host, email, userStatus
) => (dispatch => {
  dispatch({
    type: VERIFY_USER_EMAIL
  });

  return userEmailRequest(
    host, email, userStatus
  ).then((data) => {
    let user = {};

    user['email'] = email;
    user['userStatus'] = userStatus;

    // clean up previous errors, if there is any
    dispatch(updateListingError([]));

    user['isNewRegistration'] = (data.status === 201);

    return dispatch(updateUserInfo(user));
  });
});

export const loginUser = (
  host, email, userStatus, userId, isNewRegistration, password
) => (dispatch => {
  dispatch({
    type: LOGIN_USER
  });

  return userLoginRequest(
    host, email, userStatus, userId, isNewRegistration, password
  ).then((data) => {
    let user = {};

    if (data.status === 200 || data.status === 205) {
      if (isNewRegistration) {
        siftScienceTracking(host, 'createAccount', email, false);
      }
      user['email'] = email;
      user['userStatus'] = userStatus;
      user['userId'] = userId;
      user['isNewRegistration'] = (data.status === 205);
      return dispatch(updateUserInfo(user));

    } else if (data.status === 403) {
      return dispatch(updateListingError(['Wrong password. Please try again in 10 minutes.']));
    } else if (data.status === 401) {
      return dispatch(updateListingError(['Unauthorized user.']));
    } else {
      return dispatch(updateListingError(['Something went wrong. We can\'t process.']));
    }
  });
});