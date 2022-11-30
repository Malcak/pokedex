import type { FC } from 'react'
import Image from 'next/image'
import { Text, Link, useTheme } from '@nextui-org/react'
import NextLink from 'next/link'
import { Navbar as Nav } from '@nextui-org/react'

const Navbar: FC = () => {
  const { theme } = useTheme()

  return (
    <Nav isBordered variant="static">
      <Nav.Brand>
        <Image
          src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png"
          alt="icon"
          width={72}
          height={72}
        />
        <NextLink href="/" passHref>
          <Link>
            <Text
              weight="bold"
              style={{
                fontSize: '1.4rem',
              }}
            >
              <span
                style={{
                  fontSize: '1.6rem',
                }}
              >
                P
              </span>
              okédex
            </Text>
          </Link>
        </NextLink>
      </Nav.Brand>
      <Nav.Content hideIn="xs">
        <NextLink href="/bookmarks" passHref>
          <Nav.Link>Bookmarks</Nav.Link>
        </NextLink>
      </Nav.Content>
    </Nav>
  )
}

export default Navbar
