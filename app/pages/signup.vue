<script setup lang="ts">
const user = useSupabaseUser()
const supabase = useSupabaseClient()

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const error = ref('')
const success = ref(false)
const loading = ref(false)

// Redirect if already authenticated
watchEffect(() => {
  if (user.value) {
    navigateTo('/dashboard')
  }
})

const handleSignup = async () => {
  error.value = ''
  loading.value = true

  if (password.value !== confirmPassword.value) {
    error.value = 'Passwords do not match'
    loading.value = false
    return
  }

  if (password.value.length < 6) {
    error.value = 'Password must be at least 6 characters'
    loading.value = false
    return
  }

  try {
    const { error: signUpError } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
    })

    if (signUpError) throw signUpError

    success.value = true

    // Redirect to dashboard after successful signup
    setTimeout(() => {
      navigateTo('/dashboard')
    }, 2000)
  } catch (e: any) {
    error.value = e.message || 'Failed to sign up'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="flex min-h-screen items-center justify-center bg-background">
    <div class="w-full max-w-md space-y-8 rounded-lg border border-border bg-card p-8 shadow-lg">
      <div class="text-center">
        <h1 class="text-3xl font-bold text-foreground">Create Account</h1>
        <p class="mt-2 text-muted-foreground">Sign up to get started.</p>
      </div>

      <form v-if="!success" @submit.prevent="handleSignup" class="mt-8 space-y-6">
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

          <div>
            <label for="confirm-password" class="block text-sm font-medium text-foreground">Confirm Password</label>
            <input
              id="confirm-password"
              v-model="confirmPassword"
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
          {{ loading ? 'Creating account...' : 'Sign Up' }}
        </Button>

        <div class="text-center text-sm">
          <span class="text-muted-foreground">Already have an account?</span>
          <NuxtLink to="/login" class="ml-1 font-medium text-primary hover:underline">
            Sign In
          </NuxtLink>
        </div>
      </form>

      <div v-else class="space-y-4 text-center">
        <div class="rounded-md bg-primary/10 p-4">
          <p class="text-sm text-primary">
            Account created successfully! Redirecting to dashboard...
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
