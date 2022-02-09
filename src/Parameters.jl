
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
    tox::Array{Float64,1}
end

function random_communty(N,M; toxicity = false)
    u = rand(N,M)
    R = rand(N)
    l = rand(M,M) ./ M
    l_sum = sum(l, dims = 2)[:,1]
    ρ = ones(M)

    tox = fill(false, M)
    if toxicity
        tox[1] = true
    end

    return MiCRMParameter(N,M,u,R,l,l_sum, ρ, tox)
end