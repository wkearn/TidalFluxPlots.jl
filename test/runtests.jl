using ADCPDataProcessing, TidalFluxPlots, TidalFluxExampleData, Plots
using Base.Test

creek = Creek{:sweeney}()
deps = parse_deps(creek)
ad1 = load_data(deps[1])

plot(ad1)
