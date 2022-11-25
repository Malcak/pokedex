import { render } from '@testing-library/react'
import BookmarksPage from '@pages/bookmarks'

describe('Bookmarks Page', () => {
  it('should display the page correctly', async () => {
    const { container } = render(<BookmarksPage />)
    expect(container).toMatchSnapshot()
  })
})
