import type { FC } from 'react'
import Image from 'next/image'
import { Spacer, Text, useTheme } from '@nextui-org/react'

const Navbar: FC = () => {
  const { theme } = useTheme()

  return (
    <div
      style={{
        display: 'flex',
        width: '100%',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'start',
        padding: '0 20px',
        backgroundColor: theme?.colors.gray50.value,
      }}
    >
      <Image
        src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png"
        alt="icon"
        width={70}
        height={70}
      />
      <Text weight="bold" h2>
        <span
          style={{
            fontSize: '2.5rem',
          }}
        >
          P
        </span>
        okémon
      </Text>
      <Spacer
        css={{
          flex: '1',
        }}
      />
      <Text>Favoritos</Text>
    </div>
  )
}

export default Navbar
