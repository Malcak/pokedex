import { PokemonClient } from "pokenode-ts";

const ONE_DAY_IN_MS = 86400000

const pokeapi = new PokemonClient({
  cacheOptions: { maxAge: ONE_DAY_IN_MS, exclude: { query: false } },
});

export default pokeapi