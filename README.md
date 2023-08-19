<div align="center">
    <p>
    <h1>
        <img src="./assets/images/mpax_flutter.svg" width="120px"/>
        <br/>
        MPax
    </h1>
    <p>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/github/release/realth000/mpax_flutter"/></a>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/badge/-Android-313196?logo=android&logoColor=f0f0f0"/></a>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/badge/-Linux-313196?&logo=Linux&logoColor=f0f0f0"/></a>
        <a href="https://github.com/realth000/mpax_flutter/releases">
            <img src="https://img.shields.io/badge/-Windows-313196?&logo=Windows&logoColor=f0f0f0"/></a>
        <a href="https://flutter.dev/">
            <img src="https://img.shields.io/badge/Flutter-3.13-blue?logo=flutter"/></a>
        <a href="https://github.com/realth000/mpax_flutter/blob/master/LICENSE">
            <img src="https://img.shields.io/github/license/realth000/mpax_flutter"/></a>
        <a href="https://www.codacy.com/gh/realth000/mpax_flutter/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=realth000/mpax_flutter&amp;utm_campaign=Badge_Grade">
            <img src="https://app.codacy.com/project/badge/Grade/a7c4d70716514cfa89ebf8d19bd15a93"/></a>
    </p>
</div>

English|[简体中文](./docs/README_zh_CN.md)

## Work In Progress

Refactoring, not fully usable.

## Introduction

MPax is a simple and easy-to-use music player powered by flutter.

## Screenshots

![screenshot_light](./docs/images/screenshot_light.jpg)
![screenshot_dark](./docs/images/screenshot_dark.jpg)

## Features

### Audio

* [x] Format (\*.mp3).
* [ ] More format (\*.flac, \*.acc, \*.ogg, \*.cue).
* [ ] Sections (For \*.cue or manually marked list).
* [x] Read metadata.
* [ ] Write metadata.
* [ ] Playlist.
* [ ] Search.
* [ ] Lyric.
* [ ] Global shortcut.
  * [ ] Windows.
  * [ ] Linux with X11.
  * [ ] Wayland.
* [x] MPRIS.

### UI

* [x] Dark mode.
* [ ] Duration to auto stop.
* [ ] Multiple views (In album, artist, folder...).
* [ ] Shortcut.

### Platforms

* [x] Android.
* [ ] IOS.
* [x] Linux.
* [ ] MacOS.
* [x] Windows.

> May not be hard to migrate to IOS and MacOS but I don't have apple device.

## Keymap

Comming soon

## Install

[Download here.](https://github.com/realth000/mpax_flutter/releases)

* Android: mpax_flutter-version.apk
* Linux: mpax_flutter-version.tar.gz
* Windows: mpax_flutter-version.zip

## Build From Source

Prepare source code:

``git clone --recursive https://github.com/realth000/mpax_flutter.git``

### Android

``` bash

# Only need execute once.
./package/taglib_ffi/scripts/build_android.sh

flutter build apk --release

```

### Linux

* Debian:
    1. ``sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libtagc0-dev``
    2. ``flutter build linux --release``
* Arch:
    1. ``sudo pacman -S gst-plugins-good zinity``
    2. ``flutter build linux --release``

### Windows

``flutter build windows --release``

Build and build Windows libs similar to Linux steps.
