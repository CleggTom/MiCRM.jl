"""
This function is used in the DiffEq integrator to generate the ODEProblem
for the effective LV system using a given set of parameters.

"""

function growth_LV!(dx, x, p, t, i)

    dx[i] += p.r[i]*x[i]

    for j =1:p.N
        dx[i] += x[i]*p.ℵ[i, j]*x[j]
    end
end



function LV_dx!(dx, x, p, t;
    growth!::Function = growth_LV!)

    for i =1:p.N
        dx[i] = 0.0

        if x[i] > eps(x[i])
            growth!(dx, x, p, t, i)
        end
    end
end
