"""
Function to generate jacobian for MiCRM system of equations

"""

function MiCRM_jac(; p, sol)

    M = p.M
    N = p.N
    λ = p.λ
    l = p.l
    ρ = p.ρ
    ω = p.ω
    m = p.m
    u = p.u

    C = sol[1:N, length(sol)]
    R = sol[(N+1):(N+M), length(sol)]

    Jac = zeros((N+M), (N+M))

    for i in 1:N
        Jac[i, i] = -m[i]
        for α in 1:M
            Jac[i, i] += (1 - λ[i, α])*u[i, α]*R[α]
        end
    end

    for i in 1:N
        for j in (i+1):N
            Jac[i, j] = 0
        end
    end

    for i in 1:N
        for j in (i+1):N
            Jac[j, i] = 0
        end
    end

    for i in 1:N
        for α in (N+1):(N+M)
            Jac[i, α] = C[i]*(1-λ[i, α-N])*u[i, α-N]
        end
    end

    for α in (N+1):(N+M)
        Jac[α, α] = -ω[α-N]
        for i in 1:N
            Jac[α, α] += C[i]*u[i, α-N]*(l[i, α-N, α-N] - 1)
        end
    end

    for α in (N+1):(N+M)
        for i in 1:N
            Jac[α, i] = -u[i, α-N]*R[α-N]
            for β in 1:M
                Jac[α, i] += l[i, β, α-N]*u[i, β]*R[β]
            end
        end
    end

    for α in (N+1):(N+M)
        for β in (N+1):(α-1)
            for i in 1:N
                Jac[α, β] += l[i, β-N, α-N]*u[i, β-N]*C[i]
            end
        end
    end

    for α in (N+1):(N+M)
        for β in (α+1):(N+M)
            for i in 1:N
                Jac[α, β] += l[i, β-N, α-N]*u[i, β-N]*C[i]
            end
        end
    end

    return(Jac)

end
