export default function isAddressLongEnough(address) {
  return !(address.length < 7 || address.split(' ').length < 2);
}