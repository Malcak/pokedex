import type { FC } from 'react'
import Image from 'next/future/image'
import { Spacer, Text, useTheme } from '@nextui-org/react'
import Link from 'next/link'
import { Navbar as Nav } from "@nextui-org/react";

const Navbar: FC = () => {
  const { theme } = useTheme()

  return (
    <Nav isBordered variant='static'>
        <Nav.Brand>
          {/* <AcmeLogo /> */}
          <Image
             src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png"
             alt="icon"
             width={72}
             height={72}
           />
           <Text weight="bold" style={{
             fontSize: '1.4rem'
           }}>
            <span
              style={{
                fontSize: '1.6rem',
              }}
            >
              P
            </span>
            okédex
          </Text>
        </Nav.Brand>
        <Nav.Content hideIn="xs">
          <Nav.Link href="#">bookmarks</Nav.Link>
        </Nav.Content>
      </Nav>
  )
}

export default Navbar
