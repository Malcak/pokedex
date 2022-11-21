import { render, screen } from '@testing-library/react'
import Home from '@pages/index'

import pokemons from './data.js'

describe('Home', () => {
  it('should display pokemons information correctly', async () => {
    const { container } = render(<Home pokemons={pokemons} />)
    expect(container).toMatchSnapshot()
  })

  it('should display each pokemon correctly', async () => {
    const wrapper = render(<Home pokemons={pokemons} />)
    expect(await wrapper.findByText('bulbasaur')).toBeInTheDocument()
  })
})