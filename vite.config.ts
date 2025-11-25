import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: [
      { find: "@layouts", replacement: path.resolve(__dirname, "src", "layouts") },
      { find: "@pages", replacement: path.resolve(__dirname, "src", "pages") },
      { find: "@shadcn/lib", replacement: path.resolve(__dirname, "src", "shadcn", "lib") },
      { find: "@shadcn/hooks", replacement: path.resolve(__dirname, "src", "shadcn", "hooks") },
      {
        find: "@shadcn/components/ui",
        replacement: path.resolve(__dirname, "src", "shadcn", "components", "ui"),
      },
      {
        find: "@shadcn/components",
        replacement: path.resolve(__dirname, "src", "shadcn", "components", "ui"),
      },
      {
        find: "@shadcn/layout",
        replacement: path.resolve(__dirname, "src", "shadcn", "components", "ui", "layout"),
      },
      {
        find: "@shadcn/typography",
        replacement: path.resolve(__dirname, "src", "shadcn", "components", "ui", "typography"),
      },
      {
        find: "@shadcn",
        replacement: path.resolve(__dirname, "src", "shadcn", "components", "ui"),
      },
      { find: "@", replacement: path.resolve(__dirname, "src") },
    ],
  },
});
