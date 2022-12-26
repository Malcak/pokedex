import type { GetStaticPaths, GetStaticProps, NextPage } from 'next'
import { Badge, Button, Card, Grid, Text } from '@nextui-org/react'

import type { Pokemon } from '@api'
import pokeapi from '@api'

interface Props {
  pokemon: Pokemon
}

const PokemonPage: NextPage<Props> = ({ pokemon }) => {
  return (
    <>
      <Grid.Container css={{ marginTop: '32px' }} gap={2}>
        <Grid xs={12} sm={4} css={{ maxHeight: '296px' }}>
          <Card isHoverable css={{ padding: '16px' }}>
            <Card.Body>
              <Card.Image
                src={
                  pokemon.sprites.other?.['official-artwork'].front_default ||
                  '/no-image.png'
                }
                alt={pokemon.name}
                width="100%"
                height={200}
              />
            </Card.Body>
          </Card>
        </Grid>
        <Grid xs={12} sm={8}>
          <Card css={{ paddingInline: '20px' }}>
            <Card.Header
              css={{ display: 'flex', justifyContent: 'space-between' }}
            >
              <Text h1 transform="capitalize">
                {pokemon.name}
              </Text>
              {/* <Button color="gradient" ghost>
                Save bookmark
              </Button> */}
            </Card.Header>
            <div>
              {pokemon.types.map(({ type }) => {
                return (
                  <Badge
                    disableOutline
                    variant="flat"
                    key={type.name}
                    css={{ marginInline: 4 }}
                  >
                    {type.name}
                  </Badge>
                )
              })}
            </div>
            <Card.Body>
              <Text size={30}>Sprites</Text>
              <Text></Text>
              <Grid.Container gap={2} justify="flex-start">
                <Grid xs={6} sm={3} md={2} xl={1}>
                  <Card isHoverable variant="bordered">
                    <Card.Image
                      src={pokemon.sprites.front_default || '/no-image.png'}
                      alt={`${pokemon.name} sprite front_default`}
                    />
                  </Card>
                </Grid>
                <Grid xs={6} sm={3} md={2} xl={1}>
                  <Card isHoverable variant="bordered">
                    <Card.Image
                      src={pokemon.sprites.back_default || '/no-image.png'}
                      alt={`${pokemon.name} sprite back_default`}
                    />
                  </Card>
                </Grid>
                <Grid xs={6} sm={3} md={2} xl={1}>
                  <Card isHoverable variant="bordered">
                    <Card.Image
                      src={pokemon.sprites.front_shiny || '/no-image.png'}
                      alt={`${pokemon.name} sprite front_shiny`}
                    />
                  </Card>
                </Grid>
                <Grid xs={6} sm={3} md={2} xl={1}>
                  <Card isHoverable variant="bordered">
                    <Card.Image
                      src={pokemon.sprites.back_shiny || '/no-image.png'}
                      alt={`${pokemon.name} sprite back_shiny`}
                    />
                  </Card>
                </Grid>
              </Grid.Container>
            </Card.Body>
          </Card>
        </Grid>
      </Grid.Container>
    </>
  )
}

export const getStaticPaths: GetStaticPaths = async () => {
  const { results } = await pokeapi.listPokemons(0, 151)

  return {
    paths: results.map(({ name }, index) => ({
      params: { id: `${index + 1}` },
    })),
    fallback: false,
  }
}

export const getStaticProps: GetStaticProps = async ({ params }) => {
  const { id } = params as { id: string }
  const pokemon = await pokeapi.getPokemonById(Number(id))

  return {
    props: {
      pokemon,
    },
  }
}

export default PokemonPage
