// import axios from 'axios';



const getStocks = async () => {
  const response = await fetch('http://ec2-52-23-112-99.compute-1.amazonaws.com:8080/stock-data');
  const data = await response.json();
  return data;
};

export default getStocks;
