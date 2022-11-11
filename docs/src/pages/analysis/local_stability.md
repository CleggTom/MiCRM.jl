# Local analysis
One question that we often want to ask when considering the dynamics of ecological systems is their response to perturbation. One method to answer such questions is to use local stability analysis where one linearises the system around a fixed point and then studies the dynamics of this linear system to learn about the behaviour of the system as a whole. 

MiCRM.jl includes a number of tools to carry out such analysis including the automatic calculation of the jacobian matricies which define the linearised system as well as some built in functions to determine key properties of interest for the system.

## Calculating the Jacobian
MiCRM.jl automatically calculates the jacobian of a given system using the ForwardDiff.jl package. This provides the automatic-differentiation backend that computes the derivatives of the ODE system at equilibrium. This functionality is all contained within the `Analysis.get_jac(sol)` function.

```@docs
Analysis.get_jac
```

## Dynamic Measures
Once the jacobian has been calculated we can use it to calculate several key properties of interest

```@docs
Analysis.get_Rins
Analysis.get_stability
Analysis.get_reactivity
Analysis.get_return_rate
```
