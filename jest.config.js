const nextJest = require('next/jest')

const createJestConfig = nextJest({
  dir: './',
})

// Add any custom config to be passed to Jest
/** @type {import('jest').Config} */
const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleDirectories: ['node_modules', '<rootDir>/'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@api': '<rootDir>/src/api',
    '^@components/(.*)$': '<rootDir>/src/components/$1',
    '^@interfaces/(.*)$': '<rootDir>/src/interfaces/$1',
    '^@lib/(.*)$': '<rootDir>/src/lib/$1',
    '^@pages/(.*)$': '<rootDir>/src/pages/$1',
  },
  modulePathIgnorePatterns: ['data', 'e2e'],
}

module.exports = createJestConfig(customJestConfig)
