import React, { Component, PropTypes } from 'react';
import Header from '../Header';

import { 
  View,
  Text,
  TextInput,
  Button,
  Image,
  Label,
  StyleSheet,
  Dimensions
} from 'react-native';

export default class LeaseDurationForm extends Component {
  constructor(props) {
    super(props);

    //checkTrackingProps(this.props);

    this.state = {
      value: '',
      ad_id: '',
      error: '',
      isFetching: false
    };

    this.choiceValuesMap = {'1mo':'Month to month', '6mo':'6 months', '1y':'At least one year'};
    this.choices = ['Month to month', '6 months', 'At least one year'];
  }

  componentWillMount() {
    this.setState({
      value: this.props.lease_duration ? this.props.lease_duration : '',
      ad_id: this.props.ad_id ? this.props.ad_id : ''
    });
  }

  handleOnClick = (value) => {
    //this.props.tracking_handler.saveInteractedWith(`button:${value}`);
    
    let ZRMValue = '';
    for (let key in this.choiceValuesMap) {
      if (this.choiceValuesMap[key] === value) {
        ZRMValue = key;
        break;
      }
    }

    this.setState({
      value: ZRMValue
    }, () => {
      if (this.state.ad_id === '') {
        this.createListing();
      } else {
        this.manageListing();
      }
    });
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps) {
      this.setState({
        error: nextProps.error,
        isFetching: nextProps.isFetching,
        ad_id: nextProps.ad_id,
        value: nextProps.lease_duration
      }, ()=> {
        this.goToNextForm();
      });
    }
  }

  goToNextForm() {
    if (this.state.error === '' && this.state.value !== '' && this.state.isFetching === false) {
      this.props.navigation.onNextAction('MoveInFormContainer');
    }
  }

  createListing() {
    let lease_duration = this.state.value;
    // we need the default to 1, when there is no property type send back from the ajax call
    let property_type = this.props.property_type || 1;

    this.props.updateLeaseDurationFormInfo(lease_duration, property_type);
    // this.props.createListing(
    //   this.props.host,
    //   lease_duration, property_type,
    //   this.props.address, this.props.show_address,
    //   this.props.unit, this.props.csrf_token
    // );
  }

  manageListing() {
    let data = {};
    data['lease_duration'] = this.state.value;

    // we need the default to 1, when there is no property type send back from the ajax call
    data['property_type'] = this.props.property_type || 1;

    this.props.updateLeaseDurationFormInfo(data['lease_duration'], data['property_type']);
    this.props.manageListing(
      this.props.host, this.state.ad_id,
      data, this.props.csrf_token
    );
  }

  render() {
    return (
      <View style={{ flex: 1 }}>
        <View style={{ height: 40 }}>
          <Header 
            title="Post a Room"
            subtitle="Logistics"
            currentStep="1"
            totalSteps="4"
            onBackAction={ this.props.navigation.onBackAction }
            onCancelAction={ this.props.navigation.onCancelAction }
          />
        </View>
        <View style={styles.container}>
          <View style={styles.containerFluidBody}>
            <View>
              <View>
                <Text style={styles.text}>
                  What is the duration of this lease?
                </Text>
              </View>
              <View style={styles.buttonContainer}>
                <View style={{ width: Dimensions.get('window').width - 100 }}>
                  <View style={styles.firstButton}>
                    <Button
                      onPress={() => this.handleOnClick('Month to month')}
                      color="gray"
                      title="Month to month"
                    />
                  </View>  
                  <View style={styles.middleButton}>
                    <Button
                      onPress={() => this.handleOnClick('6 months')}
                      color="gray"
                      title="6 months"
                    />
                  </View>  
                  <View style={styles.lastButton}>
                    <Button
                      onPress={() => this.handleOnClick('At least one year')}
                      color="gray"
                      title="At least one year"
                    />
                  </View>
                </View>  
              </View>
            </View>
          </View>
        </View>
      </View> 
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    paddingLeft: 0,
    paddingRight: 0,
    marginTop: 25
  },
  containerFluidBody: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    marginTop: 20,
    width: Dimensions.get('window').width - 100
  },
  text: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
    paddingLeft: 15,
    paddingRight: 15
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  buttonContainer: {
    marginTop: 20,
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 25,
    paddingRight: 25,
  },
  firstButton: {
    paddingTop: 5,
    borderTopLeftRadius: 5,
    borderTopRightRadius: 5,
    borderBottomWidth: 0,
    borderColor: 'lightgray',
    borderWidth: 0.5
  },
  middleButton: {
    borderColor: 'lightgray',
    borderWidth: 0.5
  },
  lastButton: {
    paddingBottom: 5,
    borderBottomLeftRadius: 5,
    borderBottomRightRadius: 5,
    borderTopWidth: 0,
    borderColor: 'lightgray',
    borderWidth: 0.5
  }
});