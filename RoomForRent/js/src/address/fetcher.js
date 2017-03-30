export const fetchAddressSuggestions = (host, address) => {

  const addressSearchEndpoint = `${host}_ajax/Rentals/RoomForRent/address_search/`;
  let urlParams = new FormData();

  urlParams.append('address', address);

  return fetch(addressSearchEndpoint, {
    method: 'POST',
    credentials: 'include',
    body: urlParams
  })
    .then(response => response.json())
    .then(json => { return json; });
};

export const fetchAddressVerification = (host, address) => {

  const addressVerifyEndpoint = `${host}_ajax/Rentals/RoomForRent/address_verify/`;

  let urlParams = new FormData();

  urlParams.append('address', address);

  return fetch(addressVerifyEndpoint, {
    method: 'POST',
    credentials: 'include',
    body: urlParams
  })
    .then(response => response.json())
    .then(json => { return json; });
};