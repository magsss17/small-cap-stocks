const getStocksSymbol = async () => {
  const response = await fetch('/stock-filter-symbol');
  const data = await response.json();
  return data;
};

const getStocks = async () => {
  const response = await fetch('/stock-filter-name');
  const data = await response.json();
  return data;
};

const getStocksGrowth = async () => {
  const response = await fetch('/stock-filter-growth');
  const data = await response.json();
  return data;
};

const getStocksSector = async () => {
  const response = await fetch('/stock-filter-sector');
  const data = await response.json();
  return data;
};

const getStocksPrice = async () => {
  const response = await fetch('/stock-filter-price');
  const data = await response.json();
  return data;
};

const getStocksIndustry = async () => {
  const response = await fetch('/stock-filter-industry');
  const data = await response.json();
  return data;
};

const fetchStockDetails = async (symbol) => {
  const response = await fetch(`/stock-details?symbol=${symbol}`);
  const data = await response.json();
  return data;
};

const fetchStockFinancials = async (symbol) => {
  const response = await fetch(`/stock-financials?symbol=${symbol}`);
  const data = await response.json();
  return data;
};

export {
  getStocksSymbol, getStocks, getStocksGrowth, getStocksSector, getStocksPrice,
  getStocksIndustry, fetchStockDetails, fetchStockFinancials,
};
