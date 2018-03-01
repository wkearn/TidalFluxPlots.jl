using GeoInterface, ADCPDataProcessing, MapTiles

struct CreekPoint <: AbstractPoint
    creek::Creek
end

GeoInterface.coordinates(cf::CreekPoint) = _get_geom(cf.creek)

function _get_geom(creek::Creek)
    M = ADCPDataProcessing.metadataload(creek)
    lat = M["gps"]["lat"]
    lon = M["gps"]["lon"]
    [lon,lat]
end

function _get_coords(creek::Creek)
    M = ADCPDataProcessing.metadataload(creek)
    E = M["gps"]["east"]
    N = M["gps"]["north"]
    [E,N]
end

function _get_bbox(m::MultiPoint,α=0.05)
    X = coordinates(m)
    Z = [map(x->x[1],X) map(x->x[2],X)]
    Zm = minimum(Z,1)
    Zp = maximum(Z,1)

    Zc = (Zm+Zp)/2
    Zd = (Zp-Zm)/2
    [(Zc+(1+α)*Zd)'; (Zc-(1+α)*Zd)']
end


function fetchtilesmp(m::MultiPoint,z::Int,maxtiles::Int,provider::MapTiles.AbstractProvider,α=0.05)
    MapTiles.fetchmap(_get_bbox(m)...,z,maxtiles=maxtiles,provider=provider)
end

@userplot CreekMap

@recipe function f(cm::CreekMap)
    creeks,z,maxtiles,provider = cm.args
    
    m = MultiPoint(CreekPoint.(creeks))

    b = fetchtilesmp(m,z,maxtiles,provider)

    framestyle --> :none
    ticks --> nothing
    aspect_ratio --> 1
    yflip --> true
    
    @series begin
        b
    end

    @series begin
        MapTiles.project(b,m)
    end    
end

