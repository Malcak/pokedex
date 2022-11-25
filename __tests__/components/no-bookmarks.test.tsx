import { render, screen } from '@testing-library/react'
import Component from '@components/no-bookmarks'

describe('No Bookmarks Component', () => {
  it('should display the component correctly', async () => {
    const { container } = render(<Component />)
    expect(container).toMatchSnapshot()
  })
})
