/* eslint-disable no-unused-vars */
import React from 'react';
import PropTypes from 'prop-types';
import { RingProgress, Text } from '@mantine/core';

export default function Analyze({ value }) {
  const displayValue = () => {
    if (Number.isNaN(value)) {
      return 0.0;
    }
    return Math.abs(value).toFixed(2);
  };

  const color = () => {
    if (value > 0) {
      return 'teal';
    }
    return 'red';
  };

  const recommendation = () => {
    if (value > 0) {
      return 'Buy';
    }
    return 'Sell';
  };

  return (
    <RingProgress
      sections={[{ value: displayValue(), color: color() }]}
      size={300}
      thickness={30}
      label={(
        <Text color={color()} weight={700} align="center" size="xl">
          {recommendation()}
          {'  '}
          {displayValue() }
          %
        </Text>
    )}
    />
  );
}

Analyze.propTypes = {
  value: PropTypes.number.isRequired,
};
