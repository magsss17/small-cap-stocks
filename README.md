# JJJJ Capital - Small Cap Stock Tracker
By Johnny Ramirez and Maggie Schwierking

## Description
This website tracks and displays small cap stocks with highest growth percentages with the goal of allowing users to easily find up-and-coming companies.
A small cap stock is a stock from a public company whose total market cap is about $250 million to $2 billion.

## Instructions
The homepage displays small cap stocks with the highest daily growth. Use the dropdown menu on the right to sort stocks as desired.
To view an individual stock analysis, click on the symbol of the desired stock. The stock analysis pulls data from Yahoo finance and Polygon API.

### Stock Analysis
This page displays some key financial indicators for high volatility stocks, such as EMA, MACD, and RSI. Below is information on how to interpret the given analysis.
<br />
The analysis is designed with high volatility of small cap stocks and frequent trading in mind. 
<br />
<br />
**Profit Margin & Gross Profit**
<br />
Profit margin shows a company's profitability, ie revenue - costs. However, profit margins rarely tell the full story as a company can be doing well but not be profitable. Fun fact: Uber only recently became profitable!
<br />
<br />
**Diluted EPS & P/E Ratio**
<br />
Diluted EPS and P/E Ratio are best used when comparing companies of the same industry/sector or comparing historical data for the same company. It is important to note that the P/E ratio is a trailing indicator, meaning it is calcuated using only historical data, which means it doesn't take into account any forward-looking expectations.
<br />
<br />
**EMA**
<br />
The 8 and 20 day EMA are most frequently used for short-term indications, making it perfect for small cap stocks. It is recommended to buy when the price is near or below the EMA and sell when the price is rallying or just above the EMA. 
<br />
<br />
**MACD**
<br />
The MACD is a trend-followng momentum indicator that is calculated by subtractin the 26-day EMA from the 12-day EMA. This means that the MACD is positive when the 12-period EMA exceeds the 26-period EMA. The buy/sell recommendations are based on using the 9-day EMA as the signal line. So, the MACD being above the signal line, indicates a buy while the MACD being below the signal line indicates a sell. 
<br />
<br />
**RSI**
<br />
The RSI is momentum indicator that evaluates whether a stock is overvalued or undervalued. It is calculated using average gains and losses over the previous 14 days. If the RSI is greater than 70, this indicates that the stock is overbought, and if the RSI is less than 30, the stock is oversold. It is important to note that these bounds may change based on industry and market conditions.
