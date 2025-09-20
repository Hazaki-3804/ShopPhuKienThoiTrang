<script setup lang="ts">
import NavFooter from '@/components/NavFooter.vue';
import NavMain from '@/components/NavMain.vue';
import NavUser from '@/components/NavUser.vue';
import { Sidebar, SidebarContent, SidebarFooter, SidebarHeader, SidebarMenu, SidebarMenuButton, SidebarMenuItem, SidebarMenuSub, SidebarMenuSubItem } from '@/components/ui/sidebar';
import { dashboard } from '@/routes';
import { type NavItem } from '@/types';
import { Link } from '@inertiajs/vue3';
import { BookOpen, Folder, LayoutGrid, Boxes,Award,Package,ListOrderedIcon, ChartArea, ShieldCheck, Warehouse, ShoppingCart, NotebookText, Grid2x2} from 'lucide-vue-next';
import AppLogo from './AppLogo.vue';

const mainNavItems: NavItem[] = [
    {
        title: 'Dashboard',
        href: dashboard(),
        icon: LayoutGrid,
    },
    {
        title: 'Quản lý sản phẩm',
        href: '#', // Không có link chính, chỉ mở rộng menu con
        icon: Package, // Import Package từ lucide-vue-next
        children: [
            {
                title: 'Danh mục sản phẩm',
                href: '/categories', // Sử dụng route helper
                icon: Grid2x2, // Tùy chọn icon cho child
            },
            {
                title: 'Sản phẩm',
                href: '/products', // Direct URL
                icon: Boxes, // Tùy chọn icon cho child
            },
            {
                title: 'Kho hàng',
                href: '#', // Thay bằng route thực tế
                icon: Warehouse, // Tùy chọn icon cho child
            },
        ],
    },
    {
        title: 'Quản lý đơn hàng',
        href: '#', // Không có link chính, chỉ mở rộng menu con
        icon: ShoppingCart, // Import Package từ lucide-vue-next
        children: [
            {
                title: 'Danh sách đơn hàng',
                href: '#', // Thay bằng route thực tế, ví dụ route('categories.index')
                icon: NotebookText, // Tùy chọn icon cho child
            },
            {
                title: 'SP',
                href: '#', // Thay bằng route thực tế
                icon: ListOrderedIcon, // Tùy chọn icon cho child
            },
        ],
    },
    {
        title: 'Báo cáo thống kê',
        href: '#', // Không có link chính, chỉ mở rộng menu con
        icon: ChartArea, // Import Package từ lucide-vue-next
        children: [
            {
                title: 'Thống kê doanh thu',
                href: '#', // Thay bằng route thực tế, ví dụ route('categories.index')
                icon: ShieldCheck, // Tùy chọn icon cho child
            },
            {
                title: 'Thống kê sản phẩm bán chạy',
                href: '#', // Thay bằng route thực tế
                icon: Award, // Tùy chọn icon cho child
            },
            {
                title: 'Thống kê tồn kho',
                href: '#', // Thay bằng route thực tế
                icon: ListOrderedIcon, // Tùy chọn icon cho child
            },
        ],
    },
];

const footerNavItems: NavItem[] = [
    {
        title: 'Github Repo',
        href: 'https://github.com/laravel/vue-starter-kit',
        icon: Folder,
    },
    {
        title: 'Documentation',
        href: 'https://laravel.com/docs/starter-kits#vue',
        icon: BookOpen,
    },
];
</script>

<template>
    <Sidebar collapsible="icon" variant="inset">
        <SidebarHeader>
            <SidebarMenu>
                <SidebarMenuItem>
                    <SidebarMenuButton size="lg" as-child>
                        <Link :href="dashboard()">
                            <AppLogo />
                        </Link>
                    </SidebarMenuButton>
                </SidebarMenuItem>
            </SidebarMenu>
        </SidebarHeader>

        <SidebarContent class="overflow-y-auto sidebar-scroll">
            <NavMain :items="mainNavItems" />
        </SidebarContent>

        <SidebarFooter>
            <NavFooter :items="footerNavItems" />
            <NavUser />
        </SidebarFooter>
    </Sidebar>
    <slot />
</template>

<style scoped>
/* Slim, subtle scrollbar for sidebar */
.sidebar-scroll {
  scrollbar-width: thin;
  scrollbar-color: rgba(100, 116, 139, 0.35) transparent; /* thumb, track */
}

.sidebar-scroll::-webkit-scrollbar {
  width: 6px;
}

.sidebar-scroll::-webkit-scrollbar-track {
  background: transparent;
}

.sidebar-scroll::-webkit-scrollbar-thumb {
  background-color: rgba(100, 116, 139, 0.35); /* slate-500/35 */
  border-radius: 9999px;
}

.sidebar-scroll:hover::-webkit-scrollbar-thumb {
  background-color: rgba(100, 116, 139, 0.5); /* slightly darker on hover */
}

@media (prefers-color-scheme: dark) {
  .sidebar-scroll {
    scrollbar-color: rgba(148, 163, 184, 0.35) transparent; /* slate-400/35 */
  }
  .sidebar-scroll::-webkit-scrollbar-thumb {
    background-color: rgba(148, 163, 184, 0.35);
  }
  .sidebar-scroll:hover::-webkit-scrollbar-thumb {
    background-color: rgba(148, 163, 184, 0.55);
  }
}
</style>
