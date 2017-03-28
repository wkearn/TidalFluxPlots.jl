using ADCPDataProcessing, PIEMetData, TidalFluxPlots, TidalFluxExampleData, Plots
using Base.Test

setADCPdatadir!(Pkg.dir("TidalFluxExampleData","data","adcp"))
setmetdatadir!(Pkg.dir("TidalFluxExampleData","data","met"))

creek = Creek{:sweeney}()
deps = parse_deps(creek)
ad1 = load_data(deps[1])

plot(ad1)
