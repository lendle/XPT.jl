# XPT

[![Build Status](https://travis-ci.org/lendle/XPT.jl.png)](https://travis-ci.org/lendle/XPT.jl)

**NOTE** Requires the master version of DataFrames. Get that with `Pkg.checkout("DataFrames")`. I don't know how to specify that in the `REQUIRE` file.

## About

The XPT package reads SAS® software transport files and converts SAS software datasets to DataFrames.
Transport files are assumed to follow the specifications described in the technical note tiled "THE RECORD LAYOUT OF A DATA SET IN SAS TRANSPORT (XPORT) FORMAT" available [here](http://support.sas.com/techsup/technote/ts140.html) ([pdf](http://support.sas.com/techsup/technote/ts140.pdf)).

Datasets are tagged with member type `SASDATA` in transport files. No other member types are referenced in the tech note, so I am assuming they cannot exist (in a transport file). If this is not the case, you'll get an error. Please file an issue and send me a an example of an offending transport file, if possible.

Character variables in a dataset are converted to `{ASCIIString}`s. Missing character variables in SAS datasets are just empty strings, and are treated as such here. 

SAS software numeric variables are not standard IEEE `Float64`s and can be shorter than 8 bytes and can have missing values. (Twenty-eight kinds in fact: `._`, `.`, `.a`, ..., `.z`.) All numeric variables are converted to `Float64`s unless they are missing. All missing values are treated as `DataArrays.NA`.

**NOTE** Currently, only the first dataset found in a transport file is read and converted to a dataframe, even if the transport file has more than one dataset. If you need to access a dataset after the first in a transport file and I haven't gotten around to adding support for that yet, please file an issue.

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

* Convert all datasets in a transport file after the first to julia DataFrames
* Or only a selection, indexing by name or number.
* Add some useful tests.
* Make it go faster. I assume my implementation is slow but I haven't benchmarked it.
* Subset observations in a dataset by index before converting to DataFrame.
* Maybe interface with DataStreams to read datasets sequentially.
