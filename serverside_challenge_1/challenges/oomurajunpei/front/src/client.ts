import axios from 'axios';
import applyCaseMiddleware from 'axios-case-converter';

type params = {
  ampere: number,
  electricityUsage: string
}

const api = applyCaseMiddleware(
  axios.create({
    baseURL:
      process.env.NODE_ENV === 'development'
        ? process.env.REACT_APP_API_BASE_URL_DEV
        : process.env.REACT_APP_API_BASE_URL_PROD,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    }
  })
);

export const getElectricityRateSimulation = (params: params) => {
  return api.get('/electricity_rate_simulation', {params})
}
