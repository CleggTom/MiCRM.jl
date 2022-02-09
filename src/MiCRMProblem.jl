function MiCRMProblem(p::MiCRMParameter, u0::Array{Float64,1}, tspan::Tuple{Float64,Float64};kwargs...)
     #generate ODE problem
     ODEProblem(MiCRM.du!, u0, tspan, p, kwargs)
end

function solve_MiCRM(x)
     solve(x,AutoTsit5(Rosenbrock23()))
end