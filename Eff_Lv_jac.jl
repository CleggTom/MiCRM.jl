"""

Function to calculate the jacobian of an effective Lotka-Volterra
System. Takes in parameter dictionary from Eff_LV_params and an
optional solution for equilibrium values to find lenarization near
steady state.

"""

function Eff_Lv_Jac(;name, p_lv, symbolic = false, sol = nothing)
## Checks that all necessary parameters have been supplied
    @assert all([:ℵ, :r, :N] .∈ Ref(collect(keys(p_lv))))

## Loads in size of system N, and converts the interaction matrix
# and intrinsic growth rates to symbolic variables for MTK.
    N = p_lv[:N]
    ℵ = ModelingToolkit.toparam(Symbolics.variables(:ℵ, 1:N, 1:N))
    r = ModelingToolkit.toparam(Symbolics.variables(:r, 1:N))

## We define our state variables
    sts = @variables t C[1:N](t)

    if sol != nothing
        C = sol[1:N, length(sol)]
    end

    LV_Jac = zeros(Num, N, N)

    for i in 1:N
        LV_Jac[i, i] = r[i] + 2*ℵ[i, i]*C[i]
        for j in 1:N
            if j != i
                LV_Jac[i, i] += ℵ[i, j]*C[j]
            end
        end
    end

    for i in 1:N
        for j in (i+1):N
            LV_Jac[i, j] = ℵ[i, j]*C[i]
        end
    end

    for i in 1:N
        for j in (i+1):N
            LV_Jac[j, i] = ℵ[j, i]*C[i]
        end
    end

    if symbolic == false
        vals= vcat(p_lv[:r], p_lv[:ℵ][:])
        vars = vcat(r, ℵ[:])

        pmap = [param =>p for (param,p) in zip(vars, vals)]
        LV_Jac = substitute.( LV_Jac, (pmap,))
        LV_Jac = Symbolics.value.(LV_Jac)
    end

    return(LV_Jac)

end
