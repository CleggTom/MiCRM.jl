
struct MiCRMParameter
    #system size
    N::Int64
    M::Int64
    #consumer traits
    u::Array{Float64,2}
    R::Array{Float64,1}
    #resource traits
    l::Array{Float64,2}
    l_sum::Array{Float64,1}
    ρ::Array{Float64,1}
    ω::Array{Float64,1}
end

function random_communty(N,M)
    u = rand(N,M)
    R = rand(N)
    l = rand(M,M) ./ M
    l_sum = sum(l, dims = 2)[:,1]
    ρ = ones(M)

    return MiCRMParameter(N,M,u,R,l,l_sum, ρ)
end