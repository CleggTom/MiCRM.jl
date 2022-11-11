"""
    get_jac(sol)

Numerically calculate jacobian of system from the solution object. Assumes that the system is at equilibrium so the end state is used. 

## Example
TDB
"""
function get_jac(sol)
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

"""
    get_stability(J)

Determine the stability a system given its jaccobian by testing if the real part of the leading eigenvalue is positive. 
"""
function get_stability(J)
    eigvals(J)[end] < 0.0
end

"""
    get_Rins(J, t, w = ones(size(J)[1]))

Caclulate the instantaneous rate of growth of the perturbation u at time t. The observation vector `w` can be optionally supplied to consider linear combinations of the state variables. This can include any linear combination of state variables such as the mass of specific components of the system as well as total functioning measures. 
"""
function get_Rins(J, u, t, w = ones(size(J)[1]))
    tr(J * exp(J * t) * u * w') / tr(exp(J * t) * u * w')
end
    
"""
    get_reactivity(J,u)

Test wether the system is "reactive" to the perturbation `u`. A reactive is system is one where the initial perturbation is amplified so that the deviation from equilibrium initially increases 
"""
function get_reactivity(J,u)
    get_Rins(J, u, 0.0) > 0.0
end

"""
    get_return_rate(J)

get the rate of return of the system from perturbation. This value is determined by the leading eigenvalue regardless of the direction of the perturbation or the observation vector we choose. 
"""
function get_return_rate(J)
    eigvals(J)[end]
end
