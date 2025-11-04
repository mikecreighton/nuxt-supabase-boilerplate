# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an invoice management application built with Nuxt 4, Vue 3, and Supabase. The application uses shadcn-vue for UI components and Tailwind CSS v4 for styling.

## Development Commands

```bash
# Install dependencies
npm install

# Start development server (http://localhost:3000)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Generate static site
npm run generate
```

## Architecture

### Directory Structure

The project follows Nuxt 4's new app directory structure:

- `app/` - Main application code (replaces traditional root-level directories)
  - `app/app.vue` - Root component
  - `app/components/ui/` - shadcn-vue UI components
  - `app/lib/utils.ts` - Utility functions (includes `cn()` for class merging)
  - `app/assets/css/` - Global styles
  - `app/plugins/` - Nuxt plugins

### Tech Stack

- **Framework**: Nuxt 4 with Vue 3 (Composition API)
- **UI Components**: shadcn-nuxt (Vue port of shadcn/ui using reka-ui)
- **Styling**: Tailwind CSS v4 with `@tailwindcss/vite`, tw-animate-css
- **Database**: Supabase (PostgreSQL)
- **TypeScript**: Enabled throughout

### Key Configurations

**nuxt.config.ts:**
- Tailwind CSS configured via Vite plugin (v4 style)
- shadcn-nuxt module with components in `./components/ui`
- Supabase connection configured via runtime config (environment variables)

**Environment Variables:**
Required in `.env`:
- `SUPABASE_PROJECT_ID` - Supabase's project ID (for database types generation)
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_PUBLISHABLE_KEY` - Supabase anon/public key


### Styling System

This project uses Tailwind CSS v4 with a custom theme system:
- Theme tokens defined as CSS variables in `app/assets/css/tailwind.css`
- Uses OKLCH color space for better color consistency
- Component styling uses `cn()` utility (clsx + tailwind-merge) for conditional classes

### Supabase Integration

Supabase client is initialized via Nuxt Supabase. It has two composables for getting access to the Supabase client and the Supabase logged in user.

```typescript
const supabase = useSupabaseClient()
const user = useSupabaseUser()
```

Database queries follow Supabase's JavaScript client patterns. See `app/pages/dashboard.vue` for reference implementation.

### UI Components

UI components follow shadcn patterns:
- Located in `app/components/ui/[component-name]/`
- Built on reka-ui primitives
- Use class-variance-authority for variants
- Export component and variants from `index.ts`
- See `app/components/ui/button/` for reference implementation
