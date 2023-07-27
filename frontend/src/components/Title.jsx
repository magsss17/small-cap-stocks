import React from 'react';
import {
  Center, Title, Stack, Space,
} from '@mantine/core';

export function Header() {
  return (
    <Center>
      {' '}
      <Stack>
        <Space h="xl" />
        <Title align="center">
          Welcome to Small Cap Stock Tracker!
        </Title>
        <Title order={3} align="center">By Johnny and Maggie</Title>
      </Stack>
    </Center>

  );
}

export default Header;
