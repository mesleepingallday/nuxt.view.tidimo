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
  setTimeout(() => {
    loading.value = false;
  }, 2000);
  if (
    event.data.email !== testAccount.email &&
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
  <UContainer
    class="bg-white flex items-center justify-center min-h-screen px-4 md:px-6 lg:px-8"
  >
    <!-- Mobile Image (Top) - Only visible on small screens -->
    <div class="absolute top-8 md:hidden">
      <img
        alt="a cute character of tidimo"
        src="/img/auth-tree-object.svg"
        class="w-[150px] h-auto"
      />
    </div>

    <div class="w-full md:w-1/2 max-w-[392px] mx-auto md:mx-0 mt-32 md:mt-0">
      <div class="text-center md:text-left mb-6">
        <h2 class="text-xl sm:text-2xl text-gray-500 font-bold leading-tight">
          Đăng nhập tài khoản
        </h2>
        <p class="text-sm sm:text-md text-gray-300 font-medium leading-normal">
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
                'h-12 sm:h-14 w-full p-3 sm:p-3.5 rounded-lg bg-gray-50 has-focus:border-b has-focus:border-b-gray-500 hover:bg-gray-70',
                errorEmail && 'border-b border-red-500 bg-gray-70',
              ],
              base: [
                'w-full outline-none border-0 placeholder:text-gray-100 text-sm sm:text-base placeholder:text-sm sm:placeholder:text-base bg-transparent disabled:cursor-not-allowed disabled:opacity-75',
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
                'h-12 sm:h-14 w-full p-3 sm:p-3.5 rounded-lg bg-gray-50 has-focus:border-b has-focus:border-b-gray-500 hover:bg-gray-70',
                errorPassword && 'border-b border-red-500 bg-gray-70',
              ],
              base: [
                'w-full border-0 text-sm sm:text-base placeholder:text-gray-100 placeholder:text-sm sm:placeholder:text-base bg-transparent disabled:cursor-not-allowed disabled:opacity-75',
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
                  class="w-5 h-5 sm:w-6 sm:h-6"
                />
                <img
                  v-else
                  src="/img/eye.svg"
                  alt="Show password"
                  class="w-5 h-5 sm:w-6 sm:h-6"
                />
              </button>
            </template>
          </UInput>
        </UFormField>

        <div class="flex justify-between items-center">
          <UCheckbox
            v-model="state.rememberMe"
            name="rememberMe"
            label="Ghi nhớ mật khẩu"
            @update:model-value="!state.rememberMe"
            class="flex gap-1 items-center"
            :ui="{
              label: 'text-gray-500 text-xs sm:text-sm leading-4',
            }"
          />

          <ULink
            to="/forgot-password"
            class="px-1 sm:px-2 py-1 text-gray-500 text-xs sm:text-sm leading-4 transition-colors duration-300 hover:text-green-500"
          >
            Quên mật khẩu?
          </ULink>
        </div>

        <UButton
          :loading="loading"
          type="submit"
          class="bg-green-500 hover:bg-green-600 py-3 sm:py-4 px-4 sm:px-6 rounded-lg focus:outline-none focus:shadow-outline w-full h-12 sm:h-14 flex items-center justify-center hover:cursor-pointer mt-2"
        >
          <p class="text-white font-medium leading-6 text-sm sm:text-base">
            Đăng nhập
          </p>
        </UButton>
      </UForm>

      <p
        class="text-gray-300 text-sm sm:text-base font-normal mt-4 flex items-center justify-center leading-6 flex-wrap"
      >
        Bạn chưa có tài khoản?
        <ULink
          to="/sign-up"
          class="text-gray-500 px-1 sm:px-2 py-1 font-medium transition-colors duration-300 hover:text-green-500 ml-1"
        >
          Đăng ký ngay
        </ULink>
      </p>
    </div>
    <div
      class="w-full md:w-1/2 hidden md:flex items-center justify-center p-4 lg:p-8"
    >
      <img
        alt="a cute character of tidimo"
        src="/img/auth-tree-object.svg"
        class="w-full max-w-[300px] lg:max-w-[400px] h-auto"
      />
    </div>
  </UContainer>
</template>

<style scoped lang="postcss"></style>
