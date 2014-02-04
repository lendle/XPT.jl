using Base.Test

using XPT 
using DataFrames

fname1 = joinpath(Pkg.dir(), "XPT/test/data/test1.xpt")

f=open(fname1)
xpt1=XPTFile(f)
@test isa(xpt1, XPTFile)
closexpt(xpt1)

xpt2 = XPTFile(fname1)
@test isa(xpt2, XPTFile)



expected = DataFrame(short=[2.0, 2.5], a=[4.0, 8.0], b=[4.0, 4.0], c=["word", "wind"], m=@data [123.0, NA])

@test hash(readdf(xpt2)) == hash(expected)

#should work more than once
@test hash(readdf(xpt2)) == hash(expected)

fname2 = joinpath(Pkg.dir(), "XPT/test/data/notxpt.txt")


@test_throws XPTFile(fname2)

