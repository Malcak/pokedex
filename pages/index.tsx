import type { NextPage } from 'next'
import { useTheme as useNextTheme } from 'next-themes'
import { Switch, useTheme } from '@nextui-org/react'

const Home: NextPage = () => {
  const { setTheme } = useNextTheme()
  const { isDark, type } = useTheme()

  return (
    <>
      The current theme is: {type}
      <Switch
        checked={isDark}
        onChange={(e) => setTheme(e.target.checked ? 'dark' : 'light')}
      />
    </>
  )
}

export default Home
