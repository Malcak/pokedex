export interface PokemonListResponse {
  count: number
  next: string
  previous: string
  results: PokemonListItemResponse[]
}

export interface PokemonListItemResponse {
  name: string
  url: string
  id: string
  img: string
}
