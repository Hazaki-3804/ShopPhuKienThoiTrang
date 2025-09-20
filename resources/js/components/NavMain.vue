<!-- <script setup lang="ts">
import { SidebarGroup, SidebarGroupLabel, SidebarMenu, SidebarMenuButton, SidebarMenuItem } from '@/components/ui/sidebar';
import { urlIsActive } from '@/lib/utils';
import { type NavItem } from '@/types';
import { Link, usePage } from '@inertiajs/vue3';

defineProps<{
    items: NavItem[];
}>();

const page = usePage();
</script>

<template>
    <SidebarGroup class="px-2 py-0">
        <SidebarGroupLabel>Platform</SidebarGroupLabel>
        <SidebarMenu>
            <SidebarMenuItem v-for="item in items" :key="item.title">
                <SidebarMenuButton as-child :is-active="urlIsActive(item.href, page.url)" :tooltip="item.title">
                    <Link :href="item.href">
                        <component :is="item.icon" />
                        <span>{{ item.title }}</span>
                    </Link>
                </SidebarMenuButton>
            </SidebarMenuItem>
        </SidebarMenu>
    </SidebarGroup>
</template> -->
<template>
  <ul>
    <li v-for="item in items" :key="item.title" class="mb-2">
      <div v-if="item.children">
        <button 
          @click="toggle(item.title)" 
          :class="[
            'flex items-center w-full px-3 py-2 rounded-md text-sm font-medium transition-colors',
            'group-has-data-[collapsible=icon]/sidebar-wrapper:justify-center',
            hasActiveChild(item.children) 
              ? 'bg-primary/10 text-primary border-l-2 border-primary' 
              : 'text-muted-foreground hover:text-foreground hover:bg-accent'
          ]"
        >
          <component :is="item.icon" class="w-4 h-4 mr-2 group-has-data-[collapsible=icon]/sidebar-wrapper:mr-0" />
          <span
            class="truncate transition-[width,opacity] duration-200"
            :class="[
              'group-has-data-[collapsible=icon]/sidebar-wrapper:w-0 group-has-data-[collapsible=icon]/sidebar-wrapper:opacity-0 group-has-data-[collapsible=icon]/sidebar-wrapper:sr-only'
            ]"
          >
            {{ item.title }}
          </span>
          <span class="ml-auto group-has-data-[collapsible=icon]/sidebar-wrapper:hidden">
            <component :is="open[item.title] ? ChevronUp : ChevronDown" class="w-4 h-4" />
          </span>
        </button>
        <ul v-if="open[item.title]" class="ml-6 mt-2 space-y-1 group-has-data-[collapsible=icon]/sidebar-wrapper:hidden">
          <li v-for="child in item.children" :key="child.title">
            <Link 
              :href="child.href" 
              :class="[
                'flex items-center px-3 py-2 rounded-md text-sm transition-colors',
                isActive(child.href)
                  ? 'bg-primary text-primary-foreground font-medium'
                  : 'text-muted-foreground hover:text-foreground hover:bg-accent'
              ]"
            >
              <component :is="child.icon" class="mr-2 w-4 h-4 group-has-data-[collapsible=icon]/sidebar-wrapper:mr-0" />
              <span
                class="truncate transition-[width,opacity] duration-200"
                :class="[
                  'group-has-data-[collapsible=icon]/sidebar-wrapper:w-0 group-has-data-[collapsible=icon]/sidebar-wrapper:opacity-0 group-has-data-[collapsible=icon]/sidebar-wrapper:sr-only'
                ]"
              >
                {{ child.title }}
              </span>
            </Link>
          </li>
        </ul>
      </div>
      <div v-else>
        <Link 
          :href="item.href" 
          :class="[
            'flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors',
            'group-has-data-[collapsible=icon]/sidebar-wrapper:justify-center',
            isActive(item.href)
              ? 'bg-primary text-primary-foreground'
              : 'text-muted-foreground hover:text-foreground hover:bg-accent'
          ]"
        >
          <component :is="item.icon" class="mr-2 w-4 h-4 group-has-data-[collapsible=icon]/sidebar-wrapper:mr-0" />
          <span
            class="truncate transition-[width,opacity] duration-200"
            :class="[
              'group-has-data-[collapsible=icon]/sidebar-wrapper:w-0 group-has-data-[collapsible=icon]/sidebar-wrapper:opacity-0 group-has-data-[collapsible=icon]/sidebar-wrapper:sr-only'
            ]"
          >
            {{ item.title }}
          </span>
        </Link>
      </div>
    </li>
  </ul>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Link, usePage } from '@inertiajs/vue3'
import { ChevronDown, ChevronUp } from 'lucide-vue-next'

const props = defineProps({
  items: Array
})

const page = usePage()
const open = ref({})

function toggle(title) {
  open.value[title] = !open.value[title]
}

// Function to check if a URL is active
function isActive(href) {
  if (!href || href === '#') return false
  return page.url === href || page.url.startsWith(href)
}

// Function to check if any child is active
function hasActiveChild(children) {
  if (!children) return false
  return children.some(child => isActive(child.href))
}

// Auto-open parent if any child is active
function shouldBeOpen(item) {
  if (item.children) {
    return hasActiveChild(item.children)
  }
  return false
}

// Initialize open state based on active children
props.items.forEach(item => {
  if (item.children && shouldBeOpen(item)) {
    open.value[item.title] = true
  }
})
</script>