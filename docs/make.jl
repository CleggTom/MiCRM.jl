push!(LOAD_PATH,"../src/")

using Pkg
Pkg.activate(".")
using MiCRM
using Documenter

# DocMeta.setdocmeta!(MiCRM, :DocTestSetup, :(using MiCRM); recursive=true)

makedocs(;
    modules=[MiCRM],
    authors="Tom <t.clegg17@imperial.ac.uk> and contributors",
    repo="https://github.com/cleggtom/MiCRM.jl/blob/{commit}{path}#{line}",
    sitename="MiCRM.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cleggtom.github.io/MiCRM.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md"
        "Manual" => ["Basic Usage" => "pages/guide.md",
                    "Parameters" => "pages/parameters.md"]

        #             "Generating Communities" => "pages/community_generation.md",
        #             "Building an ODESystem" => "pages/building_ODESystems.md",
        #             "Coalescence" => "pages/coalescence.md"],
        # "Library" => ["Public" => "pages/library/public.md",
        #               "Internal" => "pages/library/internal.md"]
    ],
)

deploydocs(;
    repo="github.com/CleggTom/MiCRM.jl.git"
)
