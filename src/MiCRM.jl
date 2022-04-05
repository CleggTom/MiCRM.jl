module MiCRM

    using Reexport
    @reexport using ModelingToolkit
    @reexport using DifferentialEquations

    using Distributions, IfElse

    #community generation
    include("crm_parameters.jl")
    
    #ModelingToolkit wrappers
    include("MTK/crm_systems.jl")

    #Differential equations wrappers
    include("DiffEq/crm_problem.jl")

    include("./coalescence.jl")

    export random_micrm_params, micrm_system, micrm_params

end
