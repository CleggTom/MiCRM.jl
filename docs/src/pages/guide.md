# Basic Usage
## Introduction
This page will guide you through simulating microbial consumer resource models (MiCRMs) including community parameter generation. In general simulation of microbial communities in `MiCRM.jl` are done in three steps:

1. Generate community parameters
2. Define system dynamics
3. Simulate system

This guide will walkthrough the simulation of the basic MiCRM model given by the set of equations:

```math
\begin{aligned}
    \frac{dC_i}{dt} &= \sum_{\alpha = 0}^{M} C_i R_{\alpha} u_{i\alpha}  (1 - \lambda_{\alpha}) - C_i m_i \\
    \frac{dR_\alpha}{dt} &= \rho_{\alpha} - R_{\alpha} \omega_{\alpha} - \sum_{i = 0}^{N} C_i R_{\alpha} u_{i\alpha} + \sum_{i = 0}^{N} \sum_{\beta = 0}^{M} C_i R_{\beta} u_{i \beta} l_{\beta \alpha}
\end{aligned}
```

with parameters:

| Parameter    	| Description                                                                  	| Key  	|
|--------------	|------------------------------------------------------------------------------	|------	|
| ``C_i``      	| Biomass of the ``i``th consumer                                              	| -    	|
| ``R_{\alpha}``| Mass of the ``\alpha``th resource                                             | -    	|
| ``N``        	| Number of consumer populations                                               	| `N` 	|
| ``M``        	| Number of resources                                                          	| `M` 	|
| ``u_{i \alpha}``| Uptake rate of the ``\alpha``th resource  by the `i`th consumer             | `u` 	|
| ``m_i``      	| Loss term for the ``i``th consumer                                           	| `m` 	|
| ``\rho_{\alpha}``| Inflow rate for the ``\alpha``th resource                                  | `ρ` 	|
| ``\omega_{\alpha}``| Outflow term for the ``j``resource                                       | `ω` 	|
| ``l_{\alpha \beta}``| Proportion of uptake of the ``\alpha``th resource leaked to the ``\beta``th resource.| `l` 	|
| ``\lambda_{\alpha}``| Total proportion of the ``\alpha``th resource leaked, same as ``\sum_{\beta} l_{\alpha,\beta}``|  `λ` |

## Generating Community Parameters

The first step of any simulation is to generate a set of parameters for a given microbial community. `MiCRM.jl` stores all parameters in `NamedTuples` which are immutable making them fast (cannot be altered once created) and (as the name would suggest) indexable by name allowing for easy construction of derivative function. In this example we will consider a simple unstructured community where uptake and leakage values are randomly drawn from a dirchlet distribution and all other parameters are set to 1:

```
    using Distributions

    #set system size and leakage
    N,M,leakage = 10,10,0.3

    #uptake
    du = Distributions.Dirichlet(N,1.0)
    u = copy(rand(du, M)')

    #cost term
    m = ones(N)

    #inflow + outflow
    ρ,ω = ones(M),ones(M)

    #leakage
    l = copy(rand(du,M)' .* leakage)

    param = (N = N, M = M, u = u, m = m, ρ = ρ, ω = ω, l = l, λ = leakage)
```

In practice it is much more convenient to wrap this in a function. `MiCRM.jl` comes with several such functions (see XXX) to generate communities under different assumptions including the random case above. These functions are accessible in the `MiCRM.Parameters` submodule. The code to generate a random community thus becomes:

```
    using MiCRM

    #set system size and leakage
    N,M,leakage = 10,10,0.3

    #generate community parameters
    param = MiCRM.Parameters.random_params(N,M,leakage)
```

You can of course define their own function to generate communities, the only requirements being that it returns a `NamedTuple` object with the correct fields (see XXX for more detail). 

## Defining System Dynamics

Once we have a set of parameters the next step is to define the dynamics of the community we want to simulate. `MiCRM.jl` allows the user to specify the  dynamics of the system they wish to simulate by passing custom functions to the `MiCRM.Simulations.dx!` function. This process is explained in more detail XXX but briefly the user can specify dynamics depending on the parameters created in the previous step as well as additional state variables to represent external drivers such as temperature. In this example we will use the default dynamics as described above and so we can just use the `MiCRM.Simulations.dx!` out of the box. 

## Simulation

Once we have the parameters and the derivative equation we are ready to simulate the system and integrate through time. `MiCRM.jl` relies heavily on the brilliant `DifferentialEquations.jl` to do the numerical integration and it is worth having a look at the docs to get an idea of what is going on under the hood in your simulations. The simulation procedure is fairly straightforward and just requires that we first create an `ODEProblem` object which defines the problem for the ODE solver and then solve it with the aptly named `solve` function. `MiCRM.jl` imports a lightweight version of the `DifferentialEquations.jl` package to use so these functions are available when we run `using MiCRM`. To define the `ODEProblem` we need to specify the initial state of the system as well as the timespan we want to simulate over:

```
    #inital state
    x0 = ones(N+M)
    #time span
    tspan = (0.0, 10.0)

    #define problem
    prob = ODEProblem(MiCRM.Simulations.dx!, x0, tspan, param)
    sol = solve(prob, Tsit5())
```

## Analysis

Once the simulation is done 