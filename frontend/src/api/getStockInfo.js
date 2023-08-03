const getStockEMA8 = async (symbol) => {
  console.log(symbol);
  const response = await fetch(`https://api.polygon.io/v1/indicators/ema/${symbol}?timespan=day&adjusted=true&window=8&series_type=close&order=desc&limit=10&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  console.log(data);
  return data;
};

const getStockEMA20 = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/ema/${symbol}?timespan=day&adjusted=true&window=20&series_type=close&order=desc&limit=10&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  return data;
};

const getStockMACD = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/macd/${symbol}?timespan=day&adjusted=true&short_window=12&long_window=26&signal_window=9&series_type=close&order=desc&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  console.log(data);
  // return [macd, signal]
  return data;
};

const getStockRSI = async (symbol) => {
  const response = await fetch(`https://api.polygon.io/v1/indicators/rsi/${symbol}?timespan=day&adjusted=true&window=14&series_type=close&order=desc&apiKey=ccQWEegjPQyZzFjXXgqBYd5vo6lGkwyT`);
  const data = await response.json();
  console.log(data);
  return data;
};

export {
  getStockEMA8, getStockEMA20, getStockMACD, getStockRSI,
};
