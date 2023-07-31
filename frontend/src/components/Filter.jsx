import React, { useState } from 'react';

import { NativeSelect, Box } from '@mantine/core';

export function Filter() {
  const [value, setValue] = useState('Name');

  return (
    <Box w={400} align="Left">
      <NativeSelect
        value={value}
        label="Filter Stocks By:"
        data={['Name', 'Price', 'Growth']}
        onChange={(event) => setValue(event.currentTarget.value)}
      />
    </Box>

  );
}

export default Filter;
