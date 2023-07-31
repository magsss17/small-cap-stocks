/* eslint-disable max-len */
const sortBySymbol = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => a.symbol.localeCompare(b.symbol)));

const sortByName = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => a.name.localeCompare(b.name)));

const sortByPrice = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => b.price - a.price));

const sortByGrowth = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => b.growth - a.growth));

const sortByIndustry = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => a.industry.localeCompare(b.industry)));

const sortBySector = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => a.sector.localeCompare(b.sector)));

const sortBySummary = (stocks) => Object.values(stocks).forEach((stock) => stock.sort((a, b) => a.summary.localeCompare(b.summary)));

export {
  sortBySymbol,
  sortByName,
  sortByPrice,
  sortByGrowth,
  sortByIndustry,
  sortBySector,
  sortBySummary,
};
