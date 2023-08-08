import React from 'react';
import {
  SimpleGrid, Paper, Group, Text, Box,
} from '@mantine/core';
import PropTypes from 'prop-types';

export default function StockIndicator1({
  symbol, price, EMA8, EMA20, MACD, signal, RSI,
}) {
  const rsiAnalysis = () => {
    if (RSI >= 70) {
      return ['red', 'in a strong uptrend and overbought'];
    } if (RSI <= 30) {
      return ['teal', 'oversold'];
    } return ['black', 'inconclusive'];
  };

  const macdAnalysis = () => {
    if (MACD > 0 && MACD > signal) {
      return 'buy';
    } if (MACD < 0 && MACD < signal) {
      return 'short';
    } return 'inconclusive';
  };

  return (
    <Box padding="xl">
      <SimpleGrid
        cols={4}
        breakpoints={[{ maxWidth: 'sm', cols: 1 }]}
        style={{ marginTop: 10, marginLeft: 50, marginRight: 50 }}
      >
        <Paper withBorder p="md" radius="md" key="EMA8">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Exponential Moving Average (8 weeks)
              </Text>
              <Text fw={700} fz="xl" c={EMA8 > price ? 'teal' : 'red'}>
                {(EMA8).toFixed(4)}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            The 8 week EMA indicates a
            {EMA8 > price ? ' buy' : ' sell'}
            {' '}
            for
            {' '}
            {symbol}
            .
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="EMA20">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Exponential Moving Average (20 weeks)
              </Text>
              <Text fw={700} fz="xl" c={EMA20 > price ? 'teal' : 'red'}>
                {EMA20.toFixed(4)}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            The 20 week EMA indicates a
            {EMA20 > price ? ' buy' : ' sell'}
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
                Moving Average Convergence/Divergence
              </Text>
              <Text fw={700} fz="xl" c={MACD > 0 ? 'teal' : 'red'}>
                {MACD.toFixed(4)}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            MACD
            {MACD > 0 ? ' shows an uptrend' : ' shows a downtrend'}
            {' '}
            for
            {' '}
            {symbol}
            {' '}
            and the action that should be taken is
            {' '}
            {macdAnalysis()}
            .
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="RSI">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Relative Strength Index
              </Text>
              <Text fw={700} fz="xl" c={rsiAnalysis()[0]}>
                {RSI.toFixed(4)}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            RSI indicates that
            {' '}
            {symbol}
            {' '}
            is
            {' '}
            {rsiAnalysis()[1]}
            .
          </Text>
        </Paper>
      </SimpleGrid>
    </Box>
  );
}

StockIndicator1.propTypes = {
  symbol: PropTypes.string.isRequired,
  price: PropTypes.number.isRequired,
  EMA8: PropTypes.number.isRequired,
  EMA20: PropTypes.number.isRequired,
  MACD: PropTypes.number.isRequired,
  signal: PropTypes.number.isRequired,
  RSI: PropTypes.number.isRequired,
};
