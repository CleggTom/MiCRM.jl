using MiCRM
using OrdinaryDiffEq

#test jaccobian calculations

#simulate system
p = MiCRM.Parameters.generate_params(1,2,λ = 0.3)
u0 = ones(3)
t_span = (0.0, 1e6)
prob = ODEProblem(MiCRM.Simulations.dx!, u0, t_span, p)
sol = solve(prob, AutoTsit5(Rosenbrock23()), save_everystep = false)

#expected jaccobian
begin
    J_exp = zeros(3,3)
    C = sol[end][1:1]
    R = sol[end][2:end]

    # C -> C
    J_exp[1,1] += -p.m[1]
    for α = 1:p.M
        tmp = 0.0
        for β = 1:p.M
            tmp += p.l[α,β]
        end
            J_exp[1,1] += sol[end][α + p.N] * p.u[1,α] * (1 - tmp)
    end

    # C -> R
    J_exp[1,2] = sol[end][1] * p.u[1,1] * (1 - sum(p.l[1,:]))
    J_exp[1,3] = sol[end][1] * p.u[1,2] * (1 - sum(p.l[2,:]))

    # R -> C
    J_exp[2,1] = -sol[end][2] * p.u[1,1] + sol[end][2] * p.u[1,1] * p.l[1,1] + sol[end][3] * p.u[1,2] * p.l[2,1] 
    J_exp[3,1] = -sol[end][3] * p.u[1,2] + sol[end][2] * p.u[1,1] * p.l[1,2] + sol[end][3] * p.u[1,2] * p.l[2,2] 

    #R -> R
    J_exp[2,2] = -p.ω[1] - p.u[1,1] * sol[end][1] * (1 - p.l[1,1])
    J_exp[2,3] =  p.u[1,2] * sol[end][1] * p.l[2,1]

    J_exp[3,3] = -p.ω[2] - p.u[1,2] * sol[end][1] * (1 - p.l[2,2])
    J_exp[3,2] =  p.u[1,1] * sol[end][1] * p.l[1,2]

end

J_obs = MiCRM.Analysis.get_jacc(sol)

#test that jaccobian calculated is the same as the analytical one
@test all(J_obs .≈ J_exp)

