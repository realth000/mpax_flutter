#!/bin/bash

set -ex


COMMAND=""
MPAX_VERSION=""
GIT_COMMIT_TIME=$(git --no-pager show --oneline --format=%cd --date=format:"%F %T %z" -s HEAD)
GIT_COMMIT_ID=$(git --no-pager show --oneline --format=%h -s HEAD)
GIT_COMMIT_ID_LONG=$(git --no-pager show --oneline --format=%H -s HEAD)
FLUTTER_VERSION=$(flutter --version | sed -n 's/Flutter \([0-9\.]*\).*/\1/p')
DART_VERSION=$(dart --version | sed -n 's/Dart SDK version: \([0-9\.]*\).*/\1/p')

if [ -f ../pubspec.yaml ];then
	PUBSPEC_FILE="../pubspec.yaml"
elif [ -f pubspec.yaml ];then
	PUBSPEC_FILE="pubspec.yaml"
fi
MPAX_VERSION=$(cat ${PUBSPEC_FILE} | sed -n 's/version: \([0-9\.\+]*\).*/\1/p')

if [ "x$1" == "xrun" ];then
	COMMAND="run"
else
	COMMAND="build"
fi

flutter "${COMMAND}" \
	--dart-define=GIT_COMMIT_TIME="${GIT_COMMIT_TIME}" \
	--dart-define=GIT_COMMIT_ID="${GIT_COMMIT_ID}" \
	--dart-define=GIT_COMMIT_ID_LONG="${GIT_COMMIT_ID_LONG}" \
	--dart-define=FLUTTER_VERSION="${FLUTTER_VERSION}" \
	--dart-define=DART_VERSION="${DART_VERSION}" \
	--dart-define=MPAX_VERSION="${MPAX_VERSION}" \


