#! /bin/sh -e

# Test bang macros with multiple paths. This is useful in the kernel Tupfiles
# to order the objects correctly when using local .c files and built-in.o files
# in subdirectories.

. ./tup.sh
tmkdir sub
cat > Tupfile << HERE
!cc_linux.c = |> gcc -c %f -o %o |> %B.o
!cc_linux.o = |> |>
: foreach foo.c sub/built-in.o bar.c |> !cc_linux. |> {objs}
: {objs} |> echo %f |>
HERE
tup touch foo.c bar.c sub/built-in.o Tupfile
update

check_exist foo.o bar.o
tup_object_exist . 'gcc -c foo.c -o foo.o'
tup_object_exist . 'gcc -c bar.c -o bar.o'
tup_object_no_exist . 'gcc -c sub/built-in.o -o built-in.o'
tup_object_exist . 'echo foo.o sub/built-in.o bar.o'

eotup
