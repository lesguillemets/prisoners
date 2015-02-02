module Display where
import Data.Array
import Data.List (sort)
import Text.Printf (printf)
import GHC.Exts (groupWith)

display :: Array (Int,Int) Double -> String
display arr = let
    lns = map sort . groupWith fst . indices $ arr
    showLn = unwords . map toFixedDigits . addLineSummary . map (arr !)
    in
        unlines . map showLn $ lns

addLineSummary :: [Double] -> [Double]
addLineSummary ln = ln ++ [sum ln / fromIntegral (length ln)]

showPlayers :: [FilePath] -> String
showPlayers = let titles = map (printf "%2d.\t") ([1..] :: [Int])
                  in unlines . zipWith (++) titles

toFixedDigits :: Double -> String
toFixedDigits = printf "%.4f |"
