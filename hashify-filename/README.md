## Hashify Filename

This little script renames given files to its [MD5](https://en.wikipedia.org/wiki/MD5) hashsum. File extension won't be changed.
This allows duplicate files in the same directory to be easily detected and merged / overwritten.

This script is just a fork of [randomize-filename](../randomize-filename).


#### Arguments

The can take one extra argument

`-r` - recursive: If any directory where given while calling this command, all files in it will be renamed recursively.

#### Usage

```
$ hashify-filename.sh -r .
```
