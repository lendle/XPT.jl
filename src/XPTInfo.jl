
type XPTInfo
    sasversion::String
    operatingsystem::String
    dtcreated::DateTime
    dtmodified::DateTime
end
function Base.show(io::IO, x::XPTInfo)
    println(io, "     SAS Version: ", x.sasversion)
    println(io, "Operating system: ", x.operatingsystem)
    println(io, "         Created: ", x.dtcreated)
    print(io, "        Modified: ", x.dtmodified)
end

function XPTInfo(io::IO)
    seekstart(io)
    first_header_record  = readbytes(io, ROW_LENGTH)
    @assert first_header_record[1:48] == LIBRARY_HEADER_RECORD


    first_real_header = ascii(readbytes(io, ROW_LENGTH))
    second_real_header = ascii(readbytes(io, ROW_LENGTH))

    sasversion = strip(first_real_header[25:32])
    opsys = first_real_header[33:40]
    dtcreated = parsedatetime(first_real_header[end-15:end])
    dtmodified = parsedatetime(second_real_header[1:16])

    XPTInfo(sasversion, opsys, dtcreated, dtmodified)
end