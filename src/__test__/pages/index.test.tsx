import { render } from '@testing-library/react'
import Home from '@pages/index'

import pokemons from '../data.js'

describe('Home Page', () => {
  it('should display the page correctly', async () => {
    const { container } = render(<Home pokemons={pokemons} />)
    expect(container).toMatchSnapshot()
  })

  it('should display each pokemon correctly', async () => {
    const wrapper = render(<Home pokemons={pokemons} />)
    expect(await wrapper.findByText('bulbasaur')).toBeInTheDocument()
    expect(await wrapper.findByText('charmander')).toBeInTheDocument()
    expect(await wrapper.findByText('squirtle')).toBeInTheDocument()
  })
})
