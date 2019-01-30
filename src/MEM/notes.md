# Shell scripting and stuff
## Variables
`export` some variable in a shell script makes it global, so that it can be accessed in sub processes:
```shell
MYVAR="my cool variable"

echo "Without export:"
printenv | grep MYVAR

echo "With export:"
export MYVAR
printenv | grep MYVAR
```
in the above example, MYVAR can be printed out in with export

