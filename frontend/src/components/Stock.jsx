import React from 'react';

import {
  HoverCard, Text,
} from '@mantine/core';

export function Display(stock) {
  const {
    symbol, name, price, growth, industry, sector, summary,
  } = stock;
  return (

    <tr key={symbol}>
      <td>
        <Text fz="md" fw={500}>
          {symbol}
        </Text>
      </td>
      <td>
        <HoverCard width={800}>
          <HoverCard.Target>
            <Text fz="md" fw={500}>
              {name}
            </Text>
          </HoverCard.Target>
          <HoverCard.Dropdown>
            <Text size="sm">
              {summary}
            </Text>
          </HoverCard.Dropdown>
        </HoverCard>
      </td>
      <td>
        <Text fz="md" fw={500}>
          $
          {price}
        </Text>
      </td>
      <td>
        <Text fz="md" fw={500}>
          {growth}
          %
        </Text>
      </td>
      <td>
        <Text fz="md" fw={500}>
          {sector}
        </Text>
      </td>
      <td>
        <Text fz="md" fw={500}>
          {industry}
        </Text>
      </td>
    </tr>

  );
}

export default Display;
