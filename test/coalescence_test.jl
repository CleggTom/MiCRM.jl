p1 = random_micrm_params(2,2,0.5)

p2 = deepcopy(p1)
p2[:u] = rand(2,2) 
p2[:R] = rand(2)

p_coal = coalesce_communities(p1,p2)

@testset "coalescence dictionary" begin
    @test p_coal[:N] == 4
    @test p_coal[:M] == 2
end
