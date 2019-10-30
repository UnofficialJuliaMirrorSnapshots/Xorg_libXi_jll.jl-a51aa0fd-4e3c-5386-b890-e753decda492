module Xorg_libXi_jll
using Pkg, Pkg.BinaryPlatforms, Pkg.Artifacts, Libdl
import Base: UUID

# We put these inter-JLL-package API values here so that they are always defined, even if there
# is no underlying wrapper held within this JLL package.
const PATH_list = String[]
const LIBPATH_list = String[]

# Load Artifacts.toml file
artifacts_toml = joinpath(@__DIR__, "..", "Artifacts.toml")

# Extract all platforms
artifacts = Pkg.Artifacts.load_artifacts_toml(artifacts_toml; pkg_uuid=UUID("a51aa0fd-4e3c-5386-b890-e753decda492"))
platforms = [Pkg.Artifacts.unpack_platform(e, "Xorg_libXi", artifacts_toml) for e in artifacts["Xorg_libXi"]]

# Filter platforms based on what wrappers we've generated on-disk
platforms = filter(p -> isfile(joinpath(@__DIR__, "wrappers", triplet(p) * ".jl")), platforms)

# From the available options, choose the best platform
best_platform = select_platform(Dict(p => triplet(p) for p in platforms))

# Silently fail if there's no binaries for this platform
if best_platform === nothing
    @debug("Unable to load Xorg_libXi; unsupported platform $(triplet(platform_key_abi()))")
else
    # Load the appropriate wrapper
    include(joinpath(@__DIR__, "wrappers", "$(best_platform).jl"))
end

end  # module Xorg_libXi_jll
