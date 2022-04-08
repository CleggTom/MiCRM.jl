using MiCRM, Profile

p = MiCRM.random_communty_micrm(10,10)

f = (du,u,p,t) -> MiCRM.du!(du,u,p,t,p.f.mortality, p.f.uptake_con, p.f.inflow, p.f.uptake_res, p.f.leakage)

u0 =rand(20)
f(u0, u0,p,1.0)
@time f(u0, u0,p,1.0)

@time MiCRM.du!(u0,u0,p,1.0,p.f.mortality, p.f.uptake_con, p.f.inflow, p.f.uptake_res, p.f.leakage)