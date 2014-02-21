const ROW_LENGTH = 80

const MONTHS = ["JAN" => 1, "FEB" =>  2, "MAR" =>  3, "APR" =>  4,
                "MAY" => 5, "JUN" =>  6, "JUL" =>  7, "AUG" =>  8,
                "SEP" => 9, "OCT" => 10, "NOV" => 11, "DEC" => 12]

const MEMBER_HEADER_RECORD  = b"HEADER RECORD*******MEMBER  HEADER RECORD!!!!!!!"
const LIBRARY_HEADER_RECORD = b"HEADER RECORD*******LIBRARY HEADER RECORD!!!!!!!"
const DSCRPTR_HEADER_RECORD = b"HEADER RECORD*******DSCRPTR HEADER RECORD!!!!!!!"
const NAMESTR_HEADER_RECORD = b"HEADER RECORD*******NAMESTR HEADER RECORD!!!!!!!"
const OBS_HEADER_RECORD     = b"HEADER RECORD*******OBS     HEADER RECORD!!!!!!!"

function parsedatetime (dts::String)
    y = int(dts[6:7])
    y += y < 20 ? 2000 : 1900 #default YEARCUTOFF is 1920
    datetime(y,
             MONTHS[dts[3:5]],
             int(dts[1:2]),
             int(dts[9:10]),
             int(dts[12:13]),
             int(dts[15:16]))
end

