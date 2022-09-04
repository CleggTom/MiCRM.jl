"""
    random_params(N,M,leakage)

Generates a parameter set for micrm system with `N` consumers and `M` resources with random parameters. All values are drawn from uniform random distributions apart from uptake (u) and leakage (l) which are drawn from dirchlet distributions. This means overall uptake and leakage sum to 1 and the value set by the leakage parameter respectively. 
"""
function random_params(N::A, M::B, leakage::C) where {A <: Integer, B <: Integer, C <: AbstractFloat}
    @assert 0 <= leakage <= 1

    #uptake
    du = Distributions.Dirichlet(M,1.0)
    u = copy(rand(du, N)')

    #cost term
    m = ones(N)

    #inflow + outflow
    ρ,ω = ones(M),ones(M)

    #leakage
    l = copy(rand(du,M)' .* leakage)

    return (N = N, M = M, u = u, m = m, ρ = ρ, ω = ω, l = l, λ = leakage)
end


# ## Niche Communtiy generation
# begin
#     #square with sign
#     sq_sgn(x) = sign(x) * x^2

#     """
#         euclid_dist(a,b,sign = true)
        
#     calculates the euclidian distance between two sets of ponts a and b. if `sign = true` the sign of the distance is preserved using `x -> sign(x) * x^2`. 
#     """
#     #calculate euclidian distance
#     function euclid_dist(a,b, sign = false)
#         sign ? sum(sq_sgn, a .- b) : sum(abs2, a .- b)
#     end

#     """
#         default_u_func(d, λ = 10)
        
#     Default function to calculate the uptake based on distnace between a resource and consumer in niche space. Function is a negative exponential paramterised by the rate parameter `λ`.
#     """
#     #default u function - negative exponential
#     function default_u_func(d, λ = 10)
#             exp(-λ * d)
#     end

#     """
#         default_l_func(d, threshold = 0.1, `λ` = 10)

#     Default function to calculate the leakage based on distance between a resources in niche space.  Function is a negative exponential paramterised by the rate parameter λ.  Threshold sets the minimum leakage value. 
#     """
#     #default l function - negative exponential
#     function default_l_func(d, threshold = 0.1, λ = 10)
#         (d < 0.0) | (d > threshold) ? 0.0 : exp(-λ * d)
#     end

#     """
#         niche_micrm_params(N,M,leakage,
#             θC::Vector{T}, θR::Vector{T},
#             fu::Function = default_u_func, fl::Function = default_l_func) where T <: Vector{<:Real}

#     Creates a micrm parameter dictionary using the niche model given the postions of resources and conusumers in niche space and a set of functions mapping this to uptake and leakage.  θC and θR are the positions in niche space given as vectors of coordinates (of type array{Float64})

#     """
#     function niche_micrm_params(N,M,leakage,
#             θC::Vector{T}, θR::Vector{T},
#             fu::Function = default_u_func, fl::Function = default_l_func) where T <: Vector{<:Real}

#         #sort niche index
#         indx_C = sortperm(norm.(θC,2))
#         indx_R = sortperm(norm.(θR,2))

#         #calculate consumer resource distance matrix
#         d_u = [euclid_dist(x,y) for x = θC, y = θR][indx_C,indx_R]
#         #caluclate leakage matrix
#         d_l = [-euclid_dist(x,y,true)  for x = θR, y = θR][indx_R,indx_R]

#         #calculate parameters from distance matricies
#         u = fu.(d_u)
#         l = fl.(d_l)

#         #normalise leakage
#         l = leakage * mapslices(x -> x ./ sum(x), l, dims = 2)

#         #get other parameters
#         #cost term
#         m = rand(N)

#         #inflow + outflow
#         ρ = ω = ones(M)

#         return Dict(:N => N, :M => M, :u => u, :m => m, :ρ => ρ, :ω => ω, :l => l)
#     end

#     function niche_micrm_params(N,M,leakage, D; fθ::Function = rand, fu::Function = default_u_func, fl::Function = default_l_func)
#         θC = [fθ(D) for i = 1:N]
#         θR = [fθ(D) for i = 1:M]
#         return(niche_micrm_params(N, M, leakage, θC, θR, fu, fl))
#     end


# end