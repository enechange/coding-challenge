const mode = process.env.REACT_APP_MODE

const HOST =
  mode === 'TEST'
    ? 'http://localhost:3000/'
    : 'https://simulator-backend.herokuapp.com'

const DEFAULT_URL = `${HOST}api/v1`

export const frontUrl =
  mode === 'TEST'
    ? 'http://localhost:3001/'
    : 'https://simulator-frontend.herokuapp.com/'

export const plansUrl = `${DEFAULT_URL}/plans/index`
