"""
    lb(x,δ)

Convienience function to check for population extinction at theshold θ.
"""
lb(x,δ) = IfElse.ifelse(x < δ, 0, 1)

"""
    micrm_system(p, δ = 1e-6; name)
    
Returns a microbial consumer resource system given a dictionary of parameters. δ sets the lower threshold populations size for extinction (set to 1e-6 by default).
"""
function micrm_system(p, δ = 1e-6; name)
    @assert all([:l,:ρ,:N,:M,:R,:ω,:u] .∈ Ref(collect(keys(p)))) "missing parameters"

    u = ModelingToolkit.toparam(Symbolics.variables(:u, 1:p[:N],1:p[:M]))
    R = ModelingToolkit.toparam(Symbolics.variables(:R, 1:p[:N]))
    ρ = ModelingToolkit.toparam(Symbolics.variables(:ρ, 1:p[:M]))
    ω = ModelingToolkit.toparam(Symbolics.variables(:ω, 1:p[:M]))
    l = ModelingToolkit.toparam(Symbolics.variables(:l, 1:p[:M],1:p[:M]))

    @variables t x[1:p[:N]](t) y[1:p[:M]](t)
    
    D = Differential(t)
    
    eqns = []
    #consumers
    for i = 1:p[:N]
        RHS = -x[i] * R[i] 
        for j = 1:p[:M]
            RHS += x[i] * y[j] * u[i,j] 
            for k = 1:p[:M]
                RHS -= x[i] * y[j] * u[i,j] * l[j,k]
            end
        end
        push!(eqns, D(x[i]) ~ RHS)
    end
    
    #resources
    for j = 1:p[:M]
        RHS = ρ[j] - y[j]* ω[j]
        for i = 1:p[:N]
            RHS -= x[i] * y[j] * u[i,j]
            for k = 1:p[:M]
                RHS += x[i] * y[k] * u[i,k] * l[k,j]
            end
        end
        push!(eqns, D(y[j]) ~ RHS)
    end

    #variables
    vars = vcat(u[:],R,ρ,ω,l[:])
    vals = vcat(p[:u][:],p[:R],p[:ρ],p[:ω],p[:l][:])

    sys = ODESystem(eqns, t; name, defaults = Dict(vars[i] => vals[i] for i = eachindex(vars)))
    return(sys)
end

"""
    update_parameters!(sys, p_new)

updates an `ODESystem` object with new parameters, preventing the need for (expensive) recalucuation of the symbolic represntation of the system. 
"""
function update_parameters!(sys::ODESystem, p_new)
    @assert all([:l,:ρ,:N,:M,:R,:ω,:u] .∈ Ref(collect(keys(p_new)))) "missing parameters"
    @assert (p_new[:N] + p_new[:M]) ==  length(states(sys)) "system size is different"

    #overwrite defaults
    for (k,v) in p_new
        if k ∉ [:N, :M]
            for I = CartesianIndices(v)
                if length(I) == 1
                    sys.defaults[ModelingToolkit.toparam(Symbolics.variables(k,I[1]))[1]] = v[I]
                elseif length(I) == 2
                    sys.defaults[ModelingToolkit.toparam(Symbolics.variables(k,I[1],I[2]))[1]] = v[I]
                else
                    error("$k has wrong dimensions")
                end
            end
        end
    end
end

# function update_parameters!(prob::ODEProblem,sys::ODESystem, p_new)

# end