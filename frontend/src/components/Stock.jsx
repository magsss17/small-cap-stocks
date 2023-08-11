import React from 'react';
import {
  HoverCard, Text, Anchor,
} from '@mantine/core';
import { Bounce } from 'react-activity';
import 'react-activity/dist/library.css';

export function Display(stock) {
  const {
    symbol, name, price, growth, industry, sector, summary,
  } = stock;
  return (
    <tr key={symbol}>
      <td>
        <Anchor variant="subtle" color="dark" href={`/stock?symbol=${symbol}`}>
          {symbol}
        </Anchor>

      </td>
      <td>
        <HoverCard width={800}>
          <HoverCard.Target>
            <Text fz="md" fw={500}>
              {name}
            </Text>
          </HoverCard.Target>
          {summary.length > 0 && (
            <HoverCard.Dropdown>
              <Text size="sm">
                {summary}
              </Text>
            </HoverCard.Dropdown>
          )}
        </HoverCard>
      </td>
      <td>
        <Text fz="md" fw={500}>
          $
          {(Math.round(price * 100) / 100).toFixed(2)}
        </Text>
      </td>
      <td>
        <Text fz="md" fw={500}>
          {growth}
          %
        </Text>
      </td>
      <td>
        {!sector ? <Bounce /> : (
          <Text fz="md" fw={500}>
            {sector}
          </Text>
        )}
      </td>
      <td>
        {!industry ? <Bounce /> : (
          <Text fz="md" fw={500}>
            {industry}
          </Text>
        )}
      </td>
    </tr>

  );
}

export default Display;
