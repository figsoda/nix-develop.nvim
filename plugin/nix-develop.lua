vim.api.nvim_create_user_command("NixDevelop", function(ctx)
  require("nix-develop").nix_develop(vim.tbl_map(vim.fn.expand, ctx.fargs))
end, {
  nargs = "*",
})
