import React, { Component, PropTypes } from 'react';

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

export default class Header extends Component {
  renderBackLink() {
    if (this.props.onBackAction) {
      return (
        <View style={styles.backButton}>
          <Button
            onPress={() => this.props.onBackAction()}
            color="green"
            title="Back"
          />
        </View>
      );
    }
  }

  renderCancelLink() {
    if (this.props.onCancelAction) {
      return (
        <View style={styles.cancelButton}>
          <Button
            onPress={() => this.props.onCancelAction()}
            color="green"
            title="Cancel"
          />
        </View>
      );
    }
  }

  renderTitle() {
    if (this.props.subtitle && this.props.currentStep && this.props.totalSteps) {
      return (
        <View style={styles.title}>
          <View style={styles.subtitle}>
            <Text style={styles.text}>
              { this.props.title }
            </Text>
          </View>
          <Text style={styles.subtext}>
            { this.props.subtitle }: {this.props.currentStep}/{ this.props.totalSteps }
          </Text>
        </View>
      );
    } else {
      return (
        <View style={[styles.title, styles.extraPaddingTop]}>
          <Text style={[styles.text, styles.rightText]}>
            { this.props.title }
          </Text>
        </View>
      );
    }
  }

  render() {
    const backLink = this.renderBackLink();
    const cancelLink = this.renderCancelLink();
    const title = this.renderTitle();

    return (
      <View style={styles.header}>
        <View>
          { backLink }
        </View>
        <View>
          { title }
        </View>
        <View>
          { cancelLink }
        </View>
      </View>
    );
  }
}

Header.propTypes = {
  title: PropTypes.string,
  subtitle: PropTypes.string,
  currentStep: PropTypes.string,
  totalSteps: PropTypes.string,
  onBackAction: PropTypes.func,
  onCancelAction: PropTypes.func
};

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    marginTop: 20,
    paddingBottom: 10,
    backgroundColor: 'white',
    width: Dimensions.get('window').width,
  },
  backButton: {
    alignItems: 'flex-start',
    paddingLeft: 5,
  },
  cancelButton: {
    alignItems: 'flex-end',
    paddingRight: 5,
  },
  title: {
    marginTop: 0,
    marginBottom: 0,
    paddingBottom: 0,
    paddingTop: 0,
  },
  subtitle: {
    marginTop: 0,
    marginBottom: 0,
    paddingBottom: 0,
    paddingTop: 0,
  },
  rightText: {
    textAlign: 'right',
  },
  extraPaddingTop: {
    paddingTop: 5
  },
  text: {
    fontSize: 18,
    textAlign: 'center',
    width: Dimensions.get('window').width - 140,
  },
  subtext: {
    color: '#869099',
    fontSize: 13,
    textAlign: 'center',
    width: Dimensions.get('window').width - 140,
  },
});