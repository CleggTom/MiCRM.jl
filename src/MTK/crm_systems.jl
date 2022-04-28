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
    @assert all([:l,:ρ,:N,:M,:m,:ω,:u] .∈ Ref(collect(keys(p)))) "missing parameters"

    u = ModelingToolkit.toparam(Symbolics.variables(:u, 1:p[:N],1:p[:M]))
    m = ModelingToolkit.toparam(Symbolics.variables(:m, 1:p[:N]))
    ρ = ModelingToolkit.toparam(Symbolics.variables(:ρ, 1:p[:M]))
    ω = ModelingToolkit.toparam(Symbolics.variables(:ω, 1:p[:M]))
    l = ModelingToolkit.toparam(Symbolics.variables(:l, 1:p[:M],1:p[:M]))

    @variables t C[1:p[:N]](t) R[1:p[:M]](t)
    
    D = Differential(t)
    
    eqns = []
    #consumers
    for i = 1:p[:N]
        RHS = -C[i] * m[i] 
        for α = 1:p[:M]
            RHS += C[i] * R[α] * u[i,α] 
            for β = 1:p[:M]
                RHS -= C[i] * R[α] * u[i,α] * l[α,β]
            end
        end
        push!(eqns, D(C[i]) ~ RHS)
    end
    
    #resources
    for α = 1:p[:M]
        RHS = ρ[α] - R[α]* ω[α]
        for i = 1:p[:N]
            RHS -= C[i] * R[α] * u[i,α]
            for β = 1:p[:M]
                RHS += C[i] * R[β] * u[i,β] * l[β,α]
            end
        end
        push!(eqns, D(R[α]) ~ RHS)
    end

    #variables
    vars = vcat(u[:],m,ρ,ω,l[:])
    vals = vcat(p[:u][:],p[:m],p[:ρ],p[:ω],p[:l][:])

    sys = ODESystem(eqns, t; name, defaults = Dict(vars[i] => vals[i] for i = eachindex(vars)))
    return(sys)
end

"""
    update_parameters!(sys, p_new)

updates an `ODESystem` object with new parameters, preventing the need for (expensive) recalucuation of the symbolic represntation of the system. 
"""
function update_parameters!(sys::ODESystem, p_new)
    @assert all([:l,:ρ,:N,:M,:m,:ω,:u] .∈ Ref(collect(keys(p_new)))) "missing parameters"
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