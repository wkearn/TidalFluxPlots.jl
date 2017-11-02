module TidalFluxPlots

using RecipesBase, Plots, TidalFluxQuantities, ADCPDataProcessing, TidalFluxCalibrations

@recipe function f(adcp::ADCPData)
    p = adcp.p
    v = adcp.v
    t = adcp.t
    temp = adcp.temp
    pitch= adcp.pitch
    roll = adcp.roll
    heading = adcp.heading
    
    bs = bins(adcp.dep.adcp)
    NB = length(bs)
    LB = div(NB,3)
    bsx = 1:LB:40
    bsl = bs[bsx]
    
    a1t = isnull(adcp.a1)
    a2t = isnull(adcp.a2)

    legend := false
    layout := @layout [pressure                       
                       vx
                       vy
                       vz
                       temp
                       angles
                       analog]
    
    @series begin        
        seriestype := :path
        subplot := 1
        xticks := false
        p
    end
    
    @series begin
        seriestype := :heatmap
        subplot := 2
        xticks := false
        v[:,:,1]
    end

    @series begin
        seriestype := :heatmap
        subplot := 3
        xticks := false
        v[:,:,2]
    end

    @series begin
        seriestype := :heatmap
        subplot := 4
        xticks := false
        v[:,:,3]
    end

    @series begin
        seriestype := :path
        subplot := 5
        xticks := false
        temp
    end

    @series begin
        seriestype := :path
        subplot := 6
        xticks := false
        ylims := (-180,360)
        yticks := [-180; 0; 180; 360]
        [roll pitch heading]
    end
    
    if !a1t && !a2t
        a1 = get(adcp.a1)
        a2 = get(adcp.a2)
        @series begin
            seriestype := :path
            subplot := 7
            t, [log1p.(a1)]
        end
    else
        @series begin
            seriestype := :path
            subplot := 7
            t, zeros(length(t))
        end
    end
end
    
@recipe f(dep::Deployment) = load_data(dep)

@recipe function f(cal::Calibration)
    @series begin
        from_quantity(cal)
    end
    @series begin
        to_quantity(cal)
    end
end

struct CalScatter end

@recipe function f{T,F}(::CalScatter,cal::Calibration{T,F})
    grid := false
    leg := false
    xlabel := T.name.name
    ylabel := F.name.name
    
    f = TidalFluxCalibrations.interpolatecal(cal)
    t = to_quantity(cal)
    @series begin
        seriestype := :scatter
        quantity(f),quantity(t)
    end
end

@recipe function f{T,F}(cm::CalibrationModel{T,F})
    a,b = extrema(quantity(from_quantity(cm.c)))
    x = a:b
    y = predict(cm,x)
    @series begin
        x,y
    end
end

@recipe f(cs::CrossSectionData) = (cs.x,cs.z)

@recipe f(q::Quantity) = (q.ts,q.q)

end # module
