import React, { useEffect, useState } from 'react';

export function StockPage() {
  const [symbol, setSymbol] = useState('');
  useEffect(() => {
    const windowUrl = window.location.search;
    const params = new URLSearchParams(windowUrl);
    const paramSymbol = params.get('symbol');
    if (paramSymbol.length > 0) {
      setSymbol(paramSymbol);
    }
  }, []);
  return (
    <div>
      <p>{symbol}</p>
    </div>
  );
}

export default StockPage;
