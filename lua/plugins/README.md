# Neovim Plugins

Comprehensive list of installed plugins organized by category.

## Table of Contents

- [AI Integrations](#ai-integrations)
- [Custom Commands](#custom-commands)
- [Code Completion](#code-completion)
- [Development Tools](#development-tools)
- [File Management](#file-management)
- [Visual Enhancements](#visual-enhancements)

---

## AI Integrations

### avante.nvim
**Repository**: `yetone/avante.nvim`
**Category**: AI Assistance
**Purpose**: AI-powered code editing and chat interface with Claude/GPT integration
**Key Features**:
- Interactive AI chat with code context
- Direct code editing through AI suggestions
- MCP (Model Context Protocol) integration
- Customizable AI providers (Copilot with Claude/GPT models)
- Window-based interface with sidebar
- Integration with fzf-lua for selections

### CopilotChat.nvim
**Repository**: `CopilotC-Nvim/CopilotChat.nvim`
**Category**: AI Assistance
**Purpose**: GitHub Copilot chat interface for conversational AI assistance
**Key Features**:
- Interactive chat with GitHub Copilot
- Model selection (Claude Sonnet 4, GPT-4.1)
- Context-aware code suggestions
- Debug mode for troubleshooting

### copilot.lua
**Repository**: `zbirenbaum/copilot.lua`
**Category**: AI Assistance
**Purpose**: GitHub Copilot integration for inline code suggestions
**Key Features**:
- Auto-triggered inline suggestions
- Configurable keybindings for accepting suggestions
- Filetype-specific filtering
- Cycle through multiple suggestions
- Integration with completion engines

### copilot-cmp
**Repository**: `zbirenbaum/copilot-cmp`
**Category**: AI Assistance
**Purpose**: GitHub Copilot source for nvim-cmp completion engine
**Key Features**:
- Seamless Copilot integration with nvim-cmp
- Unified completion interface

### claude-code.nvim (greggh)
**Repository**: `greggh/claude-code.nvim`
**Category**: AI Assistance
**Purpose**: Claude Code CLI integration with terminal interface
**Key Features**:
- Integrated terminal for Claude Code
- Git project root detection
- File change monitoring and auto-refresh
- Customizable window positioning
- Conversation management (continue/resume)
- Terminal navigation keybindings

### claudecode.nvim (coder)
**Repository**: `coder/claudecode.nvim`
**Category**: AI Assistance
**Purpose**: Alternative Claude Code integration with WebSocket server
**Key Features**:
- WebSocket server for Claude communication
- Selection tracking and context updates
- Diff provider for code changes
- Terminal integration with configurable providers
- Auto-start capability
- Visual selection context preservation

### mcphub.nvim
**Repository**: `ravitemer/mcphub.nvim`
**Category**: AI Assistance
**Purpose**: MCP Hub integration for connecting multiple AI services
**Key Features**:
- Model Context Protocol server integration
- System prompt generation from active servers
- Extension support for Avante

---

## Custom Commands

### GitHub Copilot Account Switch
**Directory**: Local plugin
**Category**: Utility
**Purpose**: Switch between multiple GitHub Copilot accounts
**Key Features**:
- Fuzzy search through available accounts
- Configuration file management (~/.config/github-copilot/)
- Quick account switching with visual feedback

### Markdown Converter
**Directory**: Local plugin
**Category**: Text Processing
**Purpose**: Convert between Markdown and Backlog wiki syntax
**Key Features**:
- Bidirectional conversion (Markdown ↔ Backlog)
- Preserves code blocks and formatting
- Handles nested lists and headers
- Interactive conversion with fzf-lua

---

## Code Completion

### nvim-cmp
**Repository**: `hrsh7th/nvim-cmp`
**Category**: Completion Engine
**Purpose**: Extensible completion engine for Neovim
**Key Features**:
- Multiple completion sources (LSP, Copilot, buffer, path)
- Snippet expansion support (LuaSnip)
- Customizable completion menu
- Smart sorting and filtering
- Automatic documentation display

### nvim-treesitter
**Repository**: `nvim-treesitter/nvim-treesitter`
**Category**: Syntax & Parsing
**Purpose**: Advanced syntax highlighting and code understanding using Tree-sitter
**Key Features**:
- Precise syntax highlighting
- Code folding support
- Smart indentation
- Multiple language support (Lua, Python, PHP, JavaScript, HTML, CSS)
- Lazy loading for performance

---

## Development Tools

### gitsigns.nvim
**Repository**: `lewis6991/gitsigns.nvim`
**Category**: Git Integration
**Purpose**: Git decorations and hunk management in the sign column
**Key Features**:
- Visual git diff indicators (add, change, delete)
- Navigate between git hunks
- Stage/reset individual hunks
- Preview changes inline
- Blame information display
- Integration with diffview for file history

### diffview.nvim
**Repository**: `sindrets/diffview.nvim`
**Category**: Git Integration
**Purpose**: Advanced git diff and file history viewer
**Key Features**:
- Side-by-side diff viewing
- File history navigation
- Integration with gitsigns for file-specific blame

### lazygit.nvim
**Repository**: `kdheepak/lazygit.nvim`
**Category**: Git Integration
**Purpose**: LazyGit terminal UI integration
**Key Features**:
- Full-featured git interface
- Interactive commit and staging
- Branch management
- Quick access with `<leader>gl`

### toggleterm.nvim
**Repository**: `akinsho/toggleterm.nvim`
**Category**: Terminal
**Purpose**: Floating terminal management
**Key Features**:
- Multiple persistent terminal instances
- Floating, horizontal, or vertical layouts
- Easy terminal toggling

### which-key.nvim
**Repository**: `folke/which-key.nvim`
**Category**: Keybinding Helper
**Purpose**: Display available keybindings in popup menu
**Key Features**:
- Hierarchical keybinding display
- Custom group definitions
- Modern preset UI
- Context-aware suggestions

### vim-terraform
**Repository**: `hashivim/vim-terraform`
**Category**: Language Support
**Purpose**: Terraform and HCL file support
**Key Features**:
- Syntax highlighting for .tf files
- Code alignment
- Filetype detection

---

## File Management

### neo-tree.nvim
**Repository**: `nvim-neo-tree/neo-tree.nvim`
**Category**: File Explorer
**Purpose**: Feature-rich file tree explorer with git integration
**Key Features**:
- File system browser with icons
- Git status indicators
- Buffer navigation
- File operations (copy, move, delete, rename)
- Fuzzy finding within tree
- Customizable keybindings
- Relative path copying

### fzf-lua
**Repository**: `ibhagwan/fzf-lua`
**Category**: Fuzzy Finder
**Purpose**: Fast fuzzy finder for files, buffers, and text
**Key Features**:
- File searching with preview
- Ripgrep integration for text search
- Buffer navigation
- Custom search functions
- Word-under-cursor search

### conform.nvim
**Repository**: `stevearc/conform.nvim`
**Category**: Code Formatting
**Purpose**: Unified formatting interface with multiple formatter support
**Key Features**:
- Format-on-save capability
- Multi-formatter support (biome, prettierd, stylua, goimports, shfmt)
- Filetype-specific formatter selection
- Fallback to LSP formatting

### nerdcommenter
**Repository**: `preservim/nerdcommenter`
**Category**: Code Editing
**Purpose**: Easy code commenting and uncommenting
**Key Features**:
- Toggle comments with `<C-/>`
- Language-aware commenting
- Block comment support
- Empty line commenting

---

## Visual Enhancements

### lualine.nvim
**Repository**: `nvim-lualine/lualine.nvim`
**Category**: Status Line
**Purpose**: Fast and customizable statusline
**Key Features**:
- Git branch display
- File information (encoding, format, type)
- Diff statistics
- Diagnostics integration

### noice.nvim
**Repository**: `folke/noice.nvim`
**Category**: UI Enhancement
**Purpose**: Enhanced command line and notification interface
**Key Features**:
- Popup command line interface
- Improved notifications
- Message history
- Smooth fade animations

### render-markdown.nvim
**Repository**: `MeanderingProgrammer/render-markdown.nvim`
**Category**: Markdown Enhancement
**Purpose**: Rich markdown rendering in buffer
**Key Features**:
- Live preview of markdown elements
- Syntax highlighting for code blocks
- Custom heading styles with colored backgrounds
- Checkbox rendering
- Bullet list beautification
- Configurable concealment levels

### indent-blankline.nvim
**Repository**: `lukas-reineke/indent-blankline.nvim`
**Category**: Visual Guide
**Purpose**: Display indent guides for better code readability
**Key Features**:
- Visual indent markers
- Tree-sitter integration
- Scope highlighting

### mini.align
**Repository**: `echasnovski/mini.align`
**Category**: Text Alignment
**Purpose**: Interactive text alignment with live preview
**Key Features**:
- Align text by delimiters
- Visual mode support
- Preview mode with `gA`

### ccc.nvim
**Repository**: `uga-rosa/ccc.nvim`
**Category**: Color Management
**Purpose**: Color picker and converter
**Key Features**:
- Interactive color picker
- Format conversion (hex, rgb, hsl)
- LSP color integration
- Auto-highlighting of colors

### nvim-colorizer.lua
**Repository**: `norcalli/nvim-colorizer.lua`
**Category**: Color Visualization
**Purpose**: Real-time color highlighting in code
**Key Features**:
- Inline color preview for hex, RGB, named colors
- CSS function support (rgb(), hsl())
- Background color display mode

### csv.vim
**Repository**: `chrisbra/csv.vim`
**Category**: File Format Support
**Purpose**: CSV file viewing and editing with column highlighting
**Key Features**:
- Column-based navigation
- Automatic delimiter detection
- Header highlighting
- Automatic arrangement

---

## Plugin Management

All plugins are managed by **lazy.nvim**, providing:
- Lazy loading for optimal startup time
- Automatic dependency resolution
- Event-based and command-based loading
- Easy configuration and updates

Total Plugins: **29**
