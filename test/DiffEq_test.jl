p = random_micrm_params(2,2,0.5)

#convert to micrm_params
p_struct = micrm_params(p)

u0 = ones(4)
tspan = (0.0,1.0)
prob = ODEProblem(MiCRM.dx!,u0,tspan,p_struct)
sol = solve(prob)