import type { FC } from 'react'
import { Card, Grid, Row, Text } from '@nextui-org/react'

import type { PokemonListItemResponse } from '@interfaces'

interface Props {
  pokemon: PokemonListItemResponse
}

const PokemonCard: FC<Props> = ({ pokemon }) => {
  const { id, name, img } = pokemon

  return (
    <Grid xs={6} sm={3} md={2} xl={1}>
      <Card isHoverable isPressable variant="bordered">
        <Card.Body
          css={{
            p: 1,
          }}
        >
          <Card.Image
            src={img}
            width="100%"
            height={140}
            alt={name}
            objectFit="contain"
          />
        </Card.Body>
        <Card.Footer>
          <Row wrap="wrap" justify="space-between" align="center">
            <Text b transform="capitalize">
              {name}
            </Text>
            <Text
              css={{
                color: '$accents7',
                fontWeight: '$semibold',
                fontSize: '$sm',
              }}
            >
              # {id}
            </Text>
          </Row>
        </Card.Footer>
      </Card>
    </Grid>
  )
}

export default PokemonCard
