" vim-airline template by chartoin (http://github.com/chartoin)
" Base 16 Default Scheme by Chris Kempson (http://chriskempson.com)
let g:airline#themes#teyras#palette = {}
let s:gui00 = "#181818"
let s:gui01 = "#282828"
let s:gui02 = "#383838"
let s:gui03 = "#585858"
let s:gui04 = "#b8b8b8"
let s:gui05 = "#d8d8d8"
let s:gui06 = "#e8e8e8"
let s:gui07 = "#f8f8f8"
let s:gui08 = "#ab4642"
let s:gui09 = "#dc9656"
let s:gui0A = "#f7ca88"
let s:gui0B = "#a1b56c"
let s:gui0C = "#86c1b9"
let s:gui0D = "#7cafc2"
let s:gui0E = "#ba8baf"
let s:gui0F = "#a16946"

" 0 - white
" 1 - red
" 2 - green
" 3 - yellow
" 4 - blue
" 5 - magenta
" 6 - cyan
" 7 - white
" 8 - grey
" 9 - light red
" 10 - light green
" 11 - light yellow
" 12 - light blue
" 13 - light magenta
" 14 - light cyan
" 15 - bright white
" 16 - black

let s:N1   = [ s:gui01, s:gui0B, 16, 4 ]
let s:N2   = [ s:gui06, s:gui02, 0, 8 ]
let s:N3   = [ s:gui09, s:gui01, 0, 0 ]
let g:airline#themes#teyras#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let s:I1   = [ s:gui01, s:gui0D, 16, 3 ]
let s:I2   = [ s:gui06, s:gui02, 0, 8 ]
let s:I3   = [ s:gui09, s:gui01, 0, 0 ]
let g:airline#themes#teyras#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

let s:R1   = [ s:gui01, s:gui08, 16, 5 ]
let s:R2   = [ s:gui06, s:gui02, 0, 8 ]
let s:R3   = [ s:gui09, s:gui01, 0, 0 ]
let g:airline#themes#teyras#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)

let s:V1   = [ s:gui01, s:gui0E, 16, 2 ]
let s:V2   = [ s:gui06, s:gui02, 0, 8 ]
let s:V3   = [ s:gui09, s:gui01, 0, 0 ]
let g:airline#themes#teyras#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let s:IA1   = [ s:gui05, s:gui01, 16, 0 ]
let s:IA2   = [ s:gui05, s:gui01, 0, 8 ]
let s:IA3   = [ s:gui05, s:gui01, 0, 0 ]
let g:airline#themes#teyras#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

" Here we define the color map for ctrlp.  We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#teyras#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ [ s:gui07, s:gui02, 7, 8, '' ],
      \ [ s:gui07, s:gui04, 7, 4, '' ],
      \ [ s:gui05, s:gui01, 4, 0, 'bold' ])
