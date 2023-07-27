import React from 'react';

import { Select, Box } from '@mantine/core';

export function Filter() {
  return (
    <Box w={400} align="Left">
      <Select
        defaultValue="Name"
        label="Filter Stocks By:"
        data={[
          { value: 'Name', label: 'Name' },
          { value: 'Price', label: 'Price' },
          { value: 'Growth', label: 'Growth' },
        ]}
      />
    </Box>

  );
}

export default Filter;
