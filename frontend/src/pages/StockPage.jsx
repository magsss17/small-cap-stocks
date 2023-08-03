import React, { useEffect, useState } from 'react';
import StockAnalysis from '../components/StockInfo';

export function StockPage() {
  const [symbol, setSymbol] = useState('');
  const [price, setPrice] = useState(0.0);
  const [summary, setSummary] = useState('');
  const [name, setName] = useState('');
  useEffect(() => {
    const windowUrl = window.location.search;
    const params = new URLSearchParams(windowUrl);
    const paramSymbol = params.get('symbol');
    if (paramSymbol.length > 0) {
      setSymbol(paramSymbol);
      fetch(`/stock-details?symbol=${paramSymbol}`)
        .then((response) => response.json())
        .then((data) => {
          setPrice(data.price);
          setSymbol(data.symbol);
          setSummary(data.summary);
          setName(data.name);
        });
      console.log(paramSymbol);
    }
  }, []);

  return (
    <StockAnalysis symbol={symbol} price={price} summary={summary} name={name} />
  );
}

export default StockPage;
