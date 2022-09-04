"""
    growth_MiCRM!(dx,x,p,i)

default growth function for the MiCRM.
"""
function growth_MiCRM!(dx,x,p,t,i)
    #mortality
    dx[i] += -p.m[i] * x[i]
    #resource uptake
    for α = 1:p.M
        dx[i] += x[α + p.N] * x[i] * p.u[i,α] * (1 - p.λ)
    end
end


"""
    supply_MiCRM!(dx,x,p,i)

default supply function for the MiCRM.
"""
function supply_MiCRM!(dx,x,p,t,α)
    #inflow - outflow
    dx[α + p.N] += p.ρ[α] - (x[α + p.N] * p.ω[α])
end

"""
depletion_MiCRM!(dx,x,p,i)

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

# doc"""
#     dx!(dx,x,p,t, growth! = growth_MiCRM!, supply!::Function = supply_MiCRM!, uptake!::Function = uptake_MiCRM!)   

# Derivative function for the general MICRM model. 
# This function is used internally by the `DiffEq` solver which requires the first four arguments (`dx!(dx,x,p,t)`). 
# The additional arguments detail the exact functional form of the model which overall looks like:
# ```math
#     \begin{align}
#         \frac{C_i}{dt} = f(C_i, \bf{R}, p) \\
#         \frac{R_\alpha}{dt} = g(\bf{R}, p) + h(\bf{R},\bf{C}, p)
#     \end{align}


# ```
# """
function dx!(dx,x,p,t; 
        growth!::Function = growth_MiCRM!, 
        supply!::Function = supply_MiCRM!,
        depletion!::Function = depletion_MiCRM!,
        extrinsic!::Function = null_func!)
   
    for i = 1:p.N #consumer loop
        #reset derivatives
        dx[i] = 0.0
        #if consumer is extant
        if x[i] > eps(x[i])
            growth!(dx,x,p,t,i) #update dx of ith consumer
        end

    end

    for α = 1:p.M #resource loop
        #reset derivatives
        dx[α + p.N] = 0.0
        #supply term
        supply!(dx,x,p,t,α)
        #loop over consumers
        for i = 1:p.N
            if x[i] > eps(x[i])
                depletion!(dx,x,p,t,i,α)
            end
        end
    end

    #for other state variables
    extrinsic!(dx,x,p,t)
end

