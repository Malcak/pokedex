import type { FC } from 'react'
import Link from 'next/link'
import { Card, Grid, Row, Text } from '@nextui-org/react'

import type { PokemonListItemResponse } from '@interfaces'

interface Props {
  pokemon: PokemonListItemResponse
}

const PokemonCard: FC<Props> = ({ pokemon }) => {
  const { id, name, img } = pokemon

  return (
    <Grid xs={6} sm={3} md={2} xl={1}>
      <Link href={`/pokemon/${id}`}>
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
      </Link>
    </Grid>
  )
}

export default PokemonCard
