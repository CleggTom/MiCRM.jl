#defaults
default_m(N,M,kw) = ones(N)
default_ρ(N,M,kw) = ones(M) * M
default_ω(N,M,kw) = ones(M)
default_u(N,M,kw) = copy(rand(Distributions.Dirichlet(M,1.0), N)')
default_l(N,M,kw) = copy(rand(Distributions.Dirichlet(M,1.0), M)') .* kw[:λ]

function generate_params(N,M;f_m = default_m, f_ρ = default_ρ, f_ω = default_ω, f_u = default_u, f_l = default_l, kwargs...)
    kw = Dict{Symbol,Any}(kwargs)
    #consumers
    m = f_m(N,M,kw)
    #resources
    ρ = f_ρ(N,M,kw)
    ω = f_ω(N,M,kw)
    #uptake & leakage
    u = f_u(N,M,kw)
    l = f_l(N,M,kw)
    λ = sum(l, dims = 2)[1]

    return (N = N, M = M, u = u, m = m, ρ = ρ, ω = ω, l = l, λ = λ, kw = NamedTuple(zip(keys(kwargs),values(kwargs))))
end

#uptake functions
function modular_uptake(N,M; N_clusters = 2, s_ratio = 10.0)
       @assert N_clusters <= M
    
    #cluster  sizes for consumers and resources
    cluster_C = N ÷ N_clusters
    cluster_R = M ÷ N_clusters

    #preallocate uptake matrix
    u = zeros(N,M)

    #loop over clusters
    for g = 1:N_clusters
        indx_C = 1 + (g-1)*cluster_C : cluster_C + (g-1)*cluster_C
        indx_R = 1 + (g-1)*cluster_R : cluster_R + (g-1)*cluster_R

        if g == N_clusters
            indx_C = 1 + (g-1)*cluster_C : N
            indx_R = 1 + (g-1)*cluster_R : M
        end

        #calculate prob vec
        a_vec = ones(M)
        a_vec[indx_R] .*= s_ratio

        d = Dirichlet(a_vec)
        x = rand(d, length(indx_C))
        # println(indx_C, size(x')," ",size(u))

        u[indx_C, :] .= x'
    end
    
    return(u)
end

modular_uptake(N,M,kw::Dict{Symbol, Any}) = modular_uptake(N,M,N_clusters = kw[:N_clusters], s_ratio = kw[:s_ratio]) 

function modular_leakage(M; N_clusters = 2, s_ratio = 10.0, λ = 0.5)
    @assert N_clusters <= M
    
    #cluster  sizes for consumers and resources
    cluster_R = M ÷ N_clusters

    #preallocate leakage matrix
    l = ones(M,M)

    #loop over clusters
    for g = 1:N_clusters
        for h = 1:N_clusters
            indx_R1 = 1 + (g-1)*cluster_R : (g == N_clusters ? M : cluster_R + (g-1)*cluster_R)
            indx_R2 = 1 + (h-1)*cluster_R : (h == N_clusters ? M : cluster_R + (h-1)*cluster_R)

            if h == g+1 || h == g
                #calculate prob vec
                l[indx_R1, indx_R2] .*= s_ratio
            end
        
        end
    end

    for i = 1:M
        l[i,:] = rand(Dirichlet(l[i,:]), 1)
    end

    return(l .* λ)
end

modular_leakage(N,M,kw::Dict{Symbol, Any}) = modular_leakage(M; N_clusters = kw[:N_clusters], s_ratio = kw[:s_ratio], λ = kw[:λ])


# # ## Niche Communtiy generation
# # begin
# #     #square with sign
# #     sq_sgn(x) = sign(x) * x^2

# #     """
# #         euclid_dist(a,b,sign = true)
        
# #     calculates the euclidian distance between two sets of ponts a and b. if `sign = true` the sign of the distance is preserved using `x -> sign(x) * x^2`. 
# #     """
# #     #calculate euclidian distance
# #     function euclid_dist(a,b, sign = false)
# #         sign ? sum(sq_sgn, a .- b) : sum(abs2, a .- b)
# #     end

# #     """
# #         default_u_func(d, λ = 10)
        
# #     Default function to calculate the uptake based on distnace between a resource and consumer in niche space. Function is a negative exponential paramterised by the rate parameter `λ`.
# #     """
# #     #default u function - negative exponential
# #     function default_u_func(d, λ = 10)
# #             exp(-λ * d)
# #     end

# #     """
# #         default_l_func(d, threshold = 0.1, `λ` = 10)

# #     Default function to calculate the leakage based on distance between a resources in niche space.  Function is a negative exponential paramterised by the rate parameter λ.  Threshold sets the minimum leakage value. 
# #     """
# #     #default l function - negative exponential
# #     function default_l_func(d, threshold = 0.1, λ = 10)
# #         (d < 0.0) | (d > threshold) ? 0.0 : exp(-λ * d)
# #     end

# #     """
# #         niche_micrm_params(N,M,leakage,
# #             θC::Vector{T}, θR::Vector{T},
# #             fu::Function = default_u_func, fl::Function = default_l_func) where T <: Vector{<:Real}

# #     Creates a micrm parameter dictionary using the niche model given the postions of resources and conusumers in niche space and a set of functions mapping this to uptake and leakage.  θC and θR are the positions in niche space given as vectors of coordinates (of type array{Float64})

# #     """
# #     function niche_micrm_params(N,M,leakage,
# #             θC::Vector{T}, θR::Vector{T},
# #             fu::Function = default_u_func, fl::Function = default_l_func) where T <: Vector{<:Real}

# #         #sort niche index
# #         indx_C = sortperm(norm.(θC,2))
# #         indx_R = sortperm(norm.(θR,2))

# #         #calculate consumer resource distance matrix
# #         d_u = [euclid_dist(x,y) for x = θC, y = θR][indx_C,indx_R]
# #         #caluclate leakage matrix
# #         d_l = [-euclid_dist(x,y,true)  for x = θR, y = θR][indx_R,indx_R]

# #         #calculate parameters from distance matricies
# #         u = fu.(d_u)
# #         l = fl.(d_l)

# #         #normalise leakage
# #         l = leakage * mapslices(x -> x ./ sum(x), l, dims = 2)

# #         #get other parameters
# #         #cost term
# #         m = rand(N)

# #         #inflow + outflow
# #         ρ = ω = ones(M)

# #         return Dict(:N => N, :M => M, :u => u, :m => m, :ρ => ρ, :ω => ω, :l => l)
# #     end

# #     function niche_micrm_params(N,M,leakage, D; fθ::Function = rand, fu::Function = default_u_func, fl::Function = default_l_func)
# #         θC = [fθ(D) for i = 1:N]
# #         θR = [fθ(D) for i = 1:M]
# #         return(niche_micrm_params(N, M, leakage, θC, θR, fu, fl))
# #     end


# # end