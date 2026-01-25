" .obsidian.vimrc - Keybindings based on Neovim config
" Focus on keybindings only

" Clear highlights on search when pressing <Esc> in normal mode
nmap <Esc> :nohl<CR>

" Window navigation (AstroNvim style)
" Use CTRL+<hjkl> to switch between windows
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k

" Window resizing (AstroNvim style)
nmap <C-Left> :vertical resize -2<CR>
nmap <C-Right> :vertical resize +2<CR>
nmap <C-Up> :resize +2<CR>
nmap <C-Down> :resize -2<CR>

" Splits (AstroNvim style)
nmap \ :split<CR>
nmap | :vsplit<CR>

" File operations
" New file
exmap newfile obcommand file-explorer:new-file
nmap <Space>n :newfile<CR>

" Save file (Ctrl+S in normal and insert mode)
exmap save obcommand editor:save-file
nmap <C-s> :save<CR>
imap <C-s> <Esc>:save<CR>

" Close buffer/pane
exmap close obcommand workspace:close
nmap <Space>c :close<CR>

" Toggle file explorer
exmap toggleexplorer obcommand file-explorer:toggle
nmap <Space>e :toggleexplorer<CR>

" Toggle comment
exmap togglecomment obcommand editor:toggle-comment
nmap <Space>/ :togglecomment<CR>
vmap <Space>/ :togglecomment<CR>

" Save operations
nmap <Space>w :save<CR>
nmap <Space>q :close<CR>

" Navigation - Go back and forward
" (Note: Make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" Yank to system clipboard
set clipboard=unnamed

" Have j and k navigate visual lines rather than logical ones (optional, uncomment if desired)
" nmap j gj
" nmap k gk

" Use H and L for beginning/end of line (optional, uncomment if desired)
" nmap H ^
" nmap L $
