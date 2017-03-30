import { applyMiddleware, createStore } from 'redux';
import { reducers } from './reducers';
import thunk from 'redux-thunk';

const preloadedState = {
  config: {
    host: '',
    csrf_token: '',
    auth_host: '',
    auth_token: '',
    fb_app_id: '',
    return_uri: '',
    show_partner_promo: false,
  },
  listing: {
    address_id: '',
    city: '',
    full_address: '',
    is_listing_restricted: false,
    is_phone_verified: false,
    state: '',
    street: '',
    street_number: '',
    zip: '',
    error: '',
    csrf_token: '',
    ad_id: '',
    address: '',
    show_address: 1,
    property_type: 0,
    content_only: 0,
    unit: '',
    lease_duration: '',
    date_available: '',
    price: 0,
    other_expense: 0,
    electricity:  0,
    cable: 0,
    heating:0,
    water: 0,
    internet: 0,
    garbage: 0,
    images: [],
    bedrooms: 0,
    bathrooms: 0,
    own_bathroom: 0,
    pets: '',
    description: '',
    roommate_tenant_count: '',
    contact_name: '',
    phone: '',
    tenant_age: '',
    tenant_gender: '',
    contact_email: '',
    tenant_images: [],
    email: '',
    code: '',
    listing_id_hash: '',
    user: {
      email: '',
      isNewRegistration: '',
      userStatus: '',
      userId: ''
    },
    browsedHistory: ['AddressSearchContainer'],
    currentStep: 'AddressSearchContainer',
    ajaxResponse: {
      is_fetching: false
    },
    show_handy: true
  }
};

export default createStore(
  reducers,
  preloadedState,
  applyMiddleware(thunk)
);



















