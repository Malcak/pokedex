import type { GetStaticProps, NextPage } from 'next'

import pokeapi from '@api/index'
import { PokemonListItemResponse, PokemonListResponse } from 'interfaces'

interface Props {
  pokemons: PokemonListItemResponse[]
}

const Home: NextPage<Props> = ({ pokemons }) => {
  return (
    <>
      <ul>
        {pokemons.map(({ id, name }) => (
          <li key={id}>
            #{id} - {name}
          </li>
        ))}
      </ul>
    </>
  )
}

export const getStaticProps: GetStaticProps = async (context) => {
  const { data } = await pokeapi.get<PokemonListResponse>('/pokemon?limit=151')

  const pokemons: PokemonListItemResponse[] = data.results.map(
    (pokemon, index) => ({
      ...pokemon,
      id: `${index + 1}`,
      img: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/${
        index + 1
      }.svg`,
    }),
  )

  return {
    props: {
      pokemons,
    },
  }
}

export default Home
