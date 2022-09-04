<!-- ```@meta
CurrentModule = MiCRM
``` -->

# Parameters

The `MiCRM.Parameters` sub-module contains functions to automatically generate parameter sets for the MiCRM model. This page will detail the algorithms used to generate parameter combinations in the package. For the standard form of the MiCRM model they will return a `NamedTuple` with parameters listed in table below:

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


```@autodocs
Modules = [MiCRM]
```