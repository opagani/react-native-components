import React, { Component, PropTypes } from 'react';
import Autosuggest from 'react-autosuggest';
import { fetchAddressSuggestions } from './../address/fetcher';
import debounce from 'debounce';
import isAddressLongEnough from '../utils/address_length';
import Header from '../Header';

import { 
  View,
  Text,
  TextInput,
  Button,
  Image,
  Label,
  StyleSheet,
  Switch,
  Dimensions
} from 'react-native';

function getSuggestionValue(suggestion) {
  return suggestion;
}

function renderSuggestion(suggestion) {
  return (
    <View>
      <Text>{suggestion}</Text>
    </View>
  );
}

export default class AddressSearch extends Component {
  constructor(props) {
    super(props);

    //checkTrackingProps(this.props);

    this.state = {
      value: '',
      suggestions: [],
      show_address: 1,
      error: '',
      isFetching: false,
      trueSwitchIsOn: true,
      falseSwitchIsOn: false,
    };

    this.onChangeText = this.onChangeText.bind(this);
    this.onPress = this.onPress.bind(this);
    //this.debouncedGetSuggestions = debounce(this.getSuggestions, 500);
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps) {
      this.setState({
        error: nextProps.error,
        isFetching: nextProps.isFetching,
        address: nextProps.address,
        show_address: nextProps.show_address
      }, ()=> {
        this.goToNext();
      });
    }
  }

  getSuggestions(address) {
    fetchAddressSuggestions(this.props.host, address)
      .then((json) => {
        if (json.suggestions) {
          this.setState({
            suggestions: json.suggestions
          });
          
        }
      });
  }

  onChangeText(newValue) {
    this.setState({
      value: newValue,
      error: '',
      isFetching: false
    });
  }

  onSuggestionsFetchRequested({ value }) {
    this.debouncedGetSuggestions(value);
  }

  onSuggestionsClearRequested () {
    this.setState({
      suggestions: []
    });
  }

  shouldRenderSuggestions(value) {
    return value.trim().length > 5;
  }

  goToNext() {
    if (this.state.error === '' && this.state.address !== '' && this.state.isFetching === false) {
      this.props.navigation.onNextAction('LeaseDurationFormContainer');
    }
  }

  onPress(event) {
    event.preventDefault();

    let addr = this.state.value;
    if (!isAddressLongEnough(addr)) {
      this.setState({
        error: 'Sorry, we don\'t recognize this address. Please try again.'
      });
    } else {
      this.props.updateAddressInfo(addr, this.state.show_address);
      //this.props.getAddressVerification(this.props.host, addr);
    }
  }

  renderAutoSuggest() {
    const { value, suggestions, show_address} = this.state;
    const inputProps = {
      placeholder: 'Enter an address. Ex. 123 Main St San Francisco, CA 94105',
      value: this.state.value,
      onChange: this.onChange,
      autoFocus: true
    };

    const theme = {
      container: 'fieldItem text autoComplete',
      suggestionsContainer: 'suggestionsContainer dropdownList backgroundBasic bhs bbs mtn',
      suggestionList: 'suggestionList',
      suggestion: 'suggestion dropdownLink bbs pas',
      input: 'iconSearch'
    };

    return (
      <Autosuggest suggestions={ suggestions }
         onSuggestionsFetchRequested={ () => { this.onSuggestionsFetchRequested({ value }); } }
         onSuggestionsClearRequested={ () => { this.onSuggestionsClearRequested(); } }
         shouldRenderSuggestions={ this.shouldRenderSuggestions }
         getSuggestionValue={ getSuggestionValue }
         renderSuggestion={ renderSuggestion }
         inputProps={ inputProps }
         theme={ theme }/>
    );
  }

  render() {
    return (
      <View style={{ flex: 1 }}>
        <View style={{ height: 40 }}>
          <Header 
            title="Post a Room"
          />
        </View>  
        <View style={styles.container}>
          <View style={styles.containerFluidBody}>
            <View style={{ width: Dimensions.get('window').width - 100 }}>
              <Text style={styles.welcome}>
                What is the address of this listing?
              </Text>
              <TextInput
                value={this.state.value}
                onChangeText={this.onChangeText}
                placeholder="Search for an address"
                style={styles.input}
              />
            </View>
            <View>
              { this.renderAutoSuggest }
            </View>
            <View>
              <Text style={ styles.textError }>
                { this.state.error }
              </Text>
            </View>
            <View style={styles.row}>
              <Switch
                onValueChange={(value) => this.setState({ falseSwitchIsOn: value })}
                style={styles.switchKnob}
                value={this.state.falseSwitchIsOn}>
              </Switch>
              <View style={styles.label}>
                <Text style={styles.subText}>
                  Hide address, only show intersection
                </Text>
              </View>
            </View>
            <View style={styles.buttonContinue}>
              <View>
                <Button 
                  onPress={this.onPress}
                  color="white"
                  title="Continue"
                />
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
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  row: {
    flexDirection: 'row',
    marginTop: 10,
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 20,
    paddingRight: 20,
  },
  input: {
    height: 50,
    backgroundColor: 'lightgrey',
    borderRadius: 5,
    marginTop: 30,
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 25,
    paddingRight: 25,
  },
  buttonContinue: {
    height: 50,
    backgroundColor: '#2ed975',
    borderRadius: 5,
    marginTop: 25,
    paddingTop: 5,
    paddingBottom: 5,
    paddingLeft: 25,
    paddingRight: 25,
    width: Dimensions.get('window').width - 100
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
});