/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import React, { useState, useEffect } from 'react';
import {
  Table, Center, ScrollArea, Stack, Text, Box, NativeSelect,
} from '@mantine/core';
import { getStocks } from '../api/getStocks';
import { sortByName, sortByGrowth, sortByPrice } from '../portfolio';
import Title from './Title';
import DisplayStock from './Stock';

const fetchStocks = (value, stocks) => {
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
  const [value, setValue] = useState('Name');
  let stocks = null;

  const displayStocks = (data) => {
    if (data.length === 0) {
      throw new Error('empty data');
    }
    setRows(
      data.map((item) => (
        DisplayStock(item)
      )),
    );
  };

  useEffect(() => {
    stocks = getStocks();
    const sort = fetchStocks(value, stocks);

    sort()
      .then((data) => displayStocks(data))
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
    const sort = fetchStocks(value, stocks);
    sort()
      .then((data) => displayStocks(data))
      .catch((e) => {
        console.log(e);
        setRows(
          <tr>
            <td><Text>No Data</Text></td>
          </tr>,
        );
      });
  }, [value]);

  return (
    <Stack>
      <Title />
      <Center>
        <Stack>
          <Box align="Right">
            <Box w={400} align="Left">
              <NativeSelect
                label="Filter Stocks By:"
                data={[
                  { value: 'Name', label: 'Name' },
                  { value: 'Price', label: 'Price' },
                  { value: 'Growth', label: 'Growth' },
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
