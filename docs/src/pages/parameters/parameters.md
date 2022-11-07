# Parameters

The `MiCRM.Parameters` sub-module contains functions to automatically generate parameter sets for the MiCRM model. This page will give a general overview of how these functions work and interface with the `Simulation` sub-module.

## Parameters in MiCRM.jl

Parameters in the MiCRM.jl package are all stored in `NamedTuple` objects. This makes them both easy and efficient to access at the small cost that they cannot be modified once created. The parameter sets are split into two parts. First is the set of basic parameters used in the classic MiCRM model. These are directly accessible by from the parameter object (i.e. `p.u`) and used by the default derivative functions (see REF). Second are the optional parameters stored in the `kw`argument within. This second `kw` `NamedTuple` stores additional parameters that may be needed when users make modification to the dynamic equations. The parameters are listed in table below:

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
| ``kw`` | Additional parameters to be used |

## Generating Parameter Sets
MiCRM.jl comes with a convenience function to generate these parameter dictionaries in the form of the `Parameters.generate_params` function. This function takes a set of functions as arguments that dictate the rules by which the various parameters of the model are defined. It then returns them as a `NamedTuple` to be used in the actual simulations. This makes it relatively simple to generate many randomly generated communities when running high numbers of simulations. 

```@docs
Parameters.generate_params
```

There are a few in-built parameter generator functions in MiCRM.jl (see REF) but one can easily specify their own generating functions to determine the rules by which parameter sets are generated.  
