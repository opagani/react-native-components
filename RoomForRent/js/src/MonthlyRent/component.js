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
  ScrollView,
  Switch,
  Dimensions
} from 'react-native';

export default class MonthlyRentForm extends Component {
  constructor(props) {
    super(props);

    //checkTrackingProps(this.props);

    this.state = {
      rentValue: '',
      utilitiesValue: '',
      utilitiesSwitch: 0,
      utilitiesArray: [
        {key: 'water', value: 0},
        {key: 'electricity', value: 0},
        {key: 'cable', value: 0},
        {key: 'internet', value: 0},
        {key: 'heating', value: 0},
        {key: 'garbage', value: 0}
      ],
      ad_id: '',
      error: '',
      utilitiesError: '',
      trueSwitchIsOn: true,
      falseSwitchIsOn: false,
    };

    this.handleMonthlyRentOnChange = this.handleMonthlyRentOnChange.bind(this);
    this.handleUtilitiesCostOnChange = this.handleUtilitiesCostOnChange.bind(this);
    this.handleContinueBtnClick = this.handleContinueBtnClick.bind(this);
    this.onToggle = this.onToggle.bind(this);
  }

  componentWillMount() {
    const utilities = {
      electricity: this.props.electricity ? this.props.electricity : 0,
      cable: this.props.cable ? this.props.cable : 0,
      heating: this.props.heating ? this.props.heating : 0,
      water: this.props.water ? this.props.water : 0,
      internet: this.props.internet ? this.props.internet : 0,
      garbage: this.props.garbage ? this.props.garbage : 0
    };

    this.setState({
      rentValue: this.props.price ? this.props.price : '',
      utilitiesValue: this.props.other_expense ? this.props.other_expense : '',
      utilitiesSwitch: this.props.other_expense > -1 ? 0 : 1,
      utilitiesArray: [
        {key: 'water', value: utilities.water},
        {key: 'electricity', value: utilities.electricity},
        {key: 'cable', value: utilities.cable},
        {key: 'internet', value: utilities.internet},
        {key: 'heating', value: utilities.heating},
        {key: 'garbage', value: utilities.garbage}
      ],
      ad_id: this.props.ad_id ? this.props.ad_id : '',
      animateStyle: ''
    });
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps) {
      const utilities = {
        electricity: nextProps.electricity ? nextProps.electricity : 0,
        cable: nextProps.cable ? nextProps.cable : 0,
        heating: nextProps.heating ? nextProps.heating : 0,
        water: nextProps.water ? nextProps.water : 0,
        internet: nextProps.internet ? nextProps.internet : 0,
        garbage: nextProps.garbage ? nextProps.garbage : 0
      };

      this.setState({
        rentValue: nextProps.price ? nextProps.price : '',
        utilitiesValue: nextProps.other_expense ? nextProps.other_expense : '',
        utilitiesSwitch: nextProps.other_expense > -1 ? 0 : 1,
        utilitiesArray: [
          {key: 'water', value: utilities.water},
          {key: 'electricity', value: utilities.electricity},
          {key: 'cable', value: utilities.cable},
          {key: 'internet', value: utilities.internet},
          {key: 'heating', value: utilities.heating},
          {key: 'garbage', value: utilities.garbage}
        ],
        error: nextProps.error,
        isFetching: nextProps.isFetching,
        ad_id: nextProps.ad_id
      }, ()=> {
        this.goToNextForm();
      });
    }
  }

  componentDidMount() {
    this.props.tracking_handler.trackState({
      siteSection: 'rent',
      pageType: 'list a room',
      pageDetails: 'rent and utilities'
    });
  }

  getUtilityButtonStyle(value) {
    let buttonStyle = [styles.buttonDefault];
    if (value === 1) {
      buttonStyle = [styles.buttonDefault, styles.btnSecondary];
    }
    return buttonStyle;
  }

  getButtonBorderStyle(index, totalLen) {
    let borderStyle = index % 2 ? [styles.rentalButtonNoCorner, styles.rentalButtonRight]
                      : [styles.rentalButtonNoCorner, styles.rentalButtonLeft];

    if (index === 0) {
      borderStyle = [...borderStyle, styles.rentalButtonTopLeft];
    }
    if (index === 1) {
      borderStyle = [...borderStyle, styles.rentalButtonTopRight];
    }
    if (index === (totalLen - 2)) {
      const borderBottomLeftStyle = [styles.rentalButtonBottomLeft, styles.rentalButtonBottom];
      borderStyle = [...borderStyle, ...borderBottomLeftStyle];
    }
    if (index === (totalLen - 1)) {
      const borderBottomRightStyle = [styles.rentalButtonBottomRight, styles.rentalButtonBottom];
      borderStyle = [...borderStyle, ...borderBottomRightStyle];
    }
    return borderStyle;
  }

  getUtilitiesButtonGrid() {
    const totalLen = this.state.utilitiesArray.length;

    let buttons = this.state.utilitiesArray.map((utility, index) => {
      let borderStyle = this.getButtonBorderStyle(index, totalLen);
      let buttonStyle = [...this.getUtilityButtonStyle(utility.value), borderStyle];
      const utilityKeyCapitalized = utility.key.charAt(0).toUpperCase() + utility.key.slice(1);

      return (
        <View key={index} style={buttonStyle}>
          <Button
            onPress={(event, key)=>{this.onToggle(event, utility.key);}}
            title={utilityKeyCapitalized}
            color='gray'
          />
        </View>
      );
    });

    return buttons;
  }

  handleContinueBtnClick(e) {
    //this.props.tracking_handler.saveInteractedWith(`button:${e.target.textContent}`);

    if (!(this.state.utilitiesValue >= 1 && this.state.utilitiesValue <= 1000000)) {
      this.setState({
        utilitiesError: 'Please enter a valid price between $1 and $1,000,000'
      });
    } else {
      this.manageListing();
    }
  }

  goToNextForm() {
    if (this.state.error === '' &&
        this.state.utilitiesError === '' &&
        this.state.rentValue !== '' &&
        this.state.isFetching === false) {
      // this.props.navigation.onNextAction('PhotoUploaderContainer');
      console.warn('PhotoUploaderContainer');
    }
  }

  onToggle(event, key) {
    event.preventDefault();
    this.updateUtilityValue(key);
  }

  updateUtilityValue(key) {
    const _utilitiesArray = this.state.utilitiesArray;
    for (let i = 0; i < _utilitiesArray.length; i++) {
      if (_utilitiesArray[i].key === key) {
        _utilitiesArray[i].value = (_utilitiesArray[i].value === 0) ? 1 : 0;
        break;
      }
    }
    this.setState({
      utilitiesArray: _utilitiesArray
    });
  }

  handleMonthlyRentOnChange(newValue) {
    let rentPrice = parseInt(newValue);

    if (isNaN(rentPrice)) {
      rentPrice = '';
    }

    this.setState({
      rentValue: rentPrice,
      error: ''
    });
  }

  handleUtilitiesCostOnChange(newValue) {
    let utilitiesCost = parseInt(newValue, 10);
    if (isNaN(utilitiesCost)) {
      utilitiesCost = '';
    }

    let utilitiesSwitch = 0;
    if (!utilitiesCost) {
      utilitiesSwitch = 1;
    }

    this.setState({
      utilitiesValue: utilitiesCost,
      utilitiesSwitch: utilitiesSwitch,
      utilitiesError: ''
    });
  }

  getUtilitiesCostStyle() {
    if (this.state.utilitiesSwitch === 0 || this.state.other_expense === 0) {
      return 'field';
    } else {
      return 'field hideFully';
    }
  }

  renderContent() {
    return (
      <View>
        <Text style={styles.welcome}>
          What's the rent and utilities?
        </Text>
        <Text style={styles.label}>
          Rent
        </Text>
        <TextInput
          value={this.state.rentValue}
          onChangeText={this.handleMonthlyRentOnChange}                
          style={styles.input}
        />
        <Text style={styles.textError}>
          { this.state.error }
        </Text>
        <Text style={[styles.label, styles.noMarginTop]}>
          Utilities
        </Text>
        <TextInput
          value={this.state.utilitiesValue}
          onChangeText={this.handleUtilitiesCostOnChange}
          style={styles.input}
        />
        <Text style={ styles.textError }>
          { this.state.utilitiesError }
        </Text>
      </View>
    );
  }

  manageListing() {
    const utilitiesArray = this.state.utilitiesArray;
    const rentValue = this.state.rentValue === '' ? 0 : this.state.rentValue;
    const utilitiesValue = this.state.utilitiesValue === '' ? 0 : this.state.utilitiesValue;
    let data = {};

    data['price'] = rentValue;
    data['other_expense'] = utilitiesValue;
    data['csrf_token'] = this.props.csrf_token;

    for (let i = 0; i < utilitiesArray.length; i++) {
      data[utilitiesArray[i].key] = utilitiesArray[i].value;
    }

    this.props.updateMonthlyRentFormInfo(
      data['price'], data['other_expense'], data['electricity'],
      data['cable'], data['heating'], data['water'], data['internet'], data['garbage']
    );
    //this.props.manageListing(this.props.host, this.state.ad_id, data, this.props.csrf_token);
  }

  render() {
    const navigation = this.props.navigation ? this.props.navigation : {};
    const content = this.renderContent();

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
        <ScrollView style={styles.container}>
          <View style={styles.containerFluidBody}>
            <View style={{ width: Dimensions.get('window').width - 100 }}>
              { content }
            </View>
            <View style={styles.row}>
              <Switch
                onValueChange={(value) => this.setState({ falseSwitchIsOn: value })}
                style={styles.switchKnob}
                value={this.state.falseSwitchIsOn}>
              </Switch>
              <View style={styles.label}>
                <Text style={styles.subText}>
                  Utilities are included in the rent
                </Text>
              </View>
            </View>
            <View style={styles.grid}>
              { this.getUtilitiesButtonGrid() }
            </View>
            <View style={styles.buttonContinue}>
              <Button
                onPress={(e) => { this.handleContinueBtnClick(e); }}
                color="white"
                title="Continue"
              />
            </View>
          </View>
        </ScrollView>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF',
    paddingLeft: 0,
    paddingRight: 0,
    marginTop: 25
  },
  containerFluidBody: {
    alignItems: 'center',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    marginTop: 20,
  },
  text: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  row: {
    flexDirection: 'row',
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 0,
    paddingRight: 30,
  },
  button: {
    marginTop: 20,
    height: 50,
    paddingTop: 5,
    borderRadius: 5,
    borderRadius: 5,
    borderColor: 'lightgray',
    borderWidth: 0.5
  },
  buttonContinue: {
    height: 50,
    backgroundColor: '#2ed975',
    borderRadius: 5,
    marginTop: 25,
    marginLeft: 55,
    marginRight: 55,
    paddingTop: 5,
    paddingBottom: 5,
    paddingLeft: 25,
    paddingRight: 25,
    width: Dimensions.get('window').width - 100,
  },
  input: {
    height: 50,
    backgroundColor: 'white',
    borderColor: 'lightgray',
    borderWidth: 1,
    borderRadius: 5,
    marginTop: 8,
    marginLeft: 10,
    marginRight: 10,
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 25,
    paddingRight: 25,
  },
  textError: {
    color: '#e13009'
  },
  label: {
    alignItems: 'flex-start',
    marginTop: 8
  },
  subText: {
    fontSize: 14
  },
  switchKnob: {
    marginTop: 0,
    marginBottom: 0,
    marginRight: 5,
    marginLeft: 10,
    borderRadius: 14,
    position: 'relative',
    backfaceVisibility: 'hidden',
  },
  noMarginTop: {
    marginTop: 0
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginTop: 12,
  },
  buttonDefault: {
    flexWrap: 'nowrap',
    height: 50,
    width: (Dimensions.get('window').width - 100) / 2,
    borderWidth: 1,
    borderColor: '#cdd1d4',
    backgroundColor: '#FFF',
    paddingTop: 5,
    paddingBottom: 8,
    paddingRight: 16,
    paddingLeft: 16,
  },
  btnSecondary: {
    backgroundColor: '#2ed975',
    borderColor: '#FFF',
  },
  rentalButtonTopLeft: {
    borderTopLeftRadius: 4,
  },
  rentalButtonTopRight: {
    borderTopRightRadius: 4,
  },
  rentalButtonLeft: {
    borderBottomWidth: 0,
    borderRightWidth: 0,
  },
  rentalButtonRight: {
    borderBottomWidth: 0,
  },
  rentalButtonNoCorner: {
    borderTopLeftRadius: 0,
    borderBottomLeftRadius: 0,
    borderTopRightRadius: 0,
    borderBottomRightRadius: 0,
  },
  rentalButtonBottom: {
    borderBottomWidth: 1,
  },
  rentalButtonBottomLeft: {
    borderBottomLeftRadius: 4,
  },
  rentalButtonBottomRight: {
    borderBottomRightRadius: 4,
  }
});