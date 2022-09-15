# """
#     coalesce_communities(p1::Dict,p2::Dict)
    
#     Coalecsce two communities by combining their parameter dictionaries. Also returns an additional vector giving the ancestral community of each consumer. 

# """
# function coalesce_communities(p1::Dict,p2::Dict)
#     #assertions
#     @assert keys(p1) == keys(p2) "provided parameters have different keys"
#     @assert p1[:M] == p2[:M] "provided systems have different resource environments"
#     @assert p1[:l] == p2[:l] "provided systems have different resource environments"

#     #Parent Community Vector
#     parent_vec = [i > p1[:N] ? 2 : 1 for i = 1:(p1[:N]+p2[:N])]

#     param = Dict(:N => p1[:N] + p2[:N],
#         :M => p1[:M],
#         :u => vcat(p1[:u],p2[:u]),
#         :m => vcat(p1[:m],p2[:m]),
#         :ρ => p1[:ρ], :ω => p1[:ω], :l => p1[:l],
#         :par => parent_vec)
    
#     return(param)
# end

# """
#     coalesce_communities(p1::micrm_params, p2::micrm_params)

#     Coalecsce two communities from their `micrm_params` objects.
# """
# function coalesce_communities(p1::micrm_params, p2::micrm_params)
#     micrm_params(p1.N + p2.N,
#         p1.M, 
#         vcat(p1.u,p2.u),
#         vcat(p1.m,p2.m),
#         p1.ρ,p1.ω,p1.l)
# end