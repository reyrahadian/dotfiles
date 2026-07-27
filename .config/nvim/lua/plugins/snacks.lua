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
        },
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  -- Map lowercase 'l' to open file in active window, keeping tree active
                  ["l"] = "confirm_nofocus",
                },
              },
            },
          },
        },
      },
    },
  },
}
