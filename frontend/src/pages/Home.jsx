/* eslint-disable no-console */
import React, { useState, useEffect } from 'react';
import {
  Table, Center, ScrollArea, Stack, Text, Box, NativeSelect,
} from '@mantine/core';
import { fetchStocks, fetchStock } from '../api/getStocks';
import { sortByName, sortByGrowth, sortByPrice } from '../portfolio';
import Title from '../components/Title';
import DisplayStock from '../components/Stock';

const sortStocks = (value, stocks) => {
  if (value === 'Price') {
    return sortByPrice(stocks);
  }
  if (value === 'Growth') {
    return sortByGrowth(stocks);
  }
  return sortByName(stocks);
};

export function StockTable() {
  const [rows, setRows] = useState(null);
  const [value, setValue] = useState('Growth');
  const [stocks, setStocks] = useState([]);

  const displayStocks = (data) => {
    if (data.length === 0) {
      throw new Error('empty data');
    }
    const sortedStocks = sortStocks(value, data);
    setRows(
      sortedStocks.map((item) => (
        DisplayStock(item)
      )),
    );
  };

  const updateStockPrices = (x) => {
    setTimeout(() => {
      console.log('Updating stock prices');
      fetch('/stocks?update-prices=true')
        .then((response) => response.json())
        .then((updatedStocks) => {
          setStocks(updatedStocks);
          const newStocks = updatedStocks.filter((stock) => stock.industry === '');
          for (let i = 0; i < newStocks.length; i += 1) {
            const stock = newStocks[i];
            fetchStock(stock.symbol).then((updatedStock) => {
              newStocks[i] = updatedStock;
              setStocks(newStocks);
            });
          }
          updateStockPrices(x + 1);
        });
    }, x * 3000);
  };

  useEffect(() => {
    fetchStocks()
      .then((fetchedStocks) => {
        setStocks(fetchedStocks);
        const newStocks = fetchedStocks.filter((stock) => stock.industry === '');
        for (let i = 0; i < newStocks.length; i += 1) {
          const stock = newStocks[i];
          fetchStock(stock.symbol).then((updatedStock) => {
            newStocks[i] = updatedStock;
            setStocks(newStocks);
          });
        }
        updateStockPrices(1);
      })
      .catch((e) => {
        console.log(e);
        setRows(
          <tr>
            <td><Text>No Data</Text></td>
          </tr>,
        );
      });
  }, []);

  useEffect(() => {
    if (stocks.length > 0) {
      displayStocks(stocks);
    }
  }, [stocks, value]);

  return (
    <Stack>
      <Title />
      <Center>
        <Stack>
          <Box align="Right">
            <Box w={400} align="Left">
              <NativeSelect
                label="Sort Stocks By:"
                data={[
                  { value: 'Growth', label: 'Growth' },
                  { value: 'Name', label: 'Name' },
                  { value: 'Price', label: 'Price' },
                ]}
                onChange={(event) => {
                  setValue(event.currentTarget.value);
                }}
              />
            </Box>
          </Box>
          <ScrollArea h={700}>
            <Box w={1800}>
              <Table highlightOnHover>
                <thead align={Center} fontSize="lg">
                  <tr>
                    <th>Symbol</th>
                    <th>Company Name</th>
                    <th>Price</th>
                    <th>Growth</th>
                    <th>Sector</th>
                    <th>Industry</th>
                  </tr>
                </thead>
                <tbody>{rows}</tbody>
              </Table>
            </Box>

          </ScrollArea>
        </Stack>
      </Center>
    </Stack>

  );
}

export default StockTable;
