# XPT

[![Build Status](https://travis-ci.org/lendle/XPT.jl.png)](https://travis-ci.org/lendle/XPT.jl)

## About

The XPT package reads SAS® software transport files and converts SAS software datasets to DataFrames.
Transport files are assumed to follow the specifications described in the technical note tiled "THE RECORD LAYOUT OF A DATA SET IN SAS TRANSPORT (XPORT) FORMAT" available [here](http://support.sas.com/techsup/technote/ts140.html) ([pdf](http://support.sas.com/techsup/technote/ts140.pdf)).

Currently, only the first dataset found in a transport file is read and converted to a dataframe, even if the transport file has more than one dataset. If you need to access a dataset after the first in a transport file and I haven't gotten around to adding support for that yet, please file an issue.

Also, datasets are tagged with member type `SASDATA` in transport files. No other member types are referenced in the tech note, so I am assuming they cannot exist (in a transport file). If this is not the case, you'll get an error. Please file an issue and send me a an example of an offending transport file, if possible.

## Usage

Open a transport file (and process the header information):
```julia
xpt = XPTFile("path/to/xpt")
```
or
```julia
f = open("path/to/xpt")
xpt = XPTFile(f)
```
Convert the first SAS dataset in an xpt file to a dataframe:
```
df = readdf(xpt)
```

## Future work





