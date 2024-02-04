using MPI, MPIClusterManagers, Distributed

man = MPIManager(np = 4);

addprocs(man);

@everywhere using LinearAlgebra, Elemental, DistributedArrays, MPI

const M = 4
const N = M

@mpi_do man M = @fetchfrom 1 M
@mpi_do man N = @fetchfrom 1 N

const Ahost = rand(Float64, M, N)

@mpi_do man Aall = @fetchfrom 1 Ahost

@mpi_do man A = Elemental.DistMatrix(Float64);

@mpi_do man A = Elemental.zeros!(A, M, N);

@mpi_do man copyto!(A, Aall)
@mpi_do man DA = convert(DArray, A)

@mpi_do man println(A)
@mpi_do man println(DA)

const DA1 = dzeros(Float64, (M, N), sort(workers()))
@mpi_do man DA1 = @fetchfrom 1 DA1
@mpi_do man println(localindices(DA1))

@mpi_do man Elemental.copyto!(DA1, A)
@mpi_do man println(DA1)


using Test
@testset "dist matrix to darray" begin
end
