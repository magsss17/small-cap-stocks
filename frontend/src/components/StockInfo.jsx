import React, { useEffect, useState } from 'react';
import {
  Title, Center, Stack, Text, createStyles, Group, Paper, SimpleGrid, Space,
} from '@mantine/core';
import PropTypes from 'prop-types';
import {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI,
} from '../api/getStockInfo';

const useStyles = createStyles((theme) => ({
  root: {
    padding: `calc(${theme.spacing.xl} * 0.8)`,
  },

  label: {
    fontFamily: `Greycliff CF, ${theme.fontFamily}`,
  },
}));

export function StockInfo({
  symbol, name, price, summary,
}) {
  const [EMA8, setEMA8] = useState(0.0);
  const [EMA20, setEMA20] = useState(0.0);
  const [MACD, setMACD] = useState(0.0); // [MACD, signal]
  const [RSI, setRSI] = useState(0.0);

  useEffect(() => {
    (async () => {
      setEMA8(await getStockEMA8(symbol));
      setEMA20(await getStockEMA20(symbol));
      setMACD(await getStockMACD(symbol));
      setRSI(await getStockRSI(symbol));
    })();
  }, []);

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
        <Space h="xl" />
        <Title padding="xl" align="center">
          {name}
          {' '}
          (
          {symbol}
          )
        </Title>
        <Text style={{ marginTop: 10, marginLeft: 50, marginRight: 50 }}>
          {summary}
        </Text>
        <div className={classes.root}>
          <SimpleGrid cols={4} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
            <Paper withBorder p="md" radius="md" key="price">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Current Stock Price
                  </Text>
                  <Text fw={700} fz="xl">
                    $
                    {(Math.round(price * 100) / 100).toFixed(2)}
                  </Text>
                </div>
              </Group>
            </Paper>
            <Paper withBorder p="md" radius="md" key="profitmargin">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Profit Margin
                  </Text>
                  <Text fw={700} fz="xl" c={EMA20 < price ? 'teal' : 'red'}>
                    {EMA20}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Profit margins measure profitability as a percentage.
              </Text>
            </Paper>
            <Paper withBorder p="md" radius="md" key="MACD">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Gross Profit (ttm)
                  </Text>
                  <Text fw={700} fz="xl" c={MACD > price ? 'teal' : 'red'}>
                    {MACD}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Gross profit measures overall profitability.
              </Text>
            </Paper>
            <Paper withBorder p="md" radius="md" key="RSI">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Diluted EPS (ttm)
                  </Text>
                  <Text fw={700} fz="xl" c={rsiColor()}>
                    {RSI}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Diluted EPS shows how much profit a company generates for each share of its stock.
              </Text>
            </Paper>
          </SimpleGrid>
        </div>
        <div className={classes.root}>
          <SimpleGrid cols={4} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
            <Paper withBorder p="md" radius="md" key="EMA8">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Exponential Moving Average (8 weeks)
                  </Text>
                  <Text fw={700} fz="xl" c={EMA8 < price ? 'teal' : 'red'}>
                    {EMA8}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                EMA tracks the price of a stock over 8 weeks, giving more weighting to recent
                price data. The 8 week EMA indicates a
                {EMA8 < price ? ' buy' : ' sell'}
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
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Exponential Moving Average (20 weeks)
                  </Text>
                  <Text fw={700} fz="xl" c={EMA20 < price ? 'teal' : 'red'}>
                    {EMA20}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                EMA tracks the price of a stock over 20 weeks, giving more weighting to recent
                price data. The 20 week EMA indicates a
                {EMA20 < price ? ' buy' : ' sell'}
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
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Moving Average Convergence/Divergence
                  </Text>
                  <Text fw={700} fz="xl" c={MACD > price ? 'teal' : 'red'}>
                    {MACD}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                MACD is a trend following meomentum indicator. MACD indicates a
                {MACD > price ? ' buy' : ' sell'}
                {' '}
                for
                {' '}
                {symbol}
                .
              </Text>
            </Paper>
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
                RSI is a momentum indicator that evaluates a stock using average gain and
                average loss. RSI indicates that
                {' '}
                {symbol}
                {' '}
                is
                {' '}
                {rsiAnalysis()}
                .
              </Text>
            </Paper>
          </SimpleGrid>
        </div>
      </Stack>
    </Center>
  );
}

StockInfo.propTypes = {
  symbol: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  price: PropTypes.number.isRequired,
  summary: PropTypes.string.isRequired,
};

export default StockInfo;
