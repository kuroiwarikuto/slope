#!/bin/bash -xv
# SPDX-FileCopyrightText: 2026 Rikuto Kuroiwa
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目が違うよ"
    res=1
}

res=0

### 正常系のテスト ###
out=$(printf "0\n1\n4\n9\n" | ./slope)
[ "${out}" = $'1\n3\n5' ] || ng "$LINENO"

out=$(printf "1.5\n0.5\n-1.5\n" | ./slope)
[ "${out}" = $'-1.0\n-2.0' ] || ng "$LINENO"

out=$(printf "0\n1\n4\n" | ./slope -d 0.5)
[ "${out}" = $'2.0\n6.0' ] || ng "$LINENO"

out=$(printf "0\n1\n4\n9\n16\n" | ./slope | ./slope)
[ "${out}" = $'2\n2\n2' ] || ng "$LINENO"

### 異常系のテスト ###
out=$(echo あ | ./slope)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(printf "" | ./slope)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(echo 5 | ./slope)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(printf "0\n1\n" | ./slope -d 0)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(printf "0\n1\n" | ./slope -d -1)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(printf "0\n1\n" | ./slope -d abc)
[ "$?" != 0 ]     || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
