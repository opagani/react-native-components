export const siftScienceTracking = (
  host,
  submitAction,
  email,
  changedPassword
) => {
  const siftScienceTrackingEndpoint = `${host}_ajax/Rentals/SiftScienceTracking/tracking_event/`;
  let formData = new FormData();
  formData.append('submitAction', submitAction);
  formData.append('userEmail', email);
  formData.append('changedPassword', changedPassword);

  return fetch(siftScienceTrackingEndpoint, {
    method: 'POST',
    credentials: 'same-origin',
    body: formData
  });
};