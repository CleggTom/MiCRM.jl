struct MiCRMSystem
     p::MiCRM.MiCRMParameter
     u0::Array{Float64,1}
     tspan::Tuple{Float64, Float64}
end

function DiffEqBase.ODEProblem(system::MiCRMSystem, kwargs...)
      DiffEqBase.ODEProblem(DiffEqBase.ODEFunction(MiCRM.du!), system.u0, system.tspan, system.p, kwargs)
end
