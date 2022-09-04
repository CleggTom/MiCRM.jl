module MiCRM

    using Reexport
    # # @reexport using ModelingToolkit
    @reexport using DiffEqBase, OrdinaryDiffEq
    using LinearAlgebra, Distributions

    # parameter generation
    include("./Parameters/Parameters.jl")

    # simulation functions
    include("./Simulations/Simulations.jl")

    using .Parameters
    using .Simulations

    #exports
    #Parameters
    export random_params

end
