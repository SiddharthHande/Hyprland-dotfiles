return {
  open_mapping = [[<C-\>]],  -- ⟵ your shortcut key
  direction = "float",       -- or "horizontal"/"vertical"
  start_in_insert = true,    -- focus terminal on open
  shade_terminals = true,
  persist_mode = false,      -- don't remember mode, always start in insert
  float_opts = {
    border = "curved",
  },
}
