mutable struct RFGraphPlot
    g :: AbstractGraph
    xloc :: Array{Number}
    yloc :: Array{Number}
    signal :: Array{Number}
    nodeSize :: Number
    edgeWidth :: Number
    cmap :: Symbol
    colorbar :: Bool
    colorbarlabel :: String 
    title :: String
end
@recipe function f(rfgp::RFGraphPlot)
    g = rfgp.g 
    isdir = is_directed(g)
    xloc = rfgp.xloc 
    yloc = rfgp.yloc

    framestyle --> :none
    aspect_ratio --> true
    title --> rfgp.title
    cmap --> rfgp.cmap

    for e in edges(g)             
        if(isdir)
            @series begin
                seriestype := :quiver 
                color --> "black"
                i = e.src
                j = e.dst
                x = [xloc[i]]
                y = [yloc[i]]
                arrow -->  arrow(:closed,:tail,1, 1)
                quiver --> (0.9*[xloc[j]-xloc[i]],0.9*[yloc[j]-yloc[i]])
                x,y
            end
        else
            @series begin
                seriestype := :path 
                color --> "black"
                linewidth --> rfgp.edgeWidth
                label --> ""
                i = e.src
                j = e.dst
                xis = [xloc[i],xloc[j]]
                yis = [yloc[i],yloc[j]]
                xis,yis 
            end
        end
    end

    @series begin
        seriestype := :scatter
        if(!isempty(rfgp.signal))
            zcolor --> rfgp.signal
        else
            color --> "white"
        end
        label --> ""
        markersize --> rfgp.nodeSize
        xloc,yloc
    end
    colorbar --> rfgp.colorbar
    colorbar_title --> rfgp.colorbarlabel
    primary := false
    ()
end


