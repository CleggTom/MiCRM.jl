#generate community 
p = random_micrm_params(2,2,0.5)

#convert to ODESystem
@named sys = micrm_system(p)

@testset "MTK system" begin
    @test length(states(sys)) == 4
    @test length(parameters(sys)) == 14
end

#convert to problem
#define starting mass
u0 = fill(0.1, 4)
u0 = [states(sys)[i] => u0[i] for i = eachindex(u0)]

tspan = (0.0, 10.0) #define tspan

prob = ODEProblem(sys,u0,(0.0,100.0),[], jac = true)
sol = solve(prob)