
function eq_t_cal(sol)
    t = 0.0
    while norm(sol(t, Val{1})) > 1e-5
        t += 1
    end

    return t
end
