## utilities for running debian in virtualbox

for example:

    ./create.sh -n test -m 4096 -c 4 -d 20480

creates a debian server instance named "test" with 4096mb memory, 4
cpu's, and 20gb of disk. all arguments are optional.

```./create.sh``` will finally run a ```go``` program which will receive status
updates via http calls from your instance, once it begins running.



