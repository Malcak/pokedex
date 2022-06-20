import axios from 'axios'

const pokeapi = axios.create({
  baseURL: 'https://pokeapi.co/api/v2',
})

export default pokeapi
