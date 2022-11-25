import { render, screen } from '@testing-library/react'
import Component from '@components/bookmarked-pokemons'

describe('Bookmarked Pokemons Component', () => {
  it('should display the component correctly', async () => {
    const { container } = render(<Component pokemonIds={[1, 4, 7]} />)
    expect(container).toMatchSnapshot()
  })
})
