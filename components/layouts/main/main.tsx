import type { FC, ReactNode } from 'react'
import Head from 'next/head'

import Navbar from '@components/navbar'

type Props = {
  children?: ReactNode
  title?: string
}

const MainLayout: FC<Props> = ({ children, title }) => {
  return (
    <>
      <Head>
        <title>{title ?? 'Pokedex'}</title>
        <meta name="author" content="Malcak" />
        <meta name="description" content={`information about ${title}`} />
        <meta name="keywords" content={`${title}, pokemon, pokedex`} />
      </Head>
      <Navbar />
      <main>{children}</main>
    </>
  )
}

export default MainLayout
