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
          Welcome to John John John John Capital
        </Title>
        <Title order={3} align="center">By John John and John John</Title>
      </Stack>
    </Center>

  );
}

export default Header;
