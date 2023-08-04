const fetchStocks = async () => {
  const response = await fetch('/stocks');
  const data = await response.json();
  return data;
};

const fetchStock = async (symbol) => {
  console.log(`Fetching stock ${symbol}`);
  const response = await fetch(`/stock?symbol=${symbol}`);
  const data = await response.json();
  return data;
};

export {
  fetchStock, fetchStocks,
};
