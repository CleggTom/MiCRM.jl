
function growth_MiCRM!(dx, x, p, t, i)

    # maintenance
    dx[i] = -x[i]*p.m[i]

    # resoruce uptake and leakage
    for α = 1:p.M
        dx[i] += x[α + p.N] * x[i] * p.u[i, α]
        for β=1:p.M
            dx[i] += -x[i]*x[α + p.N]*p.u[i, α]*p.l[i, α, β]
        end
    end
end


function supply_MiCRM!(dx, x, p, t, α)

    # inflow - outflow
    dx[α + p.N] = p.ρ[α] - (x[α + p.N] * p.ω[α])

end

function depletion_MiCRM!(dx, x, p, t, i, α)

    # uptake
    dx[α + p.N] += -(x[α + p.N] * p.u[i, α] * x[i])

    # leakage
    for β = 1:p.M
        dx[α + p.N] += x[β + p.N] * x[i] * p.u[i, β] * p.l[i, β, α]
    end
end

function dx!(dx, x, p, t;
    growth!::Function = growth_MiCRM!,
    supply!::Function = supply_MiCRM!,
    depletion!::Function = depletion_MiCRM!)

    for i = 1:p.N
        # reset derivatives
        dx[i] = 0.0

        # if consumer is extant
        if x[i] > 1e-5
            # update dx of ith consumer
            growth!(dx, x, p, t, i)
        end
    end

    for α = 1:p.M
        # reset derivatives
        dx[p.N + α] = 0.0

        #supply term
        supply!(dx, x, p, t, α)

        # loop over consumers
        for i = 1:p.N
            if x[i] > 1e-5
                depletion!(dx, x, p, t, α, i)
            end
        end
    end

end

function dxx!(dx, x, p, t)

    for i =1:p.N
        dx[i] = 0.0
        dx[i] = -p.m[i]*x[i]

        for α = 1:p.M
            dx[i] += x[i]*x[α + p.N]*p.u[i, α]
            for β=1:p.M
                dx[i] += -x[i]*x[α + p.N]*p.u[i, α]*p.l[i, α, β]
            end
        end
    end
    for α = 1:p.M
        dx[α + p.N] = 0.0
        dx[α + p.N] = p.ρ[α] - (x[α + p.N] * p.ω[α])

        for i=1:p.N
            dx[α + p.N] += -p.u[i, α]*x[α+p.N]*x[i]
            for β=1:p.M
                dx[α + p.N] += x[β + p.N] * x[i] * p.u[i, β] * p.l[i, β, α]
            end
        end
    end
end
