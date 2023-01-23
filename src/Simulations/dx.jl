"""
    growth_MiCRM!(dx,x,p,t,i)

default growth function for the MiCRM.
"""
function growth_MiCRM!(dx,x,p,t,i)
    #mortality
    dx[i] += -p.m[i] * x[i]
    #resource uptake
    for α = 1:p.M
        tmp = 0.0
        for β = 1:p.M
            tmp += p.l[α,β]
        end
        dx[i] += x[α + p.N] * x[i] * p.u[i,α] * (1 - tmp)
    end
end

"""
    supply_MiCRM!(dx,x,p,t,α)

default supply function for the MiCRM.
"""
function supply_MiCRM!(dx,x,p,t,α)
    #inflow - outflow
    dx[α + p.N] += p.ρ[α] - (x[α + p.N] * p.ω[α])
end

"""
    depletion_MiCRM!(dx,x,p,t,i,α)

default depletion function for the MiCRM.
"""
function depletion_MiCRM!(dx,x,p,t,i,α)
    #uptake
    dx[α + p.N] += -x[α + p.N] * p.u[i,α] * x[i]
    #leakage
    for β = 1:p.M
        dx[α + p.N] += x[β + p.N] * x[i] * p.u[i,β] * p.l[β,α]
    end
end

function null_func!(dx,x,p,t)
end

"""
    dx!(dx,x,p,t; 
        growth!::Function = growth_MiCRM!, 
        supply!::Function = supply_MiCRM!,
        depletion!::Function = depletion_MiCRM!,
        extrinsic!::Function = null_func!)

Derivative function for the general MICRM model. This function is used internally by the `DiffEq` solver which requires the first four arguments (`dx!(dx,x,p,t)`). 

"""
function dx!(dx,x,p,t; 
        growth!::Function = growth_MiCRM!, 
        supply!::Function = supply_MiCRM!,
        depletion!::Function = depletion_MiCRM!,
        extrinsic!::Function = null_func!)
   
    for i = 1:p.N #consumer loop
        dx[i] = 0.0
        growth!(dx,x,p,t,i) #update dx of ith consumer
    end

    for α = 1:p.M #resource loop
        #reset derivatives
        dx[α + p.N] = 0.0
        #supply term
        supply!(dx,x,p,t,α)
        #loop over consumers
        for i = 1:p.N
                depletion!(dx,x,p,t,i,α)
        end
    end

    #for other state variables
    extrinsic!(dx,x,p,t)
end

