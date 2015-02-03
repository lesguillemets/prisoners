module Display where
import Data.Array
import Data.List (sort)
import Text.Printf (printf)
import GHC.Exts (groupWith)

display :: Array (Int,Int) Double -> String
display arr = let
    lns = map sort . groupWith fst . indices $ arr
    showLn = unwords . map showCell . addLineSummary . map (arr !)
    in
        unlines . addPlayerInfo . map showLn $ lns

addLineSummary :: [Double] -> [Double]
addLineSummary ln = ln ++ [sum ln / fromIntegral (length ln)]

addPlayerInfo :: [String] -> [String]
addPlayerInfo = let p = printf "%2d || " :: Int -> String in
        zipWith (++) (map p [1..])

showPlayers :: [FilePath] -> String
showPlayers = let titles = map (printf "%2d.\t") ([1..] :: [Int])
                  in unlines . zipWith (++) titles

showCell :: Double -> String
showCell = printf "%.4f |"
