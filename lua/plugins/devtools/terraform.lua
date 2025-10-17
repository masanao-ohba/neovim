-- ============================================================================
-- Plugin: vim-terraform
-- Repository: hashivim/vim-terraform
-- Category: Language Support / Development Tools
--
-- Purpose:
--   Terraform and HCL file support with syntax highlighting and formatting.
--   Provides essential tools for working with Infrastructure as Code.
--
-- Key Features:
--   - Syntax highlighting for .tf, .hcl files
--   - Code alignment for better readability
--   - Automatic filetype detection
--   - Format-on-save capability (disabled by default)
--
-- Configuration:
--   terraform_fmt_on_save = 0 (disabled)
--   terraform_align = 1 (enabled)
-- ============================================================================

return {
  "hashivim/vim-terraform",
  ft = { "terraform", "hcl", "tf" },
  init = function()
    vim.g.terraform_fmt_on_save = 0
    vim.g.terraform_align = 1
  end
}
