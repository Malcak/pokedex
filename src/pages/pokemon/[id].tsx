import type { GetStaticPaths, GetStaticProps, NextPage } from 'next'
import { useRouter } from 'next/router'

import type { PokemonListResponse } from '@interfaces'
import pokeapi from '@api'

interface Props {
  pokemon: any
}

const PokemonPage: NextPage<Props> = ({ pokemon }) => {
  console.log(pokemon)

  return (
    <>
      <h1>

      </h1>
    </>
  )
}

export const getStaticPaths: GetStaticPaths = async () => {
  const { data } = await pokeapi.get<PokemonListResponse>('/pokemon?limit=151')

  return {
    paths: data.results.map(({ id, name }) => ({ params: { id, name } })),
    fallback: false,
  }
}

/* export const getStaticProps: GetStaticProps = async ({params}) => {
  const { data } = await pokeapi.get(`/pokemon/${params?.id}`)

  return {
    props: {
      pokemon: 
    },
  }
} */

export default PokemonPage
