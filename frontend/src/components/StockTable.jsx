/* eslint-disable no-console */
import React, { useState, useEffect } from 'react';
import {
  Table, Center, ScrollArea, Stack, Text, Box,
} from '@mantine/core';
import getStocks from '../api/getStocks';
import Title from './Title';
import StockFilter from './Filter';
import DisplayStock from './Stock';

export function StockTable() {
  const [rows, setRows] = useState(null);

  useEffect(() => {
    getStocks()
      .then((data) => {
        if (data.length === 0) {
          throw new Error('empty data');
        }
        setRows(
          data.map((item) => (
            DisplayStock(item)
          )),
        );
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

  return (
    <Stack>
      <Title />
      <Center>
        <Stack>
          <Box align="Right">
            <StockFilter />
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
                    <th>Industry</th>
                    <th>Sector</th>
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
