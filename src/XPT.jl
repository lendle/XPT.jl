module XPT


import Datetime: DateTime, datetime
import Base: show, close
import DataArrays: DataArray, NA
import DataFrames: DataFrame
import StrPack: @struct, calcsize, unpack


export XPTFile, readdf, closexpt


include("util.jl")
include("XPTInfo.jl")
include("NameStr.jl")
include("DSInfo.jl")
include("IBM2Float64.jl")
include("XPTFile.jl")



end # module
