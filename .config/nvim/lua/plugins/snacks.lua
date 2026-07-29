return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          -- Helper action to open file without losing tree focus
          confirm_nofocus = function(picker)
            picker:action("confirm")
            picker:focus()
          end,
          -- Copy path of the item(s) under the cursor / selection
          copy_path_relative = function(picker)
            local paths = {}
            for _, item in ipairs(picker:selected({ fallback = true })) do
              local path = Snacks.picker.util.path(item)
              table.insert(paths, vim.fn.fnamemodify(path, ":."))
            end
            local value = table.concat(paths, "\n")
            vim.fn.setreg("+", value)
            Snacks.notify.info("Copied: " .. value)
          end,
          copy_path_name = function(picker)
            local paths = {}
            for _, item in ipairs(picker:selected({ fallback = true })) do
              table.insert(paths, vim.fn.fnamemodify(Snacks.picker.util.path(item), ":t"))
            end
            local value = table.concat(paths, "\n")
            vim.fn.setreg("+", value)
            Snacks.notify.info("Copied: " .. value)
          end,
        },
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  -- Map lowercase 'l' to open file in active window, keeping tree active
                  ["l"] = "confirm_nofocus",
                  -- Copy path: Y = absolute, gy = relative to cwd, gn = filename only
                  ["Y"] = { "explorer_yank", mode = { "n", "x" } },
                  ["gy"] = { "copy_path_relative", mode = { "n", "x" } },
                  ["gn"] = { "copy_path_name", mode = { "n", "x" } },
                },
              },
            },
          },
        },
      },
    },
  },
}
