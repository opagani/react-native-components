export const createListingRequest = (
  host,
  lease_duration, property_type,
  address, show_address,
  unit, csrf_token
) => {
  const createListingEndpoint = `${host}_ajax/Rentals/RoomForRent/create_listing/`;
  let formData = new FormData();

  formData.append('data[lease_duration]', lease_duration);
  formData.append('data[address]', address);
  formData.append('data[show_address]', show_address);
  formData.append('data[unit]', unit);
  formData.append('data[property_type]', property_type);
  formData.append('csrf_token', csrf_token);

  return fetch(createListingEndpoint, {
    method: 'POST',
    credentials: 'same-origin',
    body: formData
  })
    .then(response => response.json())
    .then(json => { return json; });
};

export const manageListingRequest = (
  host, ad_id, data, csrf_token
) => {
  const manageListingEndpoint = `${host}_ajax/Rentals/RoomForRent/manage_listing/`;
  let formData = new FormData();

  formData.append('ad_id', ad_id);
  formData.append('csrf_token', csrf_token);
  for (let propName in data) {
    formData.append(`data[${propName}]`, data[propName]);
  }

  return fetch(manageListingEndpoint, {
    method: 'POST',
    credentials: 'same-origin',
    body: formData
  })
    .then(response => response.json())
    .then(json => { return json; });
};