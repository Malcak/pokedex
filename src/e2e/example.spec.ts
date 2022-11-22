import { test, expect } from '@playwright/test'

test('pokemon list page has title and links to each pokemon page', async ({ page }) => {
  await page.goto('http://localhost:3000')

  await expect(page).toHaveTitle(/pokemon/)

  const bulbasaurCard = page.getByRole('button').getByText('Bulbasaur')
  await bulbasaurCard.click()
  await expect(page).toHaveURL(/.pokemon\/*1/)

  const pokemonPageHeader = page.getByRole("heading")
  await expect(pokemonPageHeader).toHaveText('bulbasaur')
})

test('pokemon list has title and links to bookmarks page', async ({page}) => {
  await page.goto('http://localhost:3000')

  await expect(page).toHaveTitle(/pokemon/)

  const bookmarks = page.getByRole('link', { name: 'Bookmarks' })
  await bookmarks.click()
  await expect(page).toHaveURL(/.*bookmarks/)
})
