import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import {
  Title, Center, Stack, Text, Space,
} from '@mantine/core';
import regression from 'regression';
import {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI,
  getStockOBV, getStockADX, getStockAROON, getStockSTOCH,
} from '../api/getStockInfo';
import { fetchStock } from '../api/getStocks';
import Analysis from './Analysis';
import StockFinancials from './StockFinancials';
import StockIndicator1 from './StockIndicator1';
import StockIndicator2 from './StockIndicator2';

export function StockInfo({ symbol }) {
  const [name, setName] = useState('');
  const [price, setPrice] = useState(0.0);
  const [summary, setSummary] = useState('');
  const [profitMargin, setProfitMargin] = useState(0.0);
  const [grossProfit, setGrossProfit] = useState('');
  const [EPS, setEPS] = useState(0.0);
  const [EMA8, setEMA8] = useState(0.0);
  const [EMA20, setEMA20] = useState(0.0);
  const [MACD, setMACD] = useState(0.0);
  const [signal, setSignal] = useState(0.0);
  const [RSI, setRSI] = useState(0.0);
  const [analysis, setAnalysis] = useState(0.0);
  const [OBV, setOBV] = useState(0.0);
  const [OBVgradient, setOBVgradient] = useState(0.0);
  const [OBVcorrelation, setOBVcorrelation] = useState(0.0);
  const [ADX, setADX] = useState(0.0);
  const [AROONUp, setAROONUp] = useState(0.0);
  const [AROONDown, setAROONDown] = useState(0.0);
  const [STOCH, setSTOCH] = useState(0.0);

  useEffect(() => {
    (async () => {
      if (symbol === '') {
        return;
      }
      const stock = await fetchStock(symbol);
      setName(stock.name);
      setPrice(stock.price);
      setSummary(stock.summary);
      setProfitMargin(stock.profit_margin);
      setGrossProfit(stock.gross_profit);
      setEPS(stock.diluted_eps);

      try {
        const ema8temp = await getStockEMA8(symbol);
        setEMA8(ema8temp);
        const ema20temp = await getStockEMA20(symbol);
        setEMA20(ema20temp);
        const macd = await getStockMACD(symbol);
        setMACD(macd[0]);
        setSignal(macd[1]);
        const rsitemp = await getStockRSI(symbol);
        setRSI(rsitemp);
        const obvtemp = await getStockOBV(symbol);
        setOBV(obvtemp[0][1]);
        const adxtemp = await getStockADX(symbol);
        setADX(adxtemp);
        const aroontemp = await getStockAROON(symbol);
        setAROONDown(aroontemp[0]);
        setAROONUp(aroontemp[1]);
        const stochtemp = await getStockSTOCH(symbol);
        setSTOCH(stochtemp);

        let macdMeasure = 10 * (macd[0] - macd[1]);
        if (macd[0] > 0 && macd[0] < macd[1]) {
          macdMeasure = 0;
        }

        const rsiMeasure = (rsitemp * -1) + 50;

        const result = regression.linear(obvtemp);
        const gradient = result.equation[0];
        setOBVgradient(gradient);
        const gradientMeasure = gradient < 0 ? Math.max(-100, gradient) : Math.min(100, gradient);
        const correlation = result.r2;
        setOBVcorrelation(correlation);
        const obvMeasure = gradientMeasure * correlation * 0.1;

        const adxMeasure = adxtemp - 25;

        const aroonMeasure = (aroontemp[1] - aroontemp[0]) * 0.1;

        const stochMeasure = (stochtemp * -1 + 50) * 0.5;

        const value = macdMeasure + rsiMeasure + obvMeasure
        + adxMeasure + aroonMeasure + stochMeasure;
        setAnalysis(value);
      } catch (e) {
        // eslint-disable-next-line no-console
        console.error(e);
      }
    })();
  }, [symbol]);

  return (
    <Center>
      <Stack>
        <Space h="xl" />
        <Title padding="xl" align="center">
          {name}
          {name.length === 0 && (symbol)}
        </Title>
        <Text style={{ marginTop: 10, marginLeft: 50, marginRight: 50 }}>
          {summary}
        </Text>
        <StockFinancials
          price={price}
          profitMargin={profitMargin}
          grossProfit={grossProfit}
          EPS={EPS}
        />
        <StockIndicator1
          symbol={symbol}
          price={price}
          EMA8={EMA8}
          EMA20={EMA20}
          MACD={MACD}
          signal={signal}
          RSI={RSI}
        />
        <StockIndicator2
          symbol={symbol}
          price={price}
          OBV={OBV}
          OBVgradient={OBVgradient}
          OBVcorrelation={OBVcorrelation}
          ADX={ADX}
          AROONDown={AROONDown}
          AROONUp={AROONUp}
          STOCH={STOCH}
        />
        <Center>
          <Analysis value={analysis} />
        </Center>
      </Stack>
    </Center>
  );
}

StockInfo.propTypes = {
  symbol: PropTypes.string.isRequired,
};

export default StockInfo;
