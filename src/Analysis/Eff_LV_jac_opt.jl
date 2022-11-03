"""

Function to calculate the jacobian of an effective Lotka-Volterra
System. Takes in parameter dictionary from Eff_LV_params and an
optional solution for equilibrium values to find lenarization near
steady state.

"""

function Eff_Lv_Jac(; p_lv, sol)
## Checks that all necessary parameters have been supplied

## Loads in size of system N, and converts the interaction matrix
# and intrinsic growth rates to symbolic variables for MTK.
    N = p_lv.N
    ℵ = p_lv.ℵ
    r = p_lv.r

## We define our state variables
    C = sol[1:N, length(sol)]

    LV_Jac = zeros(N, N)

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

    return(LV_Jac)

end
