## Hashify Filename

With this little script you can randomize the names of given files. File extension won't be changed.


#### Arguments

The file takes several arguments

`-r` - recursive: If any directory where given while calling this command, all files in it will be renamed recursively.

`-a` - all (the name is a little misleading): Normally directories are not renamed, but with this argument they will.

`-l LENGHT` - lenght: The lenght of the randomized filenames (default is 16). Replace `LENGHT` with the lenght the randomized names should have.

#### Usage

```
$ randomize-filename.sh -r .
```
