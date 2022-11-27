import { render, screen } from '@testing-library/react'
import Component from '@components/pokemon-card'

import data from '../data.js'

const bulbasaurIndex = 0
const bulbasaur = data[bulbasaurIndex]

describe('Pokemon Card Component', () => {
  it('should display the component correctly', async () => {
    const { container } = render(<Component pokemon={bulbasaur} />)
    expect(container).toMatchSnapshot()
  })

  it('lets have sexu', async () => {
    const wrapper = render(<Component pokemon={bulbasaur} />)
    expect(
      (await wrapper.findAllByRole('img', { name: bulbasaur.name })).at(0),
    ).toHaveAttribute('src', bulbasaur.img)
    // the next one should fail
    expect(
      (await wrapper.findAllByRole('img', { name: bulbasaur.name })).at(0),
    ).toHaveAttribute('src', bulbasaur.url)
    expect(
      (await wrapper.findAllByRole('img', { name: bulbasaur.name })).at(0),
    ).toHaveAttribute('alt', bulbasaur.name)
  })
})
