import React, { Component, PropTypes } from 'react';
import DatePicker from 'react-native-datepicker'
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

export default class MoveInForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      value: '',
      ad_id: '',
      error: '',
      date: ''
    };
  }

  componentWillMount() {
    this.setState({
      value: this.props.date_available ? this.props.date_available : '',
      ad_id: this.props.ad_id ? this.props.ad_id : ''
    });
  }

  componentDidMount() {
    this.props.tracking_handler.trackState({
      siteSection: 'rent',
      pageType: 'list a room',
      pageDetails: 'move in date'
    });
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps) {
      this.setState({
        error: nextProps.error,
        isFetching: nextProps.isFetching,
        ad_id: nextProps.ad_id,
        value: nextProps.date_available
      }, ()=> {
        this.goToNextForm();
      });
    }
  }

  handleOnChange(dateValue) {
    this.setState({
      value: dateValue,
      error: ''
    });
  }

  isZRMDateFormat() {
    let dateParts;
    let len = this.state.value.length;

    if (len === 10) {
      dateParts = this.state.value.split('-');
      if (dateParts.length === 3) {
        return true;
      }
    }
    return false;
  }

  convertDateToZRMFormat() {
    let dateParts, dateStr;
    let len = this.state.value.length;

    if (len === 10) {
      dateParts = this.state.value.split('/');
      if (dateParts.length === 3) {
        dateStr = [dateParts[2], dateParts[0], dateParts[1]].join('-');
        return dateStr;
      }
    }
    return '';
  }

  convertZRMDateFormatToInput(dateValue) {
    let dateParts, dateStr;
    dateParts = dateValue.split('-');

    if (dateParts.length === 3) {
      dateStr = [dateParts[1], dateParts[2], dateParts[0]].join('/');
      return dateStr;
    }
    return '';
  }

  handleASAPOnClick(e) {
    //this.props.tracking_handler.saveInteractedWith(`button:${e.target.textContent}`);

    const today = new Date();
    const todayStr = today.toJSON().substring(0, 10);
    this.setState({
      value: todayStr
    }, () => {
      this.manageListing();
    });
  }

  handleContinueBtnClick(e) {
    //this.props.tracking_handler.saveInteractedWith(`button:${e.target.textContent}`);

    if (this.isZRMDateFormat()) {
      this.manageListing();
    } else if (this.convertDateToZRMFormat() !== '') {
      this.manageListing();
    }
  }

  goToNextForm() {
    if (this.state.error === '' &&
        this.state.value !== '' &&
        this.state.isFetching === false) {
      this.props.navigation.onNextAction('MonthlyRentFormContainer');
    }
  }

  manageListing() {
    let data = {};
    let zrmDateValue = this.isZRMDateFormat() ? this.state.value : this.convertDateToZRMFormat();

    data['date_available'] = zrmDateValue;
    this.props.updateDateAvailable(data['date_available']);
    //this.props.manageListing(this.props.host, this.state.ad_id, data, this.props.csrf_token);
  }

  getDateTime() {
    let zrmDateValue = '';
    let dateParts = [];
    let today = new Date();
    let todayStr = today.toJSON().substring(0, 10);

    if (this.state.value !== '') {
      zrmDateValue = this.isZRMDateFormat() ? this.state.value : this.convertDateToZRMFormat();
      dateParts = zrmDateValue.split('-');
      let selectedDate = new Date(parseInt(dateParts[0],10), (parseInt(dateParts[1],10) -1), parseInt(dateParts[2],10));
      return selectedDate.getTime();
    } else {
      this.setState({
        value: todayStr
      });
      return new Date().getTime();
    }
  }

  render() {
    const selectedDate = this.getDateTime();
    const todayDate = new Date().getTime();
    const width = Dimensions.get('window').width - 100;

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
                  When can the new roommate move in?
                </Text>
              </View>  
              <View style={styles.buttonContainer}>
                <View>
                  <DatePicker
                    style={{ width: width }}
                    date={ this.state.value }
                    mode="date"
                    placeholder="select date"
                    format="YYYY-MM-DD"
                    // minDate={ todayDate }
                    // maxDate="2016-06-01"
                    confirmBtnText="Confirm"
                    cancelBtnText="Cancel"
                    customStyles={{
                      dateIcon: {
                        position: 'absolute',
                        left: 0,
                        top: 4,
                        marginLeft: 0
                      },
                      dateInput: {
                        borderRadius: 5,
                        marginLeft: 36
                      }
                    }}
                    onDateChange={ (e) => { this.handleOnChange(e); } }
                  />
                </View> 
                <View style={styles.button}>
                  <Button
                    onPress={ (e) => { this.handleASAPOnClick(e); } }
                    color="gray"
                    title="ASAP"
                  />
                </View>
              </View>
              <View style={styles.buttonContinue}>
                <Button 
                  onPress={ (e) => { this.handleContinueBtnClick(e); } }
                  color="white"
                  title="Continue"
                  style={styles.button}
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
    width: Dimensions.get('window').width - 100
  },
  text: {
    fontSize: 20,
    textAlign: 'center',
    marginTop: 10,
    paddingLeft: 50,
    paddingRight: 50
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  buttonContainer: {
    marginTop: 20,
    marginLeft: 35,
    marginRight: 35,
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 25,
    paddingRight: 25,
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
    marginTop: 15,
    marginLeft: 60,
    marginRight: 60,
    paddingTop: 5,
    paddingBottom: 5,
    paddingLeft: 25,
    paddingRight: 25,
  },
});