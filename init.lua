require("todo-comments").setup() 

-- Configuring treesitter
require 'nvim-treesitter.install'.compilers = {"gcc", "clang"}

require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = { "c", "cpp", "css", "html" }
    }
    }

require("which-key").setup()

require("nvim-autopairs").setup {
  enable_check_bracket_line = false
}

require('numb').setup()

require('competitest').setup()
