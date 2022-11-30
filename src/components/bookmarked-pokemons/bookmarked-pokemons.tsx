import type { FC } from 'react'
import { Grid } from '@nextui-org/react'

import type { PokemonListItemResponse } from '@interfaces'
import PokemonCard from '@components/pokemon-card'

interface Props {
  pokemonIds: number[]
}

const BookmarkedPokemons: FC<Props> = ({ pokemonIds }) => {
  const pokemons: PokemonListItemResponse[] = pokemonIds.map((id) => ({
    name: 'placeholder',
    url: '',
    id: `${id}`,
    img: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${id}.png`,
  }))

  return (
    <Grid.Container gap={2} direction="row" justify="flex-start">
      {pokemons.map((pokemon) => (
        <PokemonCard key={pokemon.id} pokemon={pokemon} />
      ))}
    </Grid.Container>
  )
}

export default BookmarkedPokemons
