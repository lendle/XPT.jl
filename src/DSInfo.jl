type DSInfo
    name::ASCIIString
    sasversion::ASCIIString
    operatingsystem::ASCIIString
    dtcreated::DateTime
    dtmodified::DateTime
    label::ASCIIString
    dstype::ASCIIString
    numvar::Int
    namestrs::Array{NameStr, 1}
end

function show(io::IO, d::DSInfo)
    println(io, "               Name: ", d.name)
    println(io, "        SAS version: ", d.sasversion)
    println(io, "   Operating system: ", d.operatingsystem)
    println(io, "            Created: ", d.dtcreated)
    println(io, "           Modified: ", d.dtmodified)
    println(io, "              Label: ", d.label)
    println(io, "            DS Type: ", d.dstype)
    println(io, "Number of variables: ", d.numvar)
    for ns in d.namestrs
        print(io, "    ")
        show(io, ns)
        print(io, "\n")
    end
end

function DSInfo(io::IO)
    #io should be at the beginning of the MEMBER  HEADER RECORD
    member_header_record1 = readbytes(io, ROW_LENGTH)
    @assert member_header_record1[1:48] == MEMBER_HEADER_RECORD
    member_header_record2 = readbytes(io, ROW_LENGTH)
    @assert member_header_record2[1:48] == DSCRPTR_HEADER_RECORD
    member_header_data1 = ascii(readbytes(io, ROW_LENGTH))
    member_header_data2 = ascii(readbytes(io, ROW_LENGTH))
    namestr_header_record = readbytes(io, ROW_LENGTH)
    @assert namestr_header_record[1:48] == NAMESTR_HEADER_RECORD

    #size of the variable descriptor (NAMESTR) record
    namestr_bytes = int(ascii(member_header_record1[75:78]))
    dsname= strip(member_header_data1[9:16])
    memtype = member_header_data1[17:24]
    sasversion = strip(member_header_data1[25:32])
    opsys = member_header_data1[33:40]
    dtcreated = parsedatetime(member_header_data1[end-15:end])
    dtmodified = parsedatetime(member_header_data2[1:16])
    dslabel = strip(member_header_data2[33:72])
    dstype = strip(member_header_data2[73:80])
    numvar=int(ascii(namestr_header_record[55:58])) # number of variabes

    if memtype != "SASDATA "
        error("Member type not SASDATA. Don't know what to do.")
    end

    namestrs = NameStr[]
    for i in 1:numvar
        push!(namestrs, unpack(io, NameStr))
        #some systems (VAX) creating XPT files only use 136 bytes for a namestr
        #but most use 140. NAMESTR_SIZE is 136. namestr_bytes is the number of
        #bytes namestrs are in this file. need to skip ahead if it's > 136, which
        #is probably the case
        skip(io, namestr_bytes - NAMESTR_SIZE)
    end

    #leave io ready to read obs header
    total_namestr_bytes = namestr_bytes * numvar
    skip(io, ROW_LENGTH - rem(total_namestr_bytes, ROW_LENGTH))

    #sort namestrs by position
    nspos(ns::NameStr) = ns.npos
    sort!(namestrs, by=nspos)

    DSInfo(dsname, sasversion, opsys, dtcreated, dtmodified, dslabel, dstype, numvar, namestrs)
end