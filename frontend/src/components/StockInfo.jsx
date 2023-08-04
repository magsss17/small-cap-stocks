import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import {
  Title, Center, Stack, Text, createStyles, Group, Paper, SimpleGrid, Space,
} from '@mantine/core';
import {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI,
} from '../api/getStockInfo';
import { fetchStockDetails, fetchStockFinancials } from '../api/getStocks';

const useStyles = createStyles((theme) => ({
  root: {
    padding: `calc(${theme.spacing.xl} * 0.8)`,
  },

  label: {
    fontFamily: `Greycliff CF, ${theme.fontFamily}`,
  },
}));

export function StockInfo({ symbol }) {
  const [name, setName] = useState('');
  const [price, setPrice] = useState(0.0);
  const [summary, setSummary] = useState('');
  const [profitMargin, setProfitMargin] = useState(0.0);
  const [grossProfit, setGrossProfit] = useState('');
  const [EPS, setEPS] = useState(0.0);
  const [EMA8, setEMA8] = useState(0.0);
  const [EMA20, setEMA20] = useState(0.0);
  const [MACD, setMACD] = useState(0.0); // [MACD, signal]
  const [signal, setSignal] = useState(0.0);
  const [RSI, setRSI] = useState(0.0);

  useEffect(() => {
    (async () => {
      if (symbol === '') {
        return;
      }
      const details = await fetchStockDetails(symbol);
      setName(details.name);
      setPrice(details.price);
      setSummary(details.summary);

      const financials = await fetchStockFinancials(symbol);
      setProfitMargin(financials.profit_margin);
      setGrossProfit(financials.gross_profit);
      setEPS(financials.diluted_eps);

      setEMA8(await getStockEMA8(symbol));
      setEMA20(await getStockEMA20(symbol));
      const macd = await getStockMACD(symbol);
      setMACD(macd[0]);
      setSignal(macd[1]);
      setRSI(await getStockRSI(symbol));
    })();
  }, [symbol]);

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

  const PE = () => {
    if (EPS === 0) {
      return 'N/A';
    }
    return (Math.round((price / EPS) * 100) / 100).toFixed(2);
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
          <SimpleGrid cols={5} breakpoints={[{ maxWidth: 'sm', cols: 1 }]}>
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
                  <Text fw={700} fz="xl" c={profitMargin >= 0 ? 'teal' : 'red'}>
                    {profitMargin}
                    {' '}
                    %
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Profit margins measure profitability as a percentage.
              </Text>
            </Paper>
            <Paper withBorder p="md" radius="md" key="grossprofit">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Gross Profit (ttm)
                  </Text>
                  <Text fw={700} fz="xl">
                    {grossProfit}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Gross profit measures overall profitability.
              </Text>
            </Paper>
            <Paper withBorder p="md" radius="md" key="eps">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Diluted EPS (ttm)
                  </Text>
                  <Text fw={700} fz="xl" c={EPS > 0 ? 'teal' : 'red'}>
                    {EPS}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Diluted EPS shows how much profit a company generates for each share of its stock.
              </Text>
            </Paper>
            <Paper withBorder p="md" radius="md" key="pe">
              <Group position="apart">
                <div>
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Price to Equity Ratio
                  </Text>
                  <Text fw={700} fz="xl" c={(price / EPS) > 0 ? 'teal' : 'red'}>
                    {PE()}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                Trailing PE ratio is calculated by dividing stock price by earnings per share.
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
                  <Text fw={700} fz="xl" c={EMA8 > price ? 'teal' : 'red'}>
                    {EMA8.toFixed(4)}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                EMA tracks the price of a stock over 8 weeks, giving more weighting to recent
                price data. The 8 week EMA indicates a
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
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Exponential Moving Average (20 weeks)
                  </Text>
                  <Text fw={700} fz="xl" c={EMA20 > price ? 'teal' : 'red'}>
                    {EMA20.toFixed(4)}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                EMA tracks the price of a stock over 20 weeks, giving more weighting to recent
                price data. The 20 week EMA indicates a
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
                  <Text c="dimmed" tt="uppercase" fw={700} fz="xs" className={classes.label}>
                    Moving Average Convergence/Divergence
                  </Text>
                  <Text fw={700} fz="xl" c={MACD > signal ? 'teal' : 'red'}>
                    {MACD.toFixed(4)}
                  </Text>
                </div>
              </Group>
              <Text c="dimmed" fz="sm" mt="md">
                MACD is a trend following meomentum indicator. MACD indicates a
                {MACD > signal ? ' buy' : ' sell'}
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
                    {RSI.toFixed(4)}
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
};

export default StockInfo;
