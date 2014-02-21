type XPTFile
    fname::String
    io::IO
    info::XPTInfo

    function XPTFile(fname, io, info)
        xpt = new(fname, io, info)
        finalizer(xpt, closexpt)
        xpt
    end
end
function show(io::IO, xpt::XPTFile)
    println(io, "File name: ", xpt.fname)
    show(io, xpt.info)
end

function XPTFile(fname::String)
    io = open(fname)
    info = XPTInfo(io)
    XPTFile(fname, io, info)
end

function XPTFile(io::IO)
    info = XPTInfo(io)
    XPTFile(io.name, io, info)
end

closexpt(xpt::XPTFile) = close(xpt.io)

function readdf(xpt::XPTFile)
    seek(xpt.io, ROW_LENGTH * 3)
    dsinfo = DSInfo(xpt.io)
    readrecords(xpt.io, dsinfo.namestrs)
end

function readrecords(io::IO, namestrs::Array{NameStr, 1})
    obs_header=readbytes(io, ROW_LENGTH)
    @assert obs_header[1:48] == OBS_HEADER_RECORD

    reclen = mapreduce(ns-> ns.nlng, +, namestrs)

    vararray = {}
    for ns in namestrs
        push!(vararray, ns.ntype == 1? DataArray(Float64[]) : ASCIIString[])
    end

    pdv= Uint8[]
    nextline = Uint8[]

    done=false

    while !done
        if isempty(nextline)
            if eof(io)
                done = true
            else
                nextline = readbytes(io, ROW_LENGTH)
                if nextline[1:48] == MEMBER_HEADER_RECORD
                    skip(io, -ROW_LENGTH)
                    done=true
                end
            end
        else
            append!(pdv, splice!(nextline, 1:min(reclen-size(pdv, 1), size(nextline, 1))))

            assert(size(pdv, 1) <= reclen)

            if size(pdv, 1) == reclen
                for j in 1:size(namestrs, 1)
                    i1 = namestrs[j].npos + 1
                    i2 = namestrs[j].nlng + i1 - 1
                    if namestrs[j].ntype == 1
                        num=zeros(Uint8, 8)
                        num[1:namestrs[j].nlng] = pdv[i1:i2]
                        if ENDIAN_BOM == 0x04030201
                            reverse!(num)
                        end
                        push!(vararray[j], IBM2Float64(num))
                    else
                        push!(vararray[j], ascii(pdv[i1:i2]))
                    end
                end
                pdv = Uint8[]
            end
        end
    end

    names = map(ns -> symbol(strip(lowercase(ns.nname))), namestrs)

    DataFrame(vararray, names)
end

