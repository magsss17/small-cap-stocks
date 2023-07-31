const express = require('express');
const router = express.Router();

const axios = require('axios');

/* GET home page. */
router.get('/', async function(req, res, next) {
  const response = await axios('https://finance.yahoo.com/screener/predefined/small_cap_gainers?offset=0&count=100');
  console.log(response.data);
  res.render('index', { title: 'Express' });
});

module.exports = router;
