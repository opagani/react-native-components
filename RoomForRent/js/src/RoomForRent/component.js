import React, { Component } from 'react';
import AddressSearchContainer from '../AddressSearch/container';
import LeaseDurationFormContainer from '../LeaseDuration/container';
import MoveInFormContainer from '../MoveInDate/container';
import MonthlyRentFormContainer from '../MonthlyRent/container';

class RoomForRentMain extends React.Component {
  constructor(props) {
    super(props);

    this.containers = {
      'AddressSearchContainer': AddressSearchContainer,
      'LeaseDurationFormContainer': LeaseDurationFormContainer,
      'MoveInFormContainer': MoveInFormContainer,
      'MonthlyRentFormContainer': MonthlyRentFormContainer,
    };

    this.state = {
      isLandingPageShown: false
    };
  }

  componentWillMount() {
    if (this.props.address !=='') {
      /**
       * If the address has been filled in,
       * we show the LeaseDurationForm for next step
       */
      this.setState({
        currentStep: 'LeaseDurationFormContainer'
      });
    } else {
      this.setState({
        currentStep: 'AddressSearchContainer'
      });
    }
  }

  updateNavigation(currentStep, browsedHistory) {
    this.props.updateCurrentStep(currentStep);
    this.props.updateBrowsedHistory(browsedHistory);
    this.setState ({
      currentStep: currentStep
    });
  }

  onBackAction(e) {
    let browsedHistory = this.props.browsedHistory ? this.props.browsedHistory : [];
    let currentStep = this.props.currentStep ? this.props.currentStep : 'AddressSearchContainer';
    let len = browsedHistory.length;

    if (browsedHistory.length > 1) {
      browsedHistory.pop();
      len = browsedHistory.length;
    }

    if (currentStep !== browsedHistory[len-1]) {
      currentStep = browsedHistory[len-1];
    }

    this.updateNavigation(currentStep, browsedHistory);
  }

  onNextAction(nextContainer) {
    let browsedHistory = this.props.browsedHistory ? this.props.browsedHistory : [];
    let currentStep = this.props.currentStep ? this.props.currentStep : 'AddressSearchContainer';
    let len = browsedHistory.length;

    if (currentStep !== nextContainer) {
      currentStep = nextContainer;
    }

    if (browsedHistory[len-1] !== nextContainer) {
      browsedHistory.push(nextContainer);
    }

    this.updateNavigation(currentStep, browsedHistory);
  }

  onCancelAction(e) {
    console.warn("Cancel action");
  }

  updateCurrentStep() {
    let current = this.props.current_step ? this.props.current_step : [];
    let len = current.length;

    if (len === 0) {
      current[0] = AddressSearchContainer;
    }
    this.props.updateCurrentStep(current);
  }

  getNavigation() {
    const navigation = {
      'onBackAction': (e) => { this.onBackAction(e); },
      'onCancelAction': (e) => { this.onCancelAction(e); },
      'onNextAction': (nextContainer) => { this.onNextAction(nextContainer); }
    };
    return navigation;
  }

  render() {
    const navigation = this.getNavigation();
    const propsValues = {
      'navigation': navigation,
      'tracking_handler': this.props.tracking_handler
    };

    let currentStepContainer = this.containers[this.state.currentStep];

    const componentInstance = React.createFactory(currentStepContainer);
    return componentInstance(propsValues);
  }
}

export default RoomForRentMain;