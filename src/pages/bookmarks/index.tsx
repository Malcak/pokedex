import { useEffect, useState } from 'react'

import NoBookmarks from '@components/no-bookmarks'
import BookmarkedPokemons from '@components/bookmarked-pokemons'

function BookmarksPage() {
  const [bookmarkedPokemons, setBookmarkedPokemons] = useState<number[]>([])

  useEffect(() => {
    setBookmarkedPokemons([1, 4, 7])
  }, [])

  return (
    <>
      {bookmarkedPokemons.length === 0 ? (
        <NoBookmarks />
      ) : (
        <BookmarkedPokemons pokemonIds={bookmarkedPokemons} />
      )}
    </>
  )
}

export default BookmarksPage
