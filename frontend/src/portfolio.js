/* eslint-disable max-len */
const sortBySymbol = (stocks) => stocks.sort((a, b) => a.symbol.localeCompare(b.symbol));

const sortByName = (stocks) => stocks.sort((a, b) => a.name.localeCompare(b.name));

const sortByPrice = (stocks) => stocks.sort((a, b) => b.price - a.price);

const sortByGrowth = (stocks) => stocks.sort((a, b) => b.growth - a.growth);

const sortByIndustry = (stocks) => stocks.sort((a, b) => a.industry.localeCompare(b.industry));

const sortBySector = (stocks) => stocks.sort((a, b) => a.sector.localeCompare(b.sector));

const sortBySummary = (stocks) => stocks.sort((a, b) => a.summary.localeCompare(b.summary));

export {
  sortBySymbol,
  sortByName,
  sortByPrice,
  sortByGrowth,
  sortByIndustry,
  sortBySector,
  sortBySummary,
};
