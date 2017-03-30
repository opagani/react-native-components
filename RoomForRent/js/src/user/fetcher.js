export const userEmailRequest = (
  host, email, userStatus
) => {
  const userEmailEndpoint = `${host}_ajax/User/Users/`;

  const jsonValue = JSON.stringify({
    'email': email,
    'userStatus': userStatus
  });

  return fetch(userEmailEndpoint, {
    method: 'POST',
    credentials: 'same-origin',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: jsonValue
  })
    .then((response) => {
      return response;
    });
};

export const userLoginRequest = (
  host, email, userStatus, userId, isNewRegistration, password
) => {

  const userLoginEndpoint = `${host}_ajax/User/Users/login/`;
  let jsonValue, method;

  if (isNewRegistration === true) {
    // new user, who has no userId
    method = 'PUT';
    jsonValue = JSON.stringify({
      'email': email,
      'userStatus': userStatus,
      'isNewRegistration': false,
      'p': password
    });
  } else {
    // new user, who has userId
    method = 'POST';
    jsonValue = JSON.stringify({
      'email': email,
      'userStatus': userStatus,
      'isNewRegistration': true,
      'isLoading': false,
      'p': password
    });
  }

  return fetch(userLoginEndpoint, {
    method: method,
    credentials: 'same-origin',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: jsonValue
  })
    .then((response) => {
      return response;
    });
};

export const userProfileRequest = (host) => {
  const getUserProfileEndpoint = `${host}_ajax/GlobalNav/UserCardAjax/get_user_card/`;

  return fetch(getUserProfileEndpoint, {
    method: 'POST',
    credentials: 'same-origin',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  })
    .then(response => response.json())
    .then(json => { return json; });
};

export const postLoginCleanUpRequest = (host) => {
  const postLoginCleanUpEndpoint = `${host}_ajax/Rentals/RoomForRent/post_login_cleanup/`;

  return fetch(postLoginCleanUpEndpoint, {
    method: 'GET',
    credentials: 'same-origin',
  })
    .then(response => response.json())
    .then(json => { return json; });
};