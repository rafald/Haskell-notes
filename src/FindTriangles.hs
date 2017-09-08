-- https://gist.github.com/qzchenwl/57ec6f993bba6566dacd/raw/c5295855cc8e68c5b49afdf013810cb4db1e346d/FindTriangles.hs

module FindTriangles where
import Data.List

vertices = "ABCDEFGHIJK"
edges = ["ADB", "AEC", "AFHJ", "AGIK", "BJKC", "BHIE", "DFGE"]
combinations n = filter ((==n) . length) . subsequences
inSameEdge xs = or [ all (`elem` edge) xs | edge <- edges]
isTriangle (a:b:c:[]) = all inSameEdge [[a, b], [a, c], [b, c]] && not (inSameEdge [a, b, c])
triangles = filter isTriangle (combinations 3 vertices)

main = print triangles
