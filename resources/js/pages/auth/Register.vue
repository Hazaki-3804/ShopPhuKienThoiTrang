<script setup lang="ts">
import RegisteredUserController from '@/actions/App/Http/Controllers/Auth/RegisteredUserController';
import InputError from '@/components/InputError.vue';
import InputErrorTooltip from '@/components/InputErrorTooltip.vue';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import TextArea from '@/components/ui/textarea/TextArea.vue';
import AuthBase from '@/layouts/AuthLayout.vue';
import { login } from '@/routes';
import { Form, Head } from '@inertiajs/vue3';
import { LoaderCircle } from 'lucide-vue-next';
</script>

<template>
    <AuthBase title="Đăng ký" description="Vui lòng điền thông tin để tạo tài khoản" size="lg">
        <Head title="Đăng ký" />

        <!-- <Form
            v-bind="RegisteredUserController.store.form()"
            :reset-on-success="['password', 'password_confirmation']"
            v-slot="{ errors, processing }"
            class="flex flex-col gap-6"
        >
            <div class="grid gap-6">
                <div class="grid gap-2">
                    <Label for="username">Tên đăng nhập</Label>
                    <Input id="username" type="text" required autofocus :tabindex="1" autocomplete="username" name="username" />
                    <InputError :message="errors.username" />
                </div>

                <div class="grid gap-2">
                    <Label for="name">Họ và tên</Label>
                    <Input id="name" type="text" required :tabindex="1" autocomplete="name" name="name" />
                    <InputError :message="errors.name" />
                </div>

                <div class="grid gap-2">
                    <Label for="email">Email</Label>
                    <Input id="email" type="email" required :tabindex="2" autocomplete="email" name="email"/>
                    <InputError :message="errors.email" />
                </div>
                <div class="grid gap-2">
                    <Label for="phone">Số điện thoại</Label>
                    <Input id="phone" type="number" required :tabindex="3" autocomplete="tel" name="phone"/>
                    <InputError :message="errors.phone" />
                </div>
                <div class="grid gap-2">
                    <Label for="address">Địa chỉ</Label>
                    <Input id="address" type="text" required :tabindex="4" autocomplete="address-line1" name="address"/>
                    <InputError :message="errors.address" />
                </div>
                <div class="grid gap-2">
                    <Label for="password">Mật khẩu</Label>
                    <Input id="password" type="password" required :tabindex="3" autocomplete="new-password" name="password"/>
                    <InputError :message="errors.password" />
                </div>

                <div class="grid gap-2">
                    <Label for="password_confirmation">Xác nhận mật khẩu</Label>
                    <Input
                        id="password_confirmation"
                        type="password"
                        required
                        :tabindex="4"
                        autocomplete="new-password"
                        name="password_confirmation"
                    />
                    <InputError :message="errors.password_confirmation" />
                </div>

                <Button type="submit" class="mt-2 w-full" tabindex="5" :disabled="processing">
                    <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                    Đăng ký
                </Button>
            </div>

            <div class="text-center text-sm text-muted-foreground">
                Bạn đã có tài khoản?
                <TextLink :href="login()" class="underline-offset-4" :tabindex="6">Đăng nhập</TextLink>
            </div>
        </Form> -->
    <Form
    v-bind="RegisteredUserController.store.form()"
    :reset-on-success="['password', 'password_confirmation']"
    v-slot="{ errors, processing }"
    class="flex flex-col gap-6 w-full"
>
    <!-- Form inputs chia 2 cột -->
    <div class="grid grid-cols-2 gap-6">
        <div class="grid gap-2">
            <div class="flex items-center"> 
                <Label for="username">Tên đăng nhập</Label>
                <InputErrorTooltip :message="errors.username" />
            </div>
            <Input id="username" type="text" autofocus :tabindex="1" autocomplete="username" name="username" />
        </div>

        <div class="grid gap-2">
            <div class="flex items-center">     
                <Label for="name">Họ và tên</Label>
                <InputErrorTooltip :message="errors.name" />
            </div>
            <Input id="name" type="text"  :tabindex="1" autocomplete="name" name="name" />
        </div>

        <div class="grid gap-2">
            <div class="flex items-center">    
                <Label for="email">Email</Label>      
                <InputErrorTooltip :message="errors.email" />
            </div>
            <Input id="email" type="text"  :tabindex="2" autocomplete="email" name="email"/>
        </div>

        <div class="grid gap-2">
            <div class="flex items-center">       
                <Label for="phone">Số điện thoại</Label>
                <InputErrorTooltip :message="errors.phone" />
            </div>
            <Input id="phone" type="number"  :tabindex="3" autocomplete="tel" name="phone"/>
        </div>

        <div class="grid gap-2 col-span-2">
            <div class="flex items-center">
                <Label for="address">Địa chỉ</Label>       
                <InputErrorTooltip :message="errors.address" />
            </div>
            <TextArea id="address" type="text"  :tabindex="4" autocomplete="address-line1" name="address"/>
        </div>

        <div class="grid gap-2"> 
            <div class="flex items-center">
                <Label for="password">Mật khẩu</Label>
                <InputErrorTooltip :message="errors.password" />
            </div>
            <Input id="password" type="password"  :tabindex="3" autocomplete="new-password" name="password"/>
        </div>

        <div class="grid gap-2">
            <div class="flex items-center">
                <Label for="password_confirmation">Xác nhận mật khẩu</Label>
                <InputErrorTooltip :message="errors.password_confirmation" />
            </div>
            <Input
                id="password_confirmation"
                type="password"
                :tabindex="4"
                autocomplete="new-password"
                name="password_confirmation"
            />
        </div>

        <!-- Button chiếm full 2 cột -->
        <div class="col-span-2">
            <Button type="submit" class="mt-2 w-full" tabindex="5" :disabled="processing">
                <LoaderCircle v-if="processing" class="h-4 w-4 animate-spin" />
                Đăng ký
            </Button>
        </div>
    </div>

    <!-- Link đăng nhập chiếm 2 cột, căn giữa -->
    <div class="text-center text-sm text-muted-foreground col-span-2">
        Bạn đã có tài khoản?
        <TextLink :href="login()" class="underline-offset-4" :tabindex="6">Đăng nhập</TextLink>
    </div>
</Form>

    </AuthBase>
</template>
