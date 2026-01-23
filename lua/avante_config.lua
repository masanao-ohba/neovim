require('avante').setup({
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "copilot",
  providers = {
    copilot = {
      model = "claude-opus-4.5"
    },
  },
})
