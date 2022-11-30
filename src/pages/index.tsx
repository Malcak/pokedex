import type { GetStaticProps, NextPage } from 'next'
import { Grid } from '@nextui-org/react'

import type { PokemonListItemResponse } from '@interfaces'
import PokemonCard from '@components/pokemon-card'
import pokeapi from '@api'

interface Props {
  pokemons: PokemonListItemResponse[]
}

const Home: NextPage<Props> = ({ pokemons }) => {
  return (
    <>
      <Grid.Container gap={2} justify="flex-start">
        {pokemons.map((pokemon) => (
          <PokemonCard key={pokemon.id} pokemon={pokemon} />
        ))}
      </Grid.Container>
    </>
  )
}

export const getStaticProps: GetStaticProps = async (context) => {
  const { results } = await pokeapi.listPokemons(0, 151)

  const pokemons: PokemonListItemResponse[] = results.map((pokemon, index) => ({
    ...pokemon,
    id: `${index + 1}`,
    img: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${
      index + 1
    }.png`,
  }))

  return {
    props: {
      pokemons,
    },
  }
}

export default Home
