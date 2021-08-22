# plink.nvim
***Create GitHub permalinks on the fly!***


## Preview

| Single Line Permalink                                                                                 | Multi-line Permalink                                                                                  |
| ---                                                                                                   | -----------                                                                                           |
| <img src="https://raw.githubusercontent.com/pacokwon/media/main/plink.nvim/ncopy.gif" width="450em"/> | <img src="https://raw.githubusercontent.com/pacokwon/media/main/plink.nvim/vcopy.gif" width="450em"/> |

## Installations

[packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use 'pacokwon/plink.nvim'
```

[vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'pacokwon/plink.nvim'
```

## Usage

Once you've installed the plugin, these mappings are all you need in your vimrc:

viml:
```viml
nnoremap <leader>pl :lua require'plink'.ncopy()<CR>
vnoremap <leader>pl :lua require'plink'.vcopy()<CR>
```

lua:
```lua
vim.api.nvim_set_keymap('n', '<leader>pl', ':lua require"plink".ncopy()<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>pl', ':lua require"plink".vcopy()<CR>', { noremap = true })
```
