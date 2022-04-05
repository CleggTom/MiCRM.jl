"""
    random_micrm_params(N,M,leakage)

    Generates a parameter dictionary for micrm system with `N` consumers and `M` resources with random parameters. All values are drawn from uniform random distributions apart from uptake (u) and leakage (l) which are drawn from dirchlet distributions. This means overall uptake and leakage sum to 1 and the value set by the leakage parameter respectively. 
"""
function random_micrm_params(N,M,leakage)
    #uptake
    du = Distributions.Dirichlet(M,1.0)
    u = rand(du, N)'

    #respiration
    R = rand(N)

    #inflow + outflow
    ρ,ω = rand(M),rand(M)

    #leakage
    l = rand(du,M)' .* leakage

    return Dict(:N => N, :M => M, :u => u, :R => R, :ρ => ρ, :ω => ω, :l => l)
end
