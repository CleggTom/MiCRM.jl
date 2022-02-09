function MiCRMProblem(p::MiCRMParameter, u0::Array{Float64,1}, tspan::Tuple{Float64,Float64};kwargs...)
     #generate ODE problem
     DifferentialEquations.ODEProblem(du!, u0, tspan, p, kwargs)
end

function solve_MiCRM(x)
     DifferentialEquations.solve(x,AutoTsit5(Rosenbrock23()))
end