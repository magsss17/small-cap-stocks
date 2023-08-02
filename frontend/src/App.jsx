import {
  BrowserRouter as Router,
  Route,
  Routes,
} from 'react-router-dom';
import './App.css';
import React from 'react';
import Home from './pages/Home';
import StockPage from './pages/StockPage';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/symbol" element={<StockPage />} />
      </Routes>
    </Router>
  );
}

export default App;
