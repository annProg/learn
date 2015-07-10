set fileencodings=utf-8,gb2312,gbk,gb18030,big5
set fenc=utf-8
set enc=utf-8

set ts=4
set shiftwidth=4
set nu

set pastetoggle=<F9>
"set cindent

"auto add code header --start  
autocmd BufNewFile *.py 0r ~/.vim/template/py.tpl
autocmd BufNewFile *.py ks|call FileName()|'s  
autocmd BufNewFile *.py ks|call CreatedTime()|'s  
 
autocmd BufNewFile *.sh 0r ~/.vim/template/bash.tpl
autocmd BufNewFile *.sh ks|call FileName()|'s  
autocmd BufNewFile *.sh ks|call CreatedTime()|'s  

autocmd BufNewFile *.php 0r ~/.vim/template/php.tpl
autocmd BufNewFile *.php ks|call FileName()|'s  
autocmd BufNewFile *.php ks|call CreatedTime()|'s  

fun FileName()  
    if line("$") > 10  
        let l = 10  "这里是字母L 不是数字1   
    else  
        let l = line("$")  
    endif   
    exe "1," . l . "g/File Name:.*/s/File Name:.*/File Name: " .expand("%")    
       "最前面是数字1，这里的File Name: 要和模板中一致  
endfun   
  
fun CreatedTime()  
    if line("$") > 10  
        let l = 10  
    else  
        let l = line("$")  
    endif   
    exe "1," . l . "g/Created Time:.*/s/Created Time:.*/Created Time: " .strftime("%Y-%m-%d %T")   
        "这里Create Time: 要和模板中一致  
endfun   
"auto add python header --end  
