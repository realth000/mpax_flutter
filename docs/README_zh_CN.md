<div align="center">
    <p>
    <h1>
        <img src="../assets/images/mpax_flutter.svg" width="120px"/>
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

[English](../README.md)|简体中文

## 开发中

正在重构代码，功能不完全可用。

## 简介

MPax是使用Flutter开发的简约易用的音乐播放器。

## 软件截图

![screenshot_light](./images/screenshot_light.jpg)
![screenshot_dark](./images/screenshot_dark.jpg)

## 特性

### 音频

* [x] 格式 (\*.mp3)。
* [ ] 更多格式 (\*.flac, \*.acc, \*.ogg, \*.cue)。
* [ ] 章节 (\*.cue或者手动标记的章节)。
* [x] 读取音频标签。
* [ ] 写入音频标签。
* [ ] 播放列表。
* [ ] 搜索。
* [ ] 歌词。
* [ ] 全局快捷键。
  * [ ] Windows。
  * [ ] Linux(X11)。
  * [ ] Linux(Wayland)。
* [x] MPRIS。

### 界面

* [x] 深色模式。
* [ ] 定时停止。
* [ ] 多视图（专辑，艺术家，文件夹...）。
* [ ] 快捷键。

### 平台

* [x] Android。
* [ ] IOS。
* [x] Linux。
* [ ] MacOS。
* [x] Windows。

> 往IOS和MacOS移植应该不难，但是我没有苹果的设备。

## 快捷键

在做了在做了。

## 安装

[在这下载。](https://github.com/realth000/mpax_flutter/releases)

* Android: mpax_flutter-version.apk
* Linux: mpax_flutter-version.tar.gz
* Windows: mpax_flutter-version.zip

## 从源码构建

准备源码:

``git clone --recursive https://github.com/realth000/mpax_flutter.git``

### Android

``flutter build apk --release``

### Linux

* Debian:
    1. ``sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libtagc0-dev``
    2. ``flutter build linux --release``
* Arch:
    1. ``sudo pacman -S gst-plugins-good``
    2. ``flutter build linux --release``

### Windows

``flutter build windows --release``
