# Rails Mister Cocktail

`rails-mister-cocktail-master` is a Ruby on Rails app for creating cocktails and managing their recipe doses (ingredient + quantity/description).

## Features

- List cocktails
- Create a cocktail with a name and optional photo upload
- View a cocktail recipe
- Add doses (ingredient + description) to a cocktail
- Remove existing doses
- Seed ingredients and sample cocktails from [TheCocktailDB](https://www.thecocktaildb.com/)

## Tech Stack

- Ruby `3.3.4`
- Rails `6.1.x`
- PostgreSQL
- Webpacker (Rails 6 default JS pipeline)
- Bootstrap + Simple Form
- Active Storage (`:local` in development, Cloudinary available for production)

## Prerequisites

- Ruby `3.3.4` (matching `.ruby-version`)
- Bundler
- PostgreSQL running locally
- Node.js + Yarn
- Cloudinary account credentials (optional for production uploads)

## Setup

1. Install gems:
   ```bash
   bundle install
   ```
2. Install JS packages:
   ```bash
   rm -rf node_modules
   rm -f yarn.lock
   yarn install
   ```
3. Create database:
   ```bash
   bin/rails db:create
   ```
4. Run migrations:
   ```bash
   bin/rails db:migrate
   ```
5. Seed data:
   ```bash
   bin/rails db:seed
   ```

## Environment Variables

By default, development uses local disk storage. To use Cloudinary in production, ensure credentials are available:

- `CLOUDINARY_URL` (recommended single-variable setup), or
- equivalent Cloudinary credential variables supported by the gem.
- `PGHOST` (optional, defaults to `127.0.0.1`)
- `PGPORT` (optional, defaults to `5432`)
- `PGUSER` (optional, defaults to your OS user)

For production, set:

```ruby
config.active_storage.service = :cloudinary
```

## Running the App

1. Start Rails server:
   ```bash
   bin/rails server
   ```
2. Open:
   - [http://localhost:3000](http://localhost:3000)

## Main Routes

- `GET /` -> cocktails index
- `GET /cocktails/new` -> new cocktail form
- `POST /cocktails` -> create cocktail
- `GET /cocktails/:id` -> cocktail details and dose form
- `POST /cocktails/:cocktail_id/doses` -> create dose
- `DELETE /doses/:id` -> delete dose

## Data Model

- `Cocktail`
  - `name` (unique, required)
  - has many `doses`
  - has many `ingredients` through `doses`
  - has one attached `photo`
- `Ingredient`
  - `name` (unique, required)
  - has many `doses`
- `Dose`
  - `description` (required)
  - belongs to one `cocktail`
  - belongs to one `ingredient`
  - unique per `[cocktail, ingredient]`

## Testing

Run the test suite with:

```bash
bundle exec rspec
```

If PostgreSQL is not running locally, start it first (example Homebrew service):

```bash
brew services start postgresql@14
```

The suite includes:

- Model validations and association behavior for `Cocktail`, `Ingredient`, and `Dose`
- Request specs for core flows (create cocktail, create/delete dose)
- Edge cases (invalid payloads, duplicate cocktail names, duplicate ingredient per cocktail, same ingredient across different cocktails)

## Notes

- The current codebase has a few implementation bugs and consistency issues (view logic and seed handling); see your audit/findings for details.
