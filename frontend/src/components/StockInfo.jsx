import React from 'react';
import {
  Title, Center, Stack, Text, createStyles, Group, Paper, SimpleGrid,
} from '@mantine/core';
import {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI,
} from '../api/getStockInfo';

const useStyles = createStyles((theme) => ({
  root: {
    padding: `calc(${theme.spacing.xl} * 1.5)`,
  },

  label: {
    fontFamily: `Greycliff CF, ${theme.fontFamily}`,
  },
}));

export function StockInfo(symbol) {
  // need to get stock name and price
  const EMA8 = getStockEMA8(symbol);
  const EMA20 = getStockEMA20(symbol);
  const MACD = getStockMACD(symbol); // [MACD, signal]
  const RSI = getStockRSI(symbol);

  const rsiColor = () => {
    if (RSI >= 70) {
      return 'red';
    }
    if (RSI <= 30) {
      return 'green';
    }
    return 'black';
  };

  const rsiAnalysis = () => {
    if (RSI >= 70) {
      return 'overbought';
    } if (RSI <= 30) {
      return 'oversold';
    } return 'inconclusive';
  };

  const { classes } = useStyles();

  return (
    <Center>
      <Stack>
        <Title>
          {symbol}
        </Title>
        <div className={classes.root}>
          <SimpleGrid cols={3} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
            <Paper withBorder p="md" radius="md" key="EMA8">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Exponential Moving Average (8 weeks)
                  </Text>
                  <Text fw={700} fz="xl" c={EMA8 < price ? 'teal' : 'red'}>
                    {EMA8[0]}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                8 week EMA indicates a
                {EMA8 < price ? ' buy' : ' sell'}
                {' '}
                for
                {' '}
                {symbol}
              </Text>
            </Paper>
          </SimpleGrid>
          <SimpleGrid cols={3} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
            <Paper withBorder p="md" radius="md" key="EMA20">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Exponential Moving Average (20 weeks)
                  </Text>
                  <Text fw={700} fz="xl" c={EMA20 < price ? 'teal' : 'red'}>
                    {EMA20}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                20 week EMA indicates a
                {EMA20 < price ? 'buy' : 'sell'}
                {' '}
                for
                {' '}
                {symbol}
              </Text>
            </Paper>
          </SimpleGrid>
          <SimpleGrid cols={3} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
            <Paper withBorder p="md" radius="md" key="MACD">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Moving Average Convergence/Divergence
                  </Text>
                  <Text fw={700} fz="xl" c={MACD[0] > MACD[1] ? 'teal' : 'red'}>
                    {MACD[0]}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                MACD indicates a
                {MACD[0] > MACD[1] ? ' buy' : ' sell'}
                {' '}
                for
                {' '}
                {symbol}
              </Text>
            </Paper>
          </SimpleGrid>
          <SimpleGrid cols={3} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
            <Paper withBorder p="md" radius="md" key="RSI">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Relative Strength Index
                  </Text>
                  <Text fw={700} fz="xl" c={rsiColor()}>
                    {RSI}
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
                {rsiAnalysis()}
              </Text>
            </Paper>
          </SimpleGrid>
        </div>
      </Stack>
    </Center>
  );
}

export default StockInfo;
