import React from 'react';
import * as ReactDOMClient from 'react-dom/client';

import { MantineProvider } from '@mantine/core';
import reportWebVitals from './reportWebVitals';
import App from './App';

const root = ReactDOMClient.createRoot(document.getElementById('root'));

root.render(
  <MantineProvider
    theme={{
      colorScheme: 'light',
      fontFamily: 'Georgia',
    }}
    withGlobalStyles
    withNormalizeCSS
  >
    <App />
  </MantineProvider>,
);
// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
