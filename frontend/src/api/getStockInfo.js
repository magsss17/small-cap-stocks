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

export {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI,
};
