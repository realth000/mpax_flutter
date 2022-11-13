<div align="center">
    <p>
    <h1>
        <img src="../assets/images/mpax_flutter.svg" width="120px"/>
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
            <img src="https://img.shields.io/badge/Flutter-3.3.8-blue?logo=flutter"/></a>
        <a href="https://www.dart.org/">
            <img src="https://img.shields.io/badge/Dart-2.18-blue?logo=dart"/></a>
        <a href="https://github.com/realth000/mpax_flutter/blob/master/LICENSE">
            <img src="https://img.shields.io/github/license/realth000/mpax_flutter"/></a>
        <a href="https://www.codacy.com/gh/realth000/mpax_flutter/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=realth000/mpax_flutter&amp;utm_campaign=Badge_Grade">
            <img src="https://app.codacy.com/project/badge/Grade/a7c4d70716514cfa89ebf8d19bd15a93"/></a>
    </p>
</div>

[English](../README.md)|简体中文

## 简介

MPax是使用Flutter开发的简约易用的音乐播放器。

## 软件截图

![screenshot_light](./images/screenshot_light.jpg)
![screenshot_dark](./images/screenshot_dark.jpg)

## 特性

### 音频:

* [x] 播放音乐。
* [x] 读取音频元数据标签（部分支持）。
* [ ] 修改音频元数据标签。
* [x] 播放列表（初步支持）。
* [x] 搜索。
* [ ] 歌词。

### 界面:

* [x] 深色模式。
* [ ] 定时停止。
* [ ] 多视图（专辑，艺术家，文件夹...）。

### 平台：

* [x] 安卓。
* [x] Windows。
* [x] Linux。

## 快捷键 (桌面平台)

* 上一首: ``Ctrl + Alt + V``
* 下一首: ``Ctrl + Alt + N``
* 播放/暂停: ``Ctrl + Alt + B``

## 安装

[在这下载。](https://github.com/realth000/mpax_flutter/releases)

* Android: mpax_flutter-version.apk
* Windows: mpax_flutter-version.zip
* Linux: mpax_flutter-version.tar.gz

## 从源码构建

### Android

直接执行``flutter build android --verbose``

### Windows

1. 执行``flutter build windows --verbose``
2. 下载[sqlite3.dll](https://github.com/tekartik/sqflite/raw/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll)然后放到二进制同级目录。

### Linux

1. 下载依赖``sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libkeybinder-3.0-0 libkeybinder-3.0-dev libsqlite3-0 libsqlite3-dev libtagc0-dev``

2. 编译`` flutter build linux --verbose``

