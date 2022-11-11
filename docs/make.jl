push!(LOAD_PATH,"../src/")

# using MiCRM
using Documenter
using MiCRM
using MiCRM.Parameters
using MiCRM.Analysis

DocMeta.setdocmeta!(MiCRM, :DocTestSetup, :(using MiCRM); recursive=true)


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
        "Manual" => ["Basic Usage" => "pages/overview.md",
                    "Parameters" => ["Overview" => "pages/parameters/parameters.md",
                                    "Parameter generators" => "pages/parameters/community_generation.md",
                                    "Coalescence"=>"pages/parameters/coalescence.md"],
                    "Simulations" => ["Overview" => "pages/simulations/simulations.md",
                                    "Custom Dynamics" => "pages/simulations/custom_dynamics.md"],
                    "Analysis" => ["Overview" => "pages/analysis/analysis.md",
                                    "Effective Lottka Volterra" => "pages/analysis/GLV.md",
                                    "Local Stability Analysis" => "page/analysis/local_stability.md"]
    ]],
)

deploydocs(;
    repo="github.com/CleggTom/MiCRM.jl.git"
)
