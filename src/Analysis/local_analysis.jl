"""
    get_jacc(sol)

Numerically calculate jacobian of system from the solution object. Assumes that the system is at equilibrium so the end state is used. 
"""
function get_jacc(sol)
    #assert equilibrium
    all(abs.(sol(sol.t[end], Val{1})) .< eps())

    function f(x)
        dx = similar(x)
        dx .= 0.0
        # MiCRM.Simulations.dx!(dx,x,p,1.0)
        deriv = SciMLBase.unwrapped_f(sol.prob.f)
        deriv(dx,x,sol.prob.p,1.0)
        return(dx)
    end

    ForwardDiff.jacobian(f, sol[end])
end