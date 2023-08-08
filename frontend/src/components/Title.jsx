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
          Welcome to Ms. Jr. Capital
        </Title>
        <Title order={3} align="center">By Mag</Title>
      </Stack>
    </Center>

  );
}

export default Header;
