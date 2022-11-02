using MiCRM
using Test

@time begin
    using MiCRM
    p = MiCRM.Parameters.generate_params(10,10,λ = 0.3)
    u0 = ones(20)
    t_span = (0.0, 100.0)
    prob = ODEProblem(MiCRM.Simulations.dx!, u0, t_span, p)
    sol = solve(prob, AutoTsit5(Rosenbrock23()))
end