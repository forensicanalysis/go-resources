This is a simplified fork of github.com/omeid/go-resources/cmd/resources

# Resources [![GoDoc](https://img.shields.io/badge/godoc-reference-blue.svg?style=flat-square)](https://godoc.org/github.com/cugu/go-resources)  [![Build Status](https://travis-ci.org/cugu/go-resources.svg?branch=master)](https://travis-ci.org/cugu/go-resources) [![Go Report Card](https://goreportcard.com/badge/github.com/cugu/go-resources?bust=true)](https://goreportcard.com/report/github.com/cugu/go-resources)
Unfancy resources embedding with Go.

- No blings.
- No runtime dependency.
- Idiomatic Library First design.

### Dude, Why?

Yes, there is quite a lot of projects that handles resource embedding
but they come with more bling than you ever need and you often end up
with having dependencies for your end project. Not this time.

### Installing

Just go get it!

```sh
$ go get github.com/cugu/go-resources/cmd/resources
```

### Usage

```
$ resources -h
Usage resources:
  -output filename
        filename to write the output to
  -package name
        name of the package to generate (default "main")
  -tag tag
        tag to use for the generated package (default no tag)
  -trim prefix
        path prefix to remove from the resulting file path in the virtual filesystem
  -var name
        name of the variable to assign the virtual filesystem to (default "FS")
```

### Optimization

Generating resources result in a very high number of lines of code, 1MB
of resources result about 5MB of code at over 87,000 lines of code. This
is caused by the chosen representation of the file contents within the
generated file.

Instead of a (binary) string, `resources` transforms each file into an
actual byte slice. For example, a file with content `Hello, world!` will
be represented as follows:

``` go
var FS = map[string][]byte{
  "/hello.txt": []byte{
      0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64,
      0x21,
  },
}
```

While this seems wasteful, the compiled binary is not really affected.
_If you add 1MB of resources, your binary will increase 1MB as well_.

However, compiling this many lines of code takes time and slows down the
compiler. To avoid recompiling the resources every time and leverage the
compiler cache, generate your resources into a standalone package and
then import it, this will allow for faster iteration as you don't have
to wait for the resources to be compiled with every change.

``` sh
mkdir -p assets
resources -var=FS -package=assets -output=assets/assets.go your/files/here
```

``` go
package main

import "importpath/to/assets"

func main() {
  data, ok := assets.FS["your/files/here"]
  // ...
}
```

### Credits

This is a fork of github.com/omeid/go-resources/cmd/resources
