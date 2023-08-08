import React from 'react';
import {
  SimpleGrid, Paper, Group, Text,
} from '@mantine/core';
import PropTypes from 'prop-types';

export default function StockFinancials({
  price, profitMargin, grossProfit, EPS,
}) {
  const PE = () => {
    if (EPS === 0) {
      return 'N/A';
    }
    return (price / EPS).toFixed(2);
  };

  return (
    <div>
      <SimpleGrid
        cols={5}
        breakpoints={[{ maxWidth: 'sm', cols: 1 }]}
        style={{ marginTop: 10, marginLeft: 50, marginRight: 50 }}
      >
        <Paper withBorder p="md" radius="md" key="price">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Current Stock Price
              </Text>
              <Text fw={700} fz="xl">
                $
                {(Math.round(price * 100) / 100).toFixed(2)}
              </Text>
            </div>
          </Group>
        </Paper>
        <Paper withBorder p="md" radius="md" key="profitmargin">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Profit Margin
              </Text>
              <Text fw={700} fz="xl" c={profitMargin >= 0 ? 'teal' : 'red'}>
                {profitMargin}
                {' '}
                %
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            Profit margins measure profitability as a percentage.
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="grossprofit">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Gross Profit (ttm)
              </Text>
              <Text fw={700} fz="xl">
                {grossProfit}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            Gross profit measures overall profitability.
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="eps">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Diluted EPS (ttm)
              </Text>
              <Text fw={700} fz="xl" c={EPS > 0 ? 'teal' : 'red'}>
                {EPS}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            Diluted EPS shows how much profit a company generates for each share of its stock.
          </Text>
        </Paper>
        <Paper withBorder p="md" radius="md" key="pe">
          <Group position="apart">
            <div>
              <Text c="dimmed" tt="uppercase" fw={700} fz="xs">
                Price to Equity Ratio
              </Text>
              <Text fw={700} fz="xl" c={(price / EPS) > 0 ? 'teal' : 'red'}>
                {PE()}
              </Text>
            </div>
          </Group>
          <Text c="dimmed" fz="sm" mt="md">
            Trailing PE ratio is calculated by dividing stock price by earnings per share.
          </Text>
        </Paper>
      </SimpleGrid>
    </div>
  );
}

StockFinancials.propTypes = {
  price: PropTypes.number.isRequired,
  profitMargin: PropTypes.number.isRequired,
  grossProfit: PropTypes.string.isRequired,
  EPS: PropTypes.number.isRequired,
};
