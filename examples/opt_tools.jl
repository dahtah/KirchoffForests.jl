using LightGraphs,SimpleWeightedGraphs
using RandomForests
using LinearAlgebra
using SparseArrays
using Plots
using StatsBase
using Clustering
using Distributions
using ImageView, TestImages, Gtk.ShortNames, Images, ImageMagick, ImageQualityIndexes

plotly()


imname = "lake_gray"
im = imresize(testimage(imname), 32, 32)
im = Int64.(floor.(Float64.(Gray24.(im))*256))
nx = size(im,1)
ny = size(im,2)
rs = (v) -> reshape(v,nx,ny)
G = LightGraphs.grid([nx,ny])
im = im[:]
im_noisy = zeros(size(im))

for (idx,i) in enumerate(im)
    im_noisy[idx] =  rand(Poisson(i))
end

x = zeros(size(im))
xtilde = zeros(size(im))
xbar = zeros(size(im))
y = im_noisy
z0 = (rand(nv(G)))

x = ((newton(G,y,z0,0.01;α=0.05,numofiter = 100,tol=0.001, method="exact")))
xtilde = ((newton(G,y,z0,0.01;α=0.05,numofiter = 100,tol=0.001, method="xtilde",nrep=20)))
xbar = ((newton(G,y,z0,0.01;α=0.05,numofiter = 100,tol=0.001, method="xbar",nrep=20)))

Gray.([reshape(y./256,nx,ny) reshape(x./256,nx,ny) reshape(xtilde./256,nx,ny) reshape(xbar./256,nx,ny)])
