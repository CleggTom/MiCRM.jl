"""
   micrm_params

   Type containing parameters for micrm simulations

    # Arguments
    N::Int64 - number of consumers
    M::Int64 - number of resources
    u::Matrix{Float64} - uptake matrix
    m::Vector{Float64} - consumer respiration/loss vector
    ρ::Vector{Float64} - resource inflow vector
    ω::Vector{Float64} - resource outflow vector
    l::Matrix{Float64} - leakage matrix
"""
struct micrm_params
        N::Int64
        M::Int64
        u::Matrix{Float64}
        m::Vector{Float64}
        ρ::Vector{Float64}
        ω::Vector{Float64}
        l::Matrix{Float64}
end

"""
    micrm_params(p::Dict{Symbol,Any})

    constructor function to convert parameter dictionary into `micrm_params` object. The parameter dictionary must have the following fields: `[:l,:ρ,:N,:M,:R,:ω,:u]`
"""
function micrm_params(p::Dict{Symbol,Any})
    micrm_params(p[:N],p[:M],p[:u],p[:m],p[:ρ],p[:ω],p[:l])
end

"""
    dx!(dx,x,p,t)

    Derivative function to simulate the micrm directly from a set parameters. To be used to generate an `ODEProblem` object. 
"""
@views function dx!(dx,x,p,t)
    for i = 1:p.N #consumer
        dx[i] = -x[i] * p.m[i] #loss term
        for α = 1:p.M
            dx[i] += x[i] * x[α + p.N] * p.u[i,α] #uptake
            for β = 1:p.M
                dx[i] += -x[i] * x[α + p.N] * p.u[i,α] * p.l[α,β] #leakage
            end
        end
    end

    for α = 1:p.M #resource
        dx[α + p.N] = p.ρ[α] - (x[α + p.N] * p.ω[α])
        for i = 1:p.N
            dx[α + p.N] += -x[α + p.N] * x[i] * p.u[i,α]
            for β = 1:p.M
                dx[α + p.N] += x[β + p.N] * x[i] * p.u[i,β] * p.l[β,α]
            end
        end
    end
end

