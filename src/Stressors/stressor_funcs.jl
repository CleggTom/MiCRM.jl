#dynamics
"""
    growth_MiCRM_stressor!(dx,x,p,t,i)

Growth function for the stressor model. Identical to the standard MiCRM but includes an additional mortality term `C_i * S * γ_i` reflecting the negaitve effects of the stressor S. 
"""
function growth_MiCRM_stressor!(dx,x,p,t,i)
    dx[i] += -x[i] * p.m[i] - (x[i] * x[p.kw.S_ind] * p.kw.γ[i])
    for α = 1:p.M
        dx[i] += x[i] * x[α + p.N] * p.u[i,α] * (1 - p.λ) #uptake
    end
end

"""
    stressor!(dx,x,p,t)

Stressor dynamics follow a negative exponential, decaying at rate d.
"""
function stressor!(dx,x,p,t)
    dx[p.kw.S_ind] = p.kw.d * x[p.kw.S_ind]
end

#analysis
#define functions to calculate sensitvtiy
"""
    dRdS(p,C_extant)

Calculates a vector of resource sensitvties given a parameter set and the extant consumers
"""
function dRdS(p,C_extant)   
    return(pinv(p.u[C_extant,:] * diagm((ones(p.M) - p.l * ones(p.M)))) * p.γ[C_extant])
end

"""
    dCdS(p, C_extant, R, C, dR)

    Calculates consumer sensitvtiy given parameters as well as the system equilibirum state. 
"""
function dCdS(p, C_extant, R, C, dR)
   leakage_factor = (p.l' - I(p.M))
       
    a = pinv(leakage_factor * diagm(R) * p.u[C_extant,:]')
    b = diagm(dR) * p.ω - leakage_factor * diagm(dR) * p.u[C_extant,:]' * C[C_extant]

    return(a * b)
end

"""
    calc_sensitvtiy(sol)

Calculates the sensitvtiy of the whole system. Takes a single solution object for a simulation that has already reached equilibirum. 
"""
function calc_sensitvtiy(sol)
    #get final deriv + assert equilibrium
    print(minimum( sol(sol.t[end],Val{1})) )
    
    #get end masses
    C,R = sol[end][1:sol.prob.p.N], sol[end][sol.prob.p.N + 1  : end - 1]
    
    C_extant = findall(C .> eps())
    
    dR = dRdS(sol.prob.p, C_extant)
    dC = dCdS(sol.prob.p, C_extant, R, C, dR)
    
    return(vcat(dC[:],dR[:]))
end

"""
    remove_extinct(sol)
removes extinct consumers from a solution object
"""
function remove_extinct(sol)
    p = sol.prob.p
    
    to_keep = findall(sol[end][1:p.N]  .> eps())
    to_rm = findall(sol[end][1:p.N]  .< eps())
    
    p_dict = Dict(zip(keys(p),values(p)))

    #remove from params
    p_dict[:u] = p_dict[:u][to_keep,:]
    p_dict[:m] = p_dict[:m][to_keep]
    p_dict[:N] = length(to_keep)

    #stressor keywords
    kw_dict = Dict(zip(keys(p_dict[:kw]), values(p_dict[:kw])))
    kw_dict[:γ] = kw_dict[:γ][to_keep]
    kw_dict[:S_ind] = p_dict[:N] + p_dict[:M] + 1

    p_dict[:kw] = NamedTuple(kw_dict)

    p_new = NamedTuple(p_dict)
    
    u0 = deepcopy(sol(sol.t[end]))
    deleteat!(u0, to_rm)
        
    #simulate
    return(sol.prob.f, u0, (0.0,1e6), p_new)
end