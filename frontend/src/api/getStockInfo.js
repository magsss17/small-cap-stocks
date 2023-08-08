const alphavantagekey = 'TNIK6NF3OSC44QJYt';

const getStockEMA8 = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/ema/${symbol}?timespan=day&adjusted=true&window=8&series_type=close&order=desc&limit=10&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  return data.results.values[0].value;
};

const getStockEMA20 = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/ema/${symbol}?timespan=day&adjusted=true&window=20&series_type=close&order=desc&limit=10&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  return data.results.values[0].value;
};

const getStockMACD = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/macd/${symbol}?timespan=day&adjusted=true&short_window=12&long_window=26&signal_window=9&series_type=close&order=desc&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  // return [macd, signal]
  return [data.results.values[0].value, data.results.values[0].signal];
};

const getStockRSI = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/rsi/${symbol}?timespan=day&adjusted=true&window=14&series_type=close&order=desc&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  return data.results.values[0].value;
};

const getStockOBV = async (symbol) => {
  const response = await fetch(`https://www.alphavantage.co/query?function=OBV&symbol=${symbol}&interval=15min&apikey=${alphavantagekey}`);
  const data = await response.json();
  const obv = data['Technical Analysis: OBV'];
  const obvValues = Object.values(obv);
  const valuesArr = [Math.min(obvValues.length, 10)];
  for (let i = 0; i < Math.min(obvValues.length, 10); i += 1) {
    valuesArr[i] = [i, Number(obvValues[i].OBV)];
  }
  return valuesArr;
};

const getStockADX = async (symbol) => {
  const response = await fetch(`https://www.alphavantage.co/query?function=ADX&symbol=${symbol}&interval=15min&time_period=20&apikey=${alphavantagekey}`);
  const data = await response.json();
  const adx = data['Technical Analysis: ADX'];
  return Number(Object.values(adx)[0].ADX);
};

const getStockAROON = async (symbol) => {
  const response = await fetch(`https://www.alphavantage.co/query?function=AROON&symbol=${symbol}&interval=15min&time_period=20&apikey=${alphavantagekey}`);
  const data = await response.json();
  const aroon = Object.values(data['Technical Analysis: AROON'])[0];
  // return Aroon Down, Aroon Up
  return [Number(aroon['Aroon Down']), Number(aroon['Aroon Up'])];
};

const getStockSTOCH = async (symbol) => {
  const response = await fetch(`https://www.alphavantage.co/query?function=STOCH&symbol=${symbol}&interval=15min&apikey=${alphavantagekey}`);
  const data = await response.json();
  const stoch = data['Technical Analysis: STOCH'];
  return Number(Object.values(stoch)[0].SlowK);
};

export {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI, getStockOBV, getStockADX, getStockAROON,
  getStockSTOCH,
};
