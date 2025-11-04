<script setup lang="ts">
const user = useSupabaseUser()
const supabase = useSupabaseClient()

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

// Redirect if already authenticated
watchEffect(() => {
  if (user.value) {
    navigateTo('/dashboard')
  }
})

const handleLogin = async () => {
  error.value = ''
  loading.value = true

  try {
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })

    if (signInError) throw signInError

    await navigateTo('/dashboard')
  } catch (e: any) {
    error.value = e.message || 'Failed to sign in'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-background">
    <div class="w-full max-w-md space-y-8 rounded-lg border border-border bg-card p-8 shadow-lg">
      <div class="text-center">
        <h1 class="text-3xl font-bold text-foreground">Sign In</h1>
        <p class="mt-2 text-muted-foreground">Welcome back! Please sign in to continue.</p>
      </div>

      <form @submit.prevent="handleLogin" class="mt-8 space-y-6">
        <div class="space-y-4">
          <div>
            <label for="email" class="block text-sm font-medium text-foreground">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              required
              class="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-foreground placeholder-muted-foreground focus:border-ring focus:outline-none focus:ring-2 focus:ring-ring"
              placeholder="you@example.com"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-foreground">Password</label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              class="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-foreground placeholder-muted-foreground focus:border-ring focus:outline-none focus:ring-2 focus:ring-ring"
            />
          </div>
        </div>

        <div v-if="error" class="rounded-md bg-destructive/10 p-3 text-sm text-destructive">
          {{ error }}
        </div>

        <Button
          type="submit"
          :disabled="loading"
          class="w-full"
        >
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </Button>

        <div class="text-center text-sm">
          <span class="text-muted-foreground">Don't have an account?</span>
          <NuxtLink to="/signup" class="ml-1 font-medium text-primary hover:underline">
            Sign Up
          </NuxtLink>
        </div>
      </form>
    </div>
  </div>
</template>
