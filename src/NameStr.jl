@struct(type NameStr
 ntype::Cshort # VARIABLE TYPE: 1=NUMERIC, 2=CHAR
 nhfun::Cshort # HASH OF NNAME (always 0)
 nlng::Cshort # LENGTH OF VARIABLE IN OBSERVATION
 nvar0::Cshort # VARNUM
 nname::ASCIIString(8); # NAME OF VARIABLE
 nlabel::ASCIIString(40) # LABEL OF VARIABLE
 nform::ASCIIString(8) # NAME OF FORMAT
 nfl::Cshort # FORMAT FIELD LENGTH OR 0
 nfd::Cshort # FORMAT NUMBER OF DECIMALS
 nfj::Cshort # 0=LEFT JUSTIFICATION, 1=RIGHT JUST
 nfill::Array{Cchar, 1}(2) # (UNUSED, FOR ALIGNMENT AND FUTURE)
 niform::ASCIIString(8) # NAME OF INPUT FORMAT
 nifl::Cshort # INFORMAT LENGTH ATTRIBUTE
 nifd::Cshort # INFORMAT NUMBER OF DECIMALS
 npos::Int32 # POSITION OF VALUE IN OBSERVATION
 rest::ASCIIString(48) # remaining fields are irrelevant. there are an additional
end,
align_packed,
:BigEndian)
function show(io::IO, ns::NameStr)
    print(io, "Name: ", strip(ns.nname)", ")
    print(io, "Label: ", strip(ns.nlabel)", ")
    print(io, ns.ntype == 1? "Numeric, " : "Character, ")
    print(io, "Pos: ", ns.npos, ", ")
    print(io, "Len: ", ns.nlng)
end


const NAMESTR_SIZE = calcsize(NameStr)


