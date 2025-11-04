<script setup lang="ts">
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const instruments = ref<any[]>([])
const loading = ref(true)

async function getInstruments() {
  loading.value = true
  try {
    const { data } = await supabase.from('instruments').select()
    instruments.value = data ?? []
  } catch (error) {
    console.error('Error fetching instruments:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  getInstruments()
})

const handleSignOut = async () => {
  try {
    await supabase.auth.signOut()
    await navigateTo('/login')
  } catch (error) {
    console.error('Error signing out:', error)
  }
}
</script>

<template>
  <div class="min-h-screen bg-background flex flex-col">
    <header class="border-b border-border bg-card">
      <div class="container mx-auto flex items-center justify-between px-4 py-4">
        <h1 class="text-2xl font-bold text-foreground">Dashboard</h1>
        <div class="flex items-center gap-4">
          <span class="text-sm text-muted-foreground">{{ user?.email }}</span>
          <Button @click="handleSignOut" variant="outline" size="sm">
            Sign Out
          </Button>
        </div>
      </div>
    </header>

    <main class="container mx-auto px-4 py-8">
      <div class="space-y-6">
        <div>
          <h2 class="text-xl font-semibold text-foreground">Welcome!</h2>
          <p class="text-muted-foreground">You are now signed in.</p>
        </div>

        <div class="rounded-lg border border-border bg-card p-6">
          <h3 class="mb-4 text-lg font-semibold text-foreground">Instruments</h3>

          <div v-if="loading" class="text-muted-foreground">Loading instruments...</div>

          <ul v-else-if="instruments.length > 0" class="space-y-2">
            <li
              v-for="instrument in instruments"
              :key="instrument.id"
              class="rounded-md border border-border bg-background p-3 text-foreground"
            >
              {{ instrument.name }}
            </li>
          </ul>

          <div v-else class="text-muted-foreground">No instruments found.</div>
        </div>
      </div>
    </main>
  </div>
</template>
