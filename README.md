# MiCRM

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://cleggtom.github.io/MiCRM.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://cleggtom.github.io/MiCRM.jl/dev)
[![Build Status](https://github.com/cleggtom/MiCRM.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/cleggtom/MiCRM.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/cleggtom/MiCRM.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/cleggtom/MiCRM.jl)

*Simulation of Microbial Consumer Resource (MiCRM) systems in julia.*

This package contains code for the simulation of microbial consumer resource models. Broadly this takes the form as wrappers to the [SciML](https://sciml.ai/documentation/) package ecosystem which provide the machinery for numerical simulations and sybolic representations of systems of ODEs.

## Installation
You can install the package directly from this repository through the julia package manager (see [here](https://pkgdocs.julialang.org) for more details). To do so start open the `julia` REPL and type `]` to enter the package manager:

```julia
julia> ]
(@v1.6) pkg> 
```

activate the enviroment you want to install the package too with the `activate` command and then add the package with `add`:

```julia
(@v1.6) pkg> activate /path/to/my/project
  Activating environment at `/path/to/my/project/Project.toml`

(myproject) pkg> add https://github.com/CleggTom/MiCRM.jl
     Cloning git-repo `https://github.com/CleggTom/MiCRM.jl`
    Updating git-repo `https://github.com/CleggTom/MiCRM.jl`
    Updating registry at `~/.julia/registries/General`
   Resolving package versions...
    Updating `~/Projects/Working/test/Project.toml`
  [a39c0ef7] + MiCRM v0.0.1 `https://github.com/CleggTom/MiCRM.jl#main`
    Updating `~/Projects/Working/test/Manifest.toml`
  [a39c0ef7] + MiCRM v0.0.1 `https://github.com/CleggTom/MiCRM.jl#main`
```

and the epackage is installed which you can load it the `using` command in the julia prompt:
```julia
using MiCRM
```

For more details on how to use the package please see the [full documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://cleggtom.github.io/MiCRM.jl/stable)
