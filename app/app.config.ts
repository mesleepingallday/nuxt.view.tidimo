export default defineAppConfig({
  title: "Tidimo",
  theme: {
    // Theme configuration
    dark: false,
  },
  ui: {
    formField: {
      slots: {
        label: 'text-gray-500 text-[14px] font-medium leading-4 tracking-tighter',
      },
    }
  }
});
