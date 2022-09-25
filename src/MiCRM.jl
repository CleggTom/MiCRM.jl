module MiCRM

    using Reexport
    # # @reexport using ModelingToolkit
    # @reexport using DiffEqBase, OrdinaryDiffEq
    using LinearAlgebra, Distributions

    # using MakieCore
    # MakieCore.convert_arguments(sol::SciMLBase.SciMLSolution) = (sol[:,:],)

    # parameter generation
    include("./Parameters/Parameters.jl")

    # simulation functions
    include("./Simulations/Simulations.jl")

    # Stressor functions
    include("./Stressors/Stressors.jl")

    using .Parameters
    using .Simulations

    #exports
    #Parameters
    export random_params



end
