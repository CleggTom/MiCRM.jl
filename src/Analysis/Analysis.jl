module Analysis
    using ForwardDiff
    using DiffEqBase

    include("./MiCRM_jac_opt.jl")
    include("./local_analysis.jl")
end