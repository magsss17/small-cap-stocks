const getStocksSymbol = async () => {
  const response = await fetch('http://ec2-54-243-141-88.compute-1.amazonaws.com:8080/stock-filter-symbol');
  const data = await response.json();
  return data;
};

const getStocksName = async () => {
  const response = await fetch('http://ec2-54-243-141-88.compute-1.amazonaws.com:8080/stock-filter-name');
  const data = await response.json();
  return data;
};

const getStocksGrowth = async () => {
  const response = await fetch('http://ec2-54-243-141-88.compute-1.amazonaws.com:8080/stock-filter-growth');
  const data = await response.json();
  return data;
};

const getStocksSector = async () => {
  const response = await fetch('http://ec2-54-243-141-88.compute-1.amazonaws.com:8080/stock-filter-sector');
  const data = await response.json();
  return data;
};

const getStocksPrice = async () => {
  const response = await fetch('http://ec2-54-243-141-88.compute-1.amazonaws.com:8080/stock-filter-price');
  const data = await response.json();
  return data;
};

export {
  getStocksSymbol, getStocksName, getStocksGrowth, getStocksSector, getStocksPrice,
};
