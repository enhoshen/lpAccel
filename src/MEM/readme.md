# Memory scripts
## Synopsys shell overview
### variable
How to pass variables to the shell in your script? not `+define+`, not like `VAR=3`,but to export the variable you want. However in the tool shell, you can only access the variables through `get_unix_variable` command.
```shell
PATH=memv/
export PATH
```
```shell
$dc_shell get_unix_variable PATH
$lc_shell get_unix_variable PATH
```

## db_gen.sh
Convert the desired .lib to .db file for the memory module. The script read the `.lib` file under `memlib/` and write `.db` file to `memdb/`
usage:sh ```sh db_gen.sh MODULE```
```
$sh db_gen.sh RF_2P_64x16
```
## mem_gen.sh
Open up the chosen memory generator under `CELL_LIB_PATH`, but actually only 90nm library would work I suppose.
usage: ```sh mem_gen.sh``

## Memory Generator
`TODO`
