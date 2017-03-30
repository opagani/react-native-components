import React, { Component } from 'react';
import RoomForRentApp from './src/RoomForRentApp';

import {
  AppRegistry,
} from 'react-native';

export default class App extends Component {
  render() {
    const trackingHandler = {
      trackState: () => { console.log('trackState');},
      trackAction: () => { console.log('trackAction');},
      saveInteractedWith: () => { console.log('saveInteractedWith');}
    };

    return (
      <RoomForRentApp
        host="https://fedev.sv2.trulia.com/~opagani/web/"
        csrf_token="something"
        tracking_handler={ trackingHandler }
      />
    );
  }
}

AppRegistry.registerComponent('roomForRent', () => App);