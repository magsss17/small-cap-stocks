import React from 'react';
import {
  SimpleGrid, Paper, Group, Text,
} from '@mantine/core';
import PropTypes from 'prop-types';
import { Bounce } from 'react-activity';
import 'react-activity/dist/library.css';

export default function StockIndicator2({
  symbol, OBV, OBVgradient, OBVcorrelation, ADX, AROONDown, AROONUp, STOCH,
}) {
  const adxAnalyze = () => {
    if (ADX >= 40) {
      return ['teal', 'strong directional strength, indicating a buy'];
    } if (ADX <= 20) {
      return ['red', 'weak or non-trending directional strenght, indicating a sell'];
    } if (ADX >= 25) {
      return ['black ', 'a close to strong directional strength, indicating a hesitant buy'];
    }
    return ['black', 'inconclusive'];
  };

  const stochAnalyze = () => {
    if (STOCH >= 80) {
      return ['red', 'overbought'];
    } if (ADX <= 20) {
      return ['teal', 'oversold'];
    }
    return ['black', 'inconclusive'];
  };

  const OBVTrendAnalysis = () => {
    if (OBVgradient > 0) {
      if (OBVcorrelation < 0.30) {
        return ['very weak positive trend', 'no action'];
      }
      if (OBVcorrelation < 0.70) {
        return ['moderate positive trend', 'buy'];
      } if (OBVcorrelation < 0.80) {
        return ['strong positive trend', 'buy'];
      }
      return ['very strong positive trend', 'strong buy'];
    }
    if (OBVcorrelation < 0.30) {
      return ['very weak negative trend', 'no action'];
    }
    if (OBVcorrelation < 0.70) {
      return ['moderate negative trend', 'sell'];
    } if (OBVcorrelation < 0.80) {
      return ['strong negative trend', 'sell'];
    }
    return ['very strong negative trend', 'strong sell'];
  };

  return (
    <div>
      <SimpleGrid
        cols={4}
        breakpoints={[{ maxWidth: 'sm', cols: 1 }]}
        style={{ marginTop: 10, marginLeft: 50, marginRight: 50 }}
      >
        <Paper withBorder p="md" radius="md" key="EMA8">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                On-Balance Volume (OBV)
              </Text>
              {
                (OBV) === 0 ? <Bounce />
                  : (
                    <Text fw={700} fz="xl" c={OBV > 0 ? 'teal' : 'red'}>
                      {OBV}
                    </Text>
                  )
              }
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            OBV trend shows a
            {' '}
            {OBVTrendAnalysis()[0]}
            {' '}
            which indicates
            {' '}
            {OBVTrendAnalysis()[1]}
            .
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="EMA20">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Average Directional Index (ADX)
              </Text>
              {
                (ADX) === 0 ? <Bounce />
                  : (
                    <Text fw={700} fz="xl" c={adxAnalyze()[0]}>
                      {Number(ADX).toFixed(4)}
                    </Text>
                  )
              }
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            ADX shows
            {' '}
            {adxAnalyze()[1]}
            {' '}
            for
            {' '}
            {symbol}
            .
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="MACD">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Aroon Oscillator
              </Text>
              {
                (ADX) === 0 ? <Bounce />
                  : (
                    <Text fw={700} fz="xl" c={AROONUp > AROONDown ? 'teal' : 'red'}>
                      {AROONUp - AROONDown}
                    </Text>
                  )
              }

            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            AROON indicates
            {AROONUp > AROONDown ? ' an uptrend and buy ' : ' a downtrend and sell '}
            for
            {' '}
            {symbol}
            {' '}
            since AROON Up is
            {' '}
            {AROONUp}
            {' '}
            and AROON Down is
            {' '}
            {AROONDown}
            .
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="RSI">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Stochastic Indicator
              </Text>
              {
                (STOCH) === 0 ? <Bounce />
                  : (
                    <Text fw={700} fz="xl" c={stochAnalyze()[0]}>
                      {Number(STOCH).toFixed(4)}
                    </Text>
                  )
              }
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            Stochastic Indicator indicates that
            {' '}
            {symbol}
            {' '}
            is
            {' '}
            {stochAnalyze()[1]}
            .
          </Text>
        </Paper>
      </SimpleGrid>
    </div>
  );
}

StockIndicator2.propTypes = {
  symbol: PropTypes.string.isRequired,
  OBV: PropTypes.number.isRequired,
  OBVgradient: PropTypes.number.isRequired,
  OBVcorrelation: PropTypes.number.isRequired,
  ADX: PropTypes.number.isRequired,
  AROONDown: PropTypes.number.isRequired,
  AROONUp: PropTypes.number.isRequired,
  STOCH: PropTypes.number.isRequired,
};
