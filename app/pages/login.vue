<script setup lang="ts">
import * as z from "zod";
import type { FormError, FormErrorEvent, FormSubmitEvent } from "@nuxt/ui";

const schema = z.object({
  email: z.string().email("Định dạng email không đúng"),
  password: z.string().min(8, "Mật khẩu phải có ít nhất 8 ký tự"),
  rememberMe: z.boolean().default(false),
});

type Schema = z.output<typeof schema>;

const state = reactive<Partial<Schema>>({
  email: undefined,
  password: undefined,
  rememberMe: undefined,
});

const validate = (state: any): FormError[] => {
  const errors = [];
  if (!state.email)
    errors.push({ name: "email", message: "Email không được để trống" });
  if (!state.password)
    errors.push({ name: "password", message: "Mật khẩu không được để trống" });

  return errors;
};

const toast = useToast();

// Show/hide password
const show = ref(false);
const password = ref("");
const loading = ref(false);

const testAccount = {
  email: "test@gmail.com",
  password: "12345678",
};

async function onSubmit(event: FormSubmitEvent<Schema>) {
  loading.value = true;
  setTimeout()
  if (
    event.data.email !== testAccount.email ||
    event.data.password !== testAccount.password
  ) {
    toast.add({
      title: "Đăng nhập thất bại",
      description: "Email hoặc mật khẩu không đúng.",
      color: "warning",
      duration: 2500,
    });
    return;
  }

  toast.add({
    title: "Đăng nhập thành công",
    description: "Chào mừng bạn trở lại TIDIMO!",
    color: "success",
    duration: 2500,
  });
  console.log(event.data.email);
}

async function onError(event: FormErrorEvent) {
  if (event?.errors?.[0]?.id) {
    const element = document.getElementById(event.errors[0].id);
    element?.focus();
    element?.scrollIntoView({ behavior: "smooth", block: "center" });
  }
}
</script>

<template>
  <UContainer class="bg-white flex items-center justify-center min-h-screen">
    <div class="w-full md:w-1/2 max-w-[392px]">
      <div class="text-center mb-12">
        <h2 class="text-2xl text-gray-500 font-bold leading-10">
          Đăng nhập tài khoản
        </h2>
        <p class="text-gray-300 text-md font-medium leading-6">
          Chào bạn! Hãy đăng nhập để vào TIDIMO nhé
        </p>
      </div>

      <UForm
        :validate="validate"
        validate-on="change"
        :schema="schema"
        :state="state"
        class="space-y-4 w-full"
        @submit="onSubmit"
        @error="onError"
      >
        <UFormField
          label="Email"
          name="email"
          v-slot="{ error: errorEmail }"
          :ui="{ error: 'mt-2 text-red-500' }"
        >
          <UInput
            v-model="state.email"
            placeholder="Vui lòng nhập địa chỉ email"
            variant="none"
            :ui="{
              root: [
                'h-14 w-full p-3.5 rounded-lg bg-gray-50 has-focus:border-b has-focus:border-b-gray-500 hover:bg-gray-70',
                errorEmail && 'border-b border-red-500 bg-gray-70',
              ],
              base: [
                'w-full outline-none border-0 placeholder:text-gray-100 placeholder:text-base bg-transparent disabled:cursor-not-allowed disabled:opacity-75',
              ],
            }"
          />
        </UFormField>

        <UFormField
          label="Mật khẩu"
          name="password"
          v-slot="{ error: errorPassword }"
          :ui="{ error: 'mt-2 text-red-500' }"
        >
          <UInput
            v-model="state.password"
            placeholder="●●●●●●"
            variant="none"
            :type="show ? 'text' : 'password'"
            :ui="{
              root: [
                'h-14 w-full p-3.5 rounded-lg bg-gray-50 has-focus:border-b has-focus:border-b-gray-500 hover:bg-gray-70',
                errorPassword && 'border-b border-red-500 bg-gray-70',
              ],
              base: [
                'w-full border-0 placeholder:text-gray-100 placeholder:text-base bg-transparent disabled:cursor-not-allowed disabled:opacity-75',
              ],
            }"
          >
            <template #trailing>
              <button
                type="button"
                class="p-1 focus:outline-none"
                :aria-label="show ? 'Hide password' : 'Show password'"
                :aria-pressed="show"
                aria-controls="password"
                @click="show = !show"
              >
                <img
                  v-if="show"
                  src="/img/eye-off.svg"
                  alt="Hide password"
                  class="w-6 h-6"
                />
                <img
                  v-else
                  src="/img/eye.svg"
                  alt="Show password"
                  class="w-6 h-6"
                />
              </button>
            </template>
          </UInput>
        </UFormField>

        <div class="flex justify-between">
          <UCheckbox
            v-model="state.rememberMe"
            name="rememberMe"
            label="Ghi nhớ mật khẩu"
            @update:model-value="!state.rememberMe"
            class="flex gap-1 items-center"
            :ui="{
              label: 'text-gray-500 text-sm leading-4',
            }"
          />

          <ULink
            to="/forgot-password"
            class="px-2 py-1 text-gray-500 text-sm leading-4 transition-colors duration-300 hover:text-green-500"
          >
            Quên mật khẩu?
          </ULink>
        </div>

        <UButton
          type="submit"
          class="bg-green-500 hover:bg-green-600 py-4 px-6 rounded-lg focus:outline-none focus:shadow-outline w-full h-14 flex items-center justify-center hover:cursor-pointer"
        >
          <p class="text-white font-medium leading-6 text-base">Đăng nhập</p>
        </UButton>
      </UForm>

      <p
        class="text-gray-300 text-base font-normal mt-3 flex items-center justify-center leading-6"
      >
        Bạn chưa có tài khoản?
        <ULink
          to="/register"
          class="text-gray-500 px-2 py-1 font-medium transition-colors duration-300 hover:text-green-500"
        >
          Đăng ký ngay
        </ULink>
      </p>
    </div>
    <div class="w-full md:w-1/2 flex items-center justify-center p-8">
      <img
        alt="a cute character of tidimo"
        height="400"
        src="/img/auth-tree-object.svg"
        width="400"
      />
    </div>
  </UContainer>
</template>

<style scoped lang="postcss"></style>
