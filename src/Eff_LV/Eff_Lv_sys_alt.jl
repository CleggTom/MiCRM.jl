"""
This function calculates the Effective Lotka-Volterra
System of ODEs. It only requires the parameters supplied
by Eff_LV_params().

"""

function EFF_LV_sys(; name, p_lv)
## Checks that all necessary parameters have been supplied
    @assert all([:ℵ, :r, :N] .∈ Ref(collect(keys(p_lv))))

## Loads in size of system N, and converts the interaction matrix
# and intrinsic growth rates to symbolic variables for MTK.
    N = p_lv[:N]
    ℵ = ModelingToolkit.toparam(Symbolics.variables(:ℵ, 1:N, 1:N))
    r = ModelingToolkit.toparam(Symbolics.variables(:r, 1:N))

## We define our state variables
    sts = @variables t C[1:N](t)

## We define a function for d/dt
    D = Differential(t)

## Initialize equations
    eqns = []

## Iterate terms and construct symbolic system of ODEs
    for i in 1:N
        RHS = r[i]*C[i]
        for j in 1:N
            RHS += C[i]*ℵ[i, j]*C[j]
        end
        push!(eqns, D(C[i]) ~ RHS)
    end

## Concactenate parameters and default values into tuples
    vars = vcat(ℵ[:], r)
    vals = vcat(p_lv[:ℵ][:], p_lv[:r])

## Build ODESystem using existing parameters as defaults
    sys = ODESystem(eqns, t; name, defaults = Dict(vars[i] => vals[i] for i = eachindex(vars)))

    return(sys)
end
