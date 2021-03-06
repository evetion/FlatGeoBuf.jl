using Test
using FlatGeobuf
using FlatBuffers
using Tables
using TypedTables

@testset "FlatGeobuf" begin
    fna = "countries.fgb"
    fnb = "UScounties.fgb"
    isfile(fna) || download("https://github.com/bjornharrtell/flatgeobuf/blob/master/test/data/countries.fgb?raw=true", fna)
    isfile(fnb) || download("https://github.com/bjornharrtell/flatgeobuf/blob/master/test/data/UScounties.fgb?raw=true", fnb)

    @testset "Construction" begin
        crs = FlatGeobuf.Crs("epsg", 28992, "RD New", "Dutch grid", "proj+=asdas", "codestring")
        h = FlatGeobuf.Header(name="test", crs=crs)
        g = FlatGeobuf.Geometry()
    end

    @testset "Serializing and parsing" begin
        crs = FlatGeobuf.Crs("epsg", 28992, "RD New", "Dutch grid", "proj+=asdas", "codestring")
        h = FlatGeobuf.Header(name="test", crs=crs)

        # Write header
        open("example.bin", "w") do f FlatBuffers.serialize(f, h) end
        # Read header again
        nh = open("example.bin", "r") do f
            FlatBuffers.deserialize(f, FlatGeobuf.Header)
        end

        # Assert it's similar
        @test h.crs.wkt == nh.crs.wkt
    end

    @testset "Using testfiles" begin
        fgb = FlatGeobuf.read_file(fnb)
        features = collect(fgb)
        @test length(features) == 3221

        filter!(fgb, [-92.73405699999999, 32.580974999999995, -92.73405699999999, 32.580974999999995])
        features = collect(fgb)
        @test length(features) == 2

        fgb = FlatGeobuf.read_file(joinpath(@__DIR__, "null.fgb"))
        t = Table(fgb)
        @test ismissing(t.date[2])
        @test ismissing(t.name[2])
        @test ismissing(t.number[2])
    end
end
