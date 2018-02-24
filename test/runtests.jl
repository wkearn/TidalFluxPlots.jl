using TidalFluxConfigurations, ADCPDataProcessing, PIEMetData, TidalFluxPlots, TidalFluxExampleData, Plots
using Base.Test

TidalFluxConfigurations.config[:_ADCPDATA_DIR] = Pkg.dir("TidalFluxExampleData","data","adcp")
TidalFluxConfigurations.config[:_METDATA_DIR] = Pkg.dir("TidalFluxExampleData","data","met")

creek = Creek{:sweeney}()
deps = parse_deps(creek)
ad1 = load_data(deps[1])

plot(ad1)

cs = parse_cs(creek)
csd = load_data(cs)

# Test the cross-section plot
plot(csd)

h1,Q1 = computedischarge(ad1,csd)

# Test a few Quantities
plot(h1)
plot(Q1)

cals = parse_cals(creek)
cald = load_data(cals[1])

plot(cald)
calscatter([cald])

