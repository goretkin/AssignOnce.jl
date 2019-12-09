# AssignOnce.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/goretkin/AssignOnce.jl.svg?branch=master)](https://travis-ci.com/goretkin/AssignOnce.jl)
[![codecov.io](http://codecov.io/github/goretkin/AssignOnce.jl/coverage.svg?branch=master)](http://codecov.io/github/goretkin/AssignOnce.jl?branch=master)

## Usage
Suppose you are writing a quick-and-dirty script to process some data:

```julia
data = load()
stage1 = f(data)
stage2 = g(stage1)
```

You may be updating the `g`, and re-`include`ing the script in the REPL. If `data = load()` is slow and the result doesn't change, you could comment out the assignment statement. Additionally, if `f` isn't changing, but `f(data)` takes more than an instant, you could also comment it out.
Questionably better yet, you can try the package:

```julia
using AssignOnce
@assignonce data = load()
@assignonce stage1 = f(data)
stage2 = g(stage1)
```

It will print to `stdout` whether it executes the assignment, or skips it.

## Caveats
`@assignonce` must be called in a global scope. In Julia is intentionally not possible to inspect and modify bindings in a local scope.

This utility macro should not be used in anything but quick-and-dirty scripts.
