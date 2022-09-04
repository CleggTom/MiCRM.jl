


# """
#     dict_to_struct(p, name = "params")   

# Creates a new type with parameters and types from the given dictionary 'p'. The 
# """
# function dict_to_struct(p, name = "params")   
#     k_vec = collect(keys(p))
#     v_vec = [p[k] for k = k_vec]
#     types = [typeof(p[k]) for k = k_vec]
#     fields = [:( $(k_vec[i])::$(types[i]) ) for i in eachindex(k_vec)]
    
#     name_symb = Symbol(name)

#     @eval begin
#         struct $name_symb
#             $(fields...)
#         end

#         return($name_symb($v_vec...))
#     end
# end

# function struct_to_dict(p)
#     k_vec = fieldnames(typeof(p))
#     return( Dict(k => getfield(p, k) for k = k_vec) )
# end

