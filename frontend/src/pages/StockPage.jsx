import React, { useEffect, useState } from 'react';
import StockAnalysis from '../components/StockInfo';

export function StockPage() {
  const [symbol, setSymbol] = useState('');

  useEffect(() => {
    const windowUrl = window.location.search;
    const params = new URLSearchParams(windowUrl);
    const paramSymbol = params.get('symbol');
    if (paramSymbol.length > 0) {
      setSymbol(paramSymbol);
      fetch(`/stock-details?symbol=${paramSymbol}`)
        .then((response) => response.json())
        .then((data) => {
          setSymbol(data.symbol);
        });
    }
  }, []);

  return (
    <StockAnalysis symbol={symbol} />
  );
}

export default StockPage;
