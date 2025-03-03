<script setup lang="ts">
import * as z from "zod";
import type {FormError, FormErrorEvent, FormSubmitEvent} from "@nuxt/ui";

const schema = z
    .object({
      email: z.string().email("Định dạng email không đúng"),
    });

type Schema = z.output<typeof schema>;

const state = reactive<Partial<Schema>>({
  email: undefined,
});

const validate = (state: any): FormError[] => {
  const errors = [];
  if (!state.email)
    errors.push({name: "email", message: "Email không được để trống"});
  if (!state.password)
    errors.push({name: "password", message: "Mật khẩu không được để trống"});

  return errors;
};

const toast = useToast();

// Show/hide password
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
      event.data.email === testAccount.email
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
    element?.scrollIntoView({behavior: "smooth", block: "center"});
  }
}
</script>

<template>
  <UContainer
      class="bg-white flex items-center justify-center min-h-screen px-4 md:px-6 lg:px-8"
  >
    <div class="w-full md:w-1/2 max-w-[392px] mx-auto md:mx-0 mt-32 md:mt-0 flex flex-col items-center">
      <img
          src="/img/key.svg"
          class="w-8 h-auto"
      />
      <div class="md:text-left mb-12">
        <h2 class="text-xl sm:text-2xl text-gray-500 font-bold leading-tight text-center">
          Khôi phục mật khẩu
        </h2>
        <p class="h-14 text-sm sm:text-base text-gray-300 font-medium leading-normal text-center">
          Nhập địa chỉ email đã đăng ký để nhận hướng dẫn đặt lại mật khẩu
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
            label="Email đăng ký"
            name="email"
            v-slot="{ error: errorEmail }"
            :ui="{ error: 'mt-2 text-red-500' }"
        >
          <UInput
              v-model="state.email"
              placeholder="Nhập địa chỉ email"
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

        <UButton
            :loading="loading"
            type="submit"
            class="bg-green-500 hover:bg-green-600 py-3 sm:py-4 px-4 sm:px-6 rounded-lg focus:outline-none focus:shadow-outline w-full h-12 sm:h-14 flex items-center justify-center hover:cursor-pointer mt-2"
        >
          <p class="text-white font-medium leading-6 text-sm sm:text-base">
            Gửi yêu cầu khôi phục
          </p>
        </UButton>
      </UForm>

      <p
          class="text-gray-300 text-sm sm:text-base font-normal mt-4 flex items-center justify-center leading-6 flex-wrap"
      >
        <ULink
            to="/login"
            class="px-1 sm:px-2 py-1 ml-1 flex gap-1"
        >
          <img
              src="/img/arrow-left.svg"
              class="w-5 h-5 sm:w-6 sm:h-6"
          />
          <p class="text-gray-500 font-medium transition-colors duration-300 hover:text-green-500">
            Quay lại trang đăng nhập
          </p>
        </ULink>
      </p>
    </div>
  </UContainer>
</template>

<style scoped lang="postcss"></style>
