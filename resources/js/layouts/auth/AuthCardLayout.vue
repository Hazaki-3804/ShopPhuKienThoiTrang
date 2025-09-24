<script setup lang="ts">
import AppLogoIcon from '@/components/AppLogoIcon.vue';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { home } from '@/routes';
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props=defineProps<{
    title?: string;
    description?: string;
    size?: 'md' | 'lg' | 'wide';
}>();
const formSize = computed(() => {
  switch (props.size) {
    case 'lg': return 'max-w-2xl'
    case 'wide': return 'max-w-4xl'
    default: return 'max-w-md'
  }
})
</script>

<template>
    <div class="flex min-h-svh flex-col items-center justify-center gap-6 bg-muted p-6 md:p-10">
        <div :class="['flex w-full flex-col gap-6', formSize]">
            <div class="flex flex-col">
                <Card class="rounded-xl">
                    <Link :href="home()" class="flex items-center self-center font-medium">
                        <div class="flex h-9 w-9 items-center justify-center">
                            <AppLogoIcon class="size-9 fill-current text-black dark:text-white" />
                        </div>
                    </Link>
                    <CardHeader class="px-10 pb-0 text-center">
                        <CardTitle class="text-xl">{{ title }}</CardTitle>
                        <CardDescription>
                            {{ description }}
                        </CardDescription>
                    </CardHeader>
                    <CardContent class="px-10 py-4">
                        <slot />
                    </CardContent>
                </Card>
            </div>
        </div>
    </div>
</template>
