#!/bin/bash

export USER=ubuntu
export HOME=/home/$USER

# カレントディレクトリのuidとgidの取得
uid=$(stat -c "%u" .)
gid=$(stat -c "%g" .)

if [ "$uid" -ne 0 ]; then
    if [ "$(id -g $USER)" -ne $gid ]; then
    # ubuntu ユーザの gid とカレントディレクトリの gid が異なる場合、
	# ubuntu の gid をカレントディレクトリの gid に変更し、ホームディレクトリの gid を変更する。
        getent group $gid >/dev/null 2>&1 || groupmod -g $gid $USER
        chgrp -R $gid $HOME
    fi
    if [ "$(id -u $USER)" -ne $uid ]; then
    # ubuntu ユーザの uid とカレントディレクトリの uid が異なる場合、
	# ubuntu の uid をカレントディレクトリの uid に変更する。
        usermod -u $uid $USER
    fi
fi

sudo gpasswd -a $USER sudo

# このスクリプトは root で実行されている想定のため、uid/gid 調整済みの ubuntu ユーザとして実行する
exec setpriv --reuid=$USER --regid=$USER --init-groups "$@"
cat "enter container as $USER"
