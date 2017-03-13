module TidalFluxPlots

using RecipesBase, Plots, TidalDischargeModels

@recipe function f(adcp::ADCPData)
    p = adcp.p
    v = adcp.v
    t = Dates.format(adcp.t,"yyyy-mm-dd HH:MM:SS")
    temp = adcp.temp
    pitch= adcp.pitch
    roll = adcp.roll
    heading = adcp.heading
    
    bs = bins(adcp.dep.adcp)
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
        t, p
    end
    
    @series begin
        seriestype := :heatmap
        subplot := 2
        t,bs,v[:,:,1]
    end

    @series begin
        seriestype := :heatmap
        subplot := 3
        t,bs,v[:,:,2]
    end

    @series begin
        seriestype := :heatmap
        subplot := 4
        t,bs,v[:,:,3]
    end

    @series begin
        seriestype := :path
        subplot := 5
        t,temp
    end

    @series begin
        seriestype := :path
        subplot := 6
        t,[roll pitch heading]
    end
    
    if !a1t && !a2t
        a1 = get(adcp.a1)
        a2 = get(adcp.a2)
        @series begin
            seriestype := :path
            subplot := 7
            t, [a1 a2]
        end
    end
end
    
@recipe f(dep::Deployment) = load_data(dep)

@recipe function f(cal::CalibrationData)
    @series begin
        cal.t,cal.Q
    end
    @series begin
        cal.dd.ts,cal.dd.Q
    end
end

@recipe f(cs::CrossSectionData) = (cs.x,cs.z)

@recipe f(Q::DischargeData) = (Q.Q,Q.cp)


end # module
