#generate community 
p = random_micrm_params(5,10,0.5)

#check dimensions
@testset "random_micrm_params dimensions" begin
    @test p[:N] == 5
    @test p[:M] == 10
    @test size(p[:u]) == (5,10)
    @test size(p[:m]) == (5,)
    @test size(p[:ρ]) == (10,)
    @test size(p[:ω]) == (10,)
    @test size(p[:l]) == (10,10)
end

@testset "random_micrm_params values" begin
    @test p[:N] == 5
    @test p[:M] == 10
    @test all(sum(p[:l], dims = 2) .≈ 0.5)
    @test all(sum(p[:u], dims = 2) .≈ 1.0)
end