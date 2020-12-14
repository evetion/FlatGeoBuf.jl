module FlatGeobuf

import FlatBuffers

# Partly autogenerated
include("schema/header.jl")
include("schema/feature.jl")

include("flatgeobuffer.jl")
include("index.jl")
include("io.jl")
include("table.jl")

export findall, read_file


end # module
