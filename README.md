<div align="center">
    <p>
    <h1>
        <img src="./assets/images/mpax_flutter.svg" width="120px"/>
        <br/>
        MPax
    </h1>
    </p>
    <p>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/github/release/realth000/mpax_flutter"/></a>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/badge/-Android-313196?logo=android&logoColor=f0f0f0"/></a>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/badge/-Windows-313196?&logo=Windows&logoColor=f0f0f0"/></a>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/badge/-Linux-313196?&logo=Linux&logoColor=f0f0f0"/></a>
        <a href="https://flutter.dev/">
            <img src="https://img.shields.io/badge/Flutter-3.7.0-blue?logo=flutter"/></a>
        <a href="https://www.dart.org/">
            <img src="https://img.shields.io/badge/Dart-2.19-blue?logo=dart"/></a>
        <a href="https://github.com/realth000/mpax_flutter/blob/master/LICENSE">
            <img src="https://img.shields.io/github/license/realth000/mpax_flutter"/></a>
        <a href="https://www.codacy.com/gh/realth000/mpax_flutter/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=realth000/mpax_flutter&amp;utm_campaign=Badge_Grade">
            <img src="https://app.codacy.com/project/badge/Grade/a7c4d70716514cfa89ebf8d19bd15a93"/></a>
    </p>
</div>

English|[简体中文](./docs/README_zh_CN.md)

## Introduction

MPax is a simple and easy-to-use music player powered by flutter.

## Screenshots

![screenshot_light](./docs/images/screenshot_light.jpg)
![screenshot_dark](./docs/images/screenshot_dark.jpg)

## Features

### Audio:

* [x] Music playing.
* [x] Read metadata (now is part of).
* [ ] Modify metadata.
* [x] Playlist (partly).
* [x] Search.
* [ ] Lyric.

### UI:

* [x] Dark mode.
* [ ] Duration to auto stop.
* [ ] Multiple views (In album, artist, folder...).

### Platforms:

* [x] Android.
* [x] Windows.
* [x] Linux.

## Keymap (Desktop platforms)

* Play Previous: ``Ctrl + Alt + V``
* Play Next: ``Ctrl + Alt + N``
* Play/Pause: ``Ctrl + Alt + B``

## Install

[Download here.](https://github.com/realth000/mpax_flutter/releases)

* Android: mpax_flutter-version.apk
* Windows: mpax_flutter-version.zip
* Linux: mpax_flutter-version.tar.gz

## Build From Source

### Android

Run ``flutter build android --verbose``

### Windows

1. Run ``flutter build windows --verbose``
2. Download [sqlite3.dll](https://github.com/tekartik/sqflite/raw/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll)
   and put in the same folder as the executable.

### Linux

1.

Run ``sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libkeybinder-3.0-0 libkeybinder-3.0-dev libsqlite3-0 libsqlite3-dev libtagc0-dev``

2. Run `` flutter build linux --verbose``
