import '../styles/globals.css'
import type { AppProps } from 'next/app'
import { ThemeProvider as NextThemesProvider } from 'next-themes'
import { NextUIProvider } from '@nextui-org/react'

import { darkTheme, lightTheme } from '../lib/theme'
import MainLayout from '../components/layouts/main'

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <NextThemesProvider
      defaultTheme="system"
      attribute="class"
      value={{
        light: lightTheme.className,
        dark: darkTheme.className,
      }}
    >
      <NextUIProvider>
        <MainLayout title="pokemon list">
          <Component {...pageProps} />
        </MainLayout>
      </NextUIProvider>
    </NextThemesProvider>
  )
}

export default MyApp
