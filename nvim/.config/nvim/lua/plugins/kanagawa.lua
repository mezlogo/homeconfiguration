return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("kanagawa").setup({
			compile=true
		});
		vim.cmd.colorscheme("kanagawa-dragon")
	end,
	build = function()
		vim.cmd("KanagawaCompile")
	end
}
