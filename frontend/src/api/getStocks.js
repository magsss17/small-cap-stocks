const getStocks = async () => {
  const response = await fetch('/stock-data');
  const data = await response.json();
  return data;
};

export default getStocks;
