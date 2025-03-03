<script setup lang="ts">
import * as z from "zod";
import type { FormError, FormErrorEvent, FormSubmitEvent } from "@nuxt/ui";

const schema = z.object({
  email: z.string().email("Định dạng email không đúng"),
  password: z.string().min(8, "Mật khẩu phải có ít nhất 8 ký tự"),
  confirmPassword: z.string(),
  isTermsAccepted: z.boolean().default(false),
});

type Schema = z.output<typeof schema>;

const state = reactive<Partial<Schema>>({
  email: undefined,
  password: undefined,
  confirmPassword: undefined,
  isTermsAccepted: false,
});

const validate = (state: any): FormError[] => {
  const errors = [];
  if (!state.email)
    errors.push({ name: "email", message: "Email không được để trống" });
  if (!state.password) {
    errors.push({ name: "password", message: "Mật khẩu không được để trống" });
  } else {
    const passwordRequirements = checkStrength(state.password);
    const allRequirementsMet = passwordRequirements.every((req) => req.met);

    if (!allRequirementsMet) {
      errors.push({
        name: "password",
        message: "Mật khẩu không đáp ứng yêu cầu về độ mạnh",
      });
    }
  }
  if (!state.confirmPassword)
    errors.push({
      name: "confirmPassword",
      message: "Vui lòng xác nhận mật khẩu",
    });
  else if (state.password !== state.confirmPassword)
    errors.push({
      name: "confirmPassword",
      message: "Mật khẩu xác nhận không khớp",
    });

  if (!state.isTermsAccepted) {
    errors.push({
      name: "isTermsAccepted",
      message: "Bạn phải đồng ý với các điều khoản để tiếp tục",
    });
  }
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

// Check new password strength
function checkStrength(str: string) {
  const requirements = [
    { regex: /.{8,}/, text: "Ít nhất có 8 kí tự" },
    { regex: /[^A-Za-z0-9]/, text: "Ít nhất có 1 kí tự đặc biệt" },
  ];

  return requirements.map((req) => ({
    met: req.regex.test(str),
    text: req.text,
  }));
}
const strength = computed(() => checkStrength(state.password || ""));
const score = computed(
  () => strength.value.filter((req: any) => req.met).length
);

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
      <div class="text-center md:text-left mb-12">
        <h2
          class="text-xl sm:text-2xl text-gray-500 font-bold leading-tight text-center"
        >
          Tạo tài khoản
        </h2>
        <p class="text-sm sm:text-md text-gray-300 font-medium leading-normal">
          Chào bạn! Hãy đăng ký để vào TIDIMO nhé
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
          :aria-invalid="score < 2"
          aria-describedby="password-strength"
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

        <ul class="space-y-1" aria-label="Password requirements">
          <li
            v-for="(req, index) in strength"
            :key="index"
            class="flex items-center gap-1"
            :class="req.met ? 'text-(--ui-success)' : 'text-(--ui-text-muted)'"
          >
            <UIcon
              :name="req.met ? 'i-lucide-circle-check' : 'i-lucide-circle-x'"
              class="size-4 shrink-0"
            />

            <span class="text-xs font-light">
              {{ req.text }}
              <span class="sr-only">
                {{ req.met ? " - Requirement met" : " - Requirement not met" }}
              </span>
            </span>
          </li>
        </ul>

        <UFormField
          label="Nhập lại mật khẩu"
          name="confirmPassword"
          v-slot="{ error: errorConfirmPassword }"
          :ui="{ error: 'mt-2 text-red-500' }"
        >
          <UInput
            v-model="state.confirmPassword"
            placeholder="●●●●●●"
            variant="none"
            :type="show ? 'text' : 'password'"
            :ui="{
              root: [
                'h-12 sm:h-14 w-full p-3 sm:p-3.5 rounded-lg bg-gray-50 has-focus:border-b has-focus:border-b-gray-500 hover:bg-gray-70',
                errorConfirmPassword && 'border-b border-red-500 bg-gray-70',
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

        <UFormField
          name="isTermsAccepted"
          v-slot="{ error: errorisTermsAccepted }"
          :ui="{ error: 'mt-2 text-red-500' }"
        >
          <UCheckbox
            v-model="state.isTermsAccepted"
            label="Tôi đã đọc các điều khoản và quyền riêng tư"
            @update:model-value="!state.isTermsAccepted"
            class="flex gap-1 items-center"
            :ui="{
              base:
                'shrink-0 flex items-center justify-center rounded-(--ui-radius) text-(--ui-bg) ring ring-inset ring-(--ui-border-accented) focus-visible:outline-2 focus-visible:outline-offset-2' +
                (errorisTermsAccepted && !state.isTermsAccepted
                  ? ' ring-2 ring-red-500'
                  : ''),
              label: 'text-gray-500 text-sm sm:text-base leading-4',
            }"
          />
        </UFormField>

        <UButton
          :loading="loading"
          type="submit"
          class="bg-green-500 hover:bg-green-600 py-3 sm:py-4 px-4 sm:px-6 rounded-lg focus:outline-none focus:shadow-outline w-full h-12 sm:h-14 flex items-center justify-center hover:cursor-pointer mt-2"
        >
          <p class="text-white font-medium leading-6 text-sm sm:text-base">
            Đăng ký
          </p>
        </UButton>
      </UForm>

      <p
        class="text-gray-300 text-sm sm:text-base font-normal mt-4 flex items-center justify-center leading-6 flex-wrap"
      >
        <ULink to="/login" class="px-1 sm:px-2 py-1 ml-1 flex gap-1">
          <img
            alt="icon-arrow-left"
            src="/img/arrow-left.svg"
            class="w-5 h-5 sm:w-6 sm:h-6"
          />
          <p
            class="text-gray-500 font-medium transition-colors duration-300 hover:text-green-500"
          >
            Quay lại trang đăng nhập
          </p>
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
