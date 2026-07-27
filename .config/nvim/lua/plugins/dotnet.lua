return {
  -- OmniSharp is effectively unmaintained and crash-loops on analyzer-load
  -- failures (INVALID_SERVER_MESSAGE protocol desync); every retry after a
  -- crash re-attaches wherever the cursor is, which is how it ended up
  -- registering nearly every solution in this monorepo and froze nvim on
  -- 2026-07-23. roslyn.nvim wraps Microsoft's actively maintained Roslyn LSP
  -- (same server VS Code's C# Dev Kit uses) and scopes per buffer to the
  -- nearest ancestor .sln, which is a clean boundary here since every
  -- service under mecca-brands is its own git repo.
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        omnisharp = false,
      },
    },
  },
}
