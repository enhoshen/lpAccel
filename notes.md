# Notes for Programming in this projects and stuffs
## Vim
### Johnjohnlin's port connect command for vim
Under johnjohnlin's `.vim` folder, copy `ftplugin/` ( short for file type plugin) and `autoload/` to your own `.vim/`.
* IO to ports: select IO lists and type `_P`, that is `-p` while holding shift
* Connect ports: select ports lists and type `_C`
### Tab navigation
change tab:
* `ctrl`+`pgup/pgdn` 
* number +`g`+`t`
## Python
### Flexible function arguments
Besides `*args` and `**kwargs`, additional positional and keyword arguments are all allowed, but watch out for their order
* All positional argument and expression `*args` should be before any keyword arguments and `**kwargs`
* Additional positional arguments should be before `*args`, likewise additional keyword arguments should be before `**kwargs`
## Environment
### Grep
Basic uses:
* ```$grep 'pattern' * -r```: search for pattern string in every files recursively under current working directory.
