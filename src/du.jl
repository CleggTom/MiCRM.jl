function du!(du,u,p,t)
    for i = eachindex(du)
        #resources
        if i < p.N + 1
            #respiration
            du[i] = u[i] * -p.R[i]
            #uptake
            for j = 1:p.M
                du[i] += u[i] * u[p.N + j] * p.u[i,j] * (1 - p.l_sum[j])
            end
        #consumers
        else
            #inflow
            du[i] = p.ρ[i - p.N] - u[i] * p.ω[i - p.N]
            #loop over consumers
            for j = 1:p.N
                #uptake of i by consumers j
                du[i] -= u[j] * u[i] * p.u[j, i - p.N]
                for k = 1:p.M
                    #leakage from k to i by j
                    du[i] += u[k + p.N] * u[j] * p.u[j,k] * p.l[k,i - p.N]
                end
            end
        end
    end
end