"""
Function for calculating effective Lotka-Volterra parameters.
It is necessary to supply the parameters p and an ODEProbelm
solution containing equilibrium values for the system in
question. verbose = true allows the function to return the
partial derivative vector as well as the A matrix.

"""

function Eff_LV_params(; p, sol, verbose = false)

## Parameters are unpacked from dictionary and loaded into variables
    M = p.M
    N = p.N
    l = p.l
    ρ = p.ρ
    ω = p.ω
    m = p.m
    u = p.u
    λ = p.λ

## We define a Kroenecker delta function
    δ(x, y) = ==(x, y)

## Equilibrium values are loaded into their respective vectors
    Ceq = sol[1:N, length(sol)]
    Req = sol[(N+1):(N+M), length(sol)]

## LV parameters are initialized
    A = zeros(M, M) # A matrix
    ∂R = zeros(M, N) # Partial derivative vector
    ℵ = zeros(N, N) # Interaction matrix
    O = zeros(N) # Dummy variable for calculating r
    P = zeros(N) # Dummy variable for calculating r
    r = zeros(N) # Effective growth rates

## Calculating the A matrix from MiCRM parameters and equilibrium
## solutions
    for α in 1:M
        for β in 1:M
            A[α, β] = -ω[α]
            for i in 1:N
                A[α, β] += l[i, α, β] * u[i, β] * Ceq[i] -
                u[i, β] * Ceq[i] * δ(α, β)
            end
        end
    end

## Calculating partial derivatives of eq resources with respect
## to consumers
    for α in 1:M
        for j in 1:N
            for β in 1:M
                for γ in 1:M
                    ∂R[α, j] += inv(A)[α, β] * u[j, β] * Req[γ]*(δ(β, γ)
                    - l[j, β, γ])
                end
            end
        end
    end

## Calculating interaction matrix
    for i in 1:N
        for j in 1:N
            for α in 1:M
                ℵ[i, j] += u[i, α]*(1 - λ[i, α]) * ∂R[α, j]
            end
        end
    end

## Calculating components of the intrinsic growth rates
    for i in 1:N
        for α in 1:M
            O[i] += u[i, α]*(1 - λ[i, α])*Req[α]
        end
    end

    for i in 1:N
        for j in 1:N
            P[i] += ℵ[i, j]*Ceq[j]
        end
    end

## Calculating effective intrinsic growth rates
    for i in 1:N
        r[i] = O[i] - P[i] -m[i]
    end

## Check verbose value and return corresponding parameter dictionary
    if verbose == false
        return (ℵ = ℵ, r = r, N = N)
    else
        return (ℵ = ℵ, r = r, N = N, ∂R = ∂R, A = A)
    end
end
