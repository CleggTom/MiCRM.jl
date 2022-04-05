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
        push!(eqns, D(x[i]) ~ RHS * lb(x[i],δ))
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