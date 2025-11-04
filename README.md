# Nuxt + Supabase Minimal Boilerplate

A simple boilerplate for getting started with Nuxt projects that take advantage of Supabase for Auth and PostgreSQL. It is intended to get a functional prototype for an app up and running within minutes.

> [!NOTE]
> As of 11/03/2025 Nuxt has been pinned at version 4.1.3 (rather than the most recent version) due to a bug with Supabase. [Read about the issue here](https://github.com/supabase/ssr/issues/62). The error looks like this:
> 
> ```
> Uncaught (in promise) SyntaxError: The requested module '/_nuxt/@fs/Users/user/path-to-project/node_modules/cookie/dist/index.js?v=36835690' does not provide an export named 'parse' (at helpers.js?v=36835690:1:10)
> ```

## Architecture

### Tech stack:

- **Framework**: Nuxt 4 with Vue 3 (Composition API)
- **UI Components**: shadcn-nuxt (Vue port of shadcn/ui using reka-ui with [original installation instructions here](https://www.shadcn-vue.com/docs/installation/nuxt.html))
- **Styling**: Tailwind CSS v4 with `@tailwindcss/vite`, tw-animate-css
- **Database**: Supabase (PostgreSQL) with [Nuxt Supabase](https://supabase.nuxtjs.org/)
- **TypeScript**: Enabled throughout

### Directory Structure

- `app/` - Main application code (replaces traditional root-level directories)
  - `app/app.vue` - Root component
  - `app/pages/` - Nuxt routes
  - `app/composables/` - Composables
  - `app/components/ui/` - shadcn-vue UI components
  - `app/lib/utils.ts` - Utility function for `cn()` class merging
  - `app/utils/` - User-created utilities
  - `app/assets/css/` - Global styles
  - `app/plugins/` - Nuxt plugins
  - `app/types/` - Custom TypeScript types and Supabase's generated database types

## Auto-importing

Because Nuxt is set up for auto-importing of Vue and Nuxt composables as well as user-defined components, utils, and composables, we don't need to import things like the shadcn Vue components.

[Official Nuxt Auto-imports docs](https://nuxt.com/docs/4.x/guide/concepts/auto-imports)

In short:

You don't ned to import anything from:

- `/app/components/`
- `/app/composables/`
- `/app/utils/`

## `nuxt.config.ts`

There are a few special configurations for our Nuxt app.

First, we're using Nuxt Supabase. So we have that added as a module, and we're setting our Supabase URL and publishable key within the `supabase` configuration object, rather than using the standard `runtimeConfig` means of setting the variables.

❌ Don't do this

```
runtimeConfig: {
    public: {
        supabaseUrl: process.env.SUPABASE_URL,
        supabasePublishableKey: process.env.SUPABASE_PUBLISHABLE_KEY,
    },
},
```

✅ Do this instead

```
supabase: {
    url: process.env.SUPABASE_URL,
    key: process.env.SUPABASE_KEY,
},
```

We've also set our app up so that Nuxt Supabase handles logged-in state redirects. For all routes that aren't `/login` or `/confirm`, we'll redirect the user to `/login` if they're not currently logged in. This makes it so we don't manually have to check on every route at initialization.

## CLI Commands

### Set up your environment variables

Before running any of these commands, set up your `.env` file with the necessary environment variables.

```bash
cp .env.example .env
```

Then edit the environment variables in `.env`:

- `SUPABASE_PROJECT_ID`
- `SUPABASE_URL`
- `SUPABASE_KEY`

### Creating a new project

1. Initialize the app:

```bash
npm i
```

### Running the Application

1. Start the frontend development server:

```bash
npm run dev
```

2. Open your browser and navigate to `http://localhost:3000`.

### Building the Application

```bash
npm run build
```

### Check for TypeScript Errors

```bash
npm run typecheck
```

### Generate Supabase's database types

This will utilize the `SUPABASE_PROJECT_ID` environment variable.

```bash
npm run db:types
```

## Intended Deployment Infrastructure

This is ready to be deployed to a VPS (such as DigitalOcean's [Droplets](https://www.digitalocean.com/products/droplets)) using [CapRover](https://caprover.com/).

The `Dockerfile` will spin up the correct image and serve the app. Just be sure to set the exposed port within the Caprover app to `3000`.