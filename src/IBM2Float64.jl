# Based on https://gist.github.com/simonbyrne/5443843

function IBM2Float64(x::Array{Uint8, 1})
    ibm = reinterpret(Uint64,x)[1]
    if ibm == 0
        println("ibm 0")
        return zero(Float64)
    end

    mantissa = ibm & 0x00ff_ffff_ffff_ffff
    exponent = ibm & 0x7f00_0000_0000_0000
    if mantissa == 0
        # if exponent == 0x5f00_0000_0000_0000
        #     #._
        # elseif  exponent == 0x2e00_0000_0000_0000
        #     #.
        # elseif  exponent == 0x4100_0000_0000_0000
        #     #.A
        # elseif exponent == 0x4200_0000_0000_0000
        #     #.B
        #     #.....
        # elseif exponent == 0x5a00_0000_0000_0000
        #     #.Z
        # end
        return NA
    end

    # normalise mantissa to base 2.
    offset = 1
    while mantissa & 0x0080_0000_0000_0000 == 0
        offset += 1
        mantissa <<= 1
    end
    # drop leading 1 (8th bit), and shift remainder to 12th bit.
    mantissa = (mantissa $ 0x0080_0000_0000_0000) >> 3

    sign = ibm & 0x8000_0000_0000_0000


    # convert from base 16 to base 2, adjust for normalisation.
    exponent = ((((exponent >> 56) - 64) << 2) - offset + 1023) << 52

    return reinterpret(Float64, sign | exponent | mantissa)
end
