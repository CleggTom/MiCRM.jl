"""
   micrm_params

   Type containing parameters for micrm simulations

    # Arguments
    N::Int64 - number of consumers
    M::Int64 - number of resources
    u::Matrix{Float64} - uptake matrix
    R::Vector{Float64} - consumer respiration/loss vector
    ρ::Vector{Float64} - resource inflow vector
    ω::Vector{Float64} - resource outflow vector
    l::Matrix{Float64} - leakage matrix
"""
struct micrm_params
        N::Int64
        M::Int64
        u::Matrix{Float64}
        R::Vector{Float64}
        ρ::Vector{Float64}
        ω::Vector{Float64}
        l::Matrix{Float64}
end

"""
    micrm_params(p::Dict{Symbol,Any})

    constructor function to convert parameter dictionary into `micrm_params` object. The parameter dictionary must have the following fields: `[:l,:ρ,:N,:M,:R,:ω,:u]`
"""
function micrm_params(p::Dict{Symbol,Any})
    micrm_params(p[:N],p[:M],p[:u],p[:R],p[:ρ],p[:ω],p[:l])
end

"""
    dx!(dx,x,p,t)

    Derivative function to simulate the micrm directly from a set parameters. To be used to generate an `ODEProblem` object. 
"""
@views function dx!(dx,x,p,t)
    for i = 1:p.N #consumer
        dx[i] = -x[i] * p.R[i] #loss term
        for j = 1:p.M
            dx[i] += x[i] * x[j + p.N] * p.u[i,j] #uptake
            for k = 1:p.M
                dx[i] += -x[i] * x[j + p.N] * p.u[i,j] * p.l[j,k] #leakage
            end
        end
    end

    for j = 1:p.M #resource
        dx[j + p.N] = p.ρ[j] - (x[j + p.N] * p.ω[j])
        for i = 1:p.N
            dx[j + p.N] += -x[j + p.N] * x[i] * p.u[i,j]
            for k = 1:p.M
                dx[j + p.N] += x[k + p.N] * x[i] * p.u[i,k] * p.l[k,j]
            end
        end
    end
end

