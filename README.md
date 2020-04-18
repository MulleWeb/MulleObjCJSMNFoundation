# MulleObjCJSMNFoundation

#### 🌼 JSON support for mulle-objc

JSON parsing, based on the [jsmn](//github.com/zserge/jsmn) parser.


Build Status | Release Version
-------------|-----------------------------------
[![Build Status](https://travis-ci.org/MulleWeb/MulleObjCJSMNFoundation.svg?branch=release)](https://travis-ci.org/MulleWeb/MulleObjCJSMNFoundation) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleWeb/MulleObjCJSMNFoundation.svg) [![Build Status](https://travis-ci.org/MulleWeb/MulleObjCJSMNFoundation.svg?branch=release)](https://travis-ci.org/MulleWeb/MulleObjCJSMNFoundation)


## About

The library provides a class **MulleJSMNParser** and adds support for JSON
deserialization to the **NSPropertyListSerialization**.


## Add

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjCJSMNFoundation to your project:

```
mulle-sde dependency add --c --github MulleWeb MulleObjCJSMNFoundation
```

## Install

**MulleObjCJSMNFoundation** is part of **Foundation**, see
[foundation-developer](//github.com//foundation-developer) for
installation instructions.


### Manual install

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjCJSMNFoundation
and all its dependencies:

```
mulle-sde install --objc --prefix /usr/local \
   https://github.com/MulleWeb/MulleObjCJSMNFoundation/archive/latest.tar.gz
```


## Acknowledgements

This library uses [JSMN](https://github.com/zserge/jsmn) which is MIT Licensed:

```
Copyright (c) 2010 Serge A. Zaitsev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```


## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)
