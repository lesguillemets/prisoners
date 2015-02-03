import System.IO
import System.Random
import Control.Monad
import Data.List (group, sort)

main = do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    (c,b) <- smallSample 5
    gen <- getStdGen
    loop c b gen

smallSample :: Int -> IO (Int,Int)
smallSample n = do
    res <- replicateM n $ do
        putStrLn "Coop"
        getLine
    return . (\(x,y) ->(length y, length x)) . break (== "Betray") . sort $ res
    

loop :: Int -> Int -> StdGen -> IO()
loop coop betr g = do
    let
        (b,ng) = randomR (0.0,1.0::Double) g
        ratio = fromIntegral coop / fromIntegral (coop+betr)
    putStrLn . p $ b <= ratio
    r <- getLine
    case r of
        "Coop" -> loop (coop+1) betr ng
        "Betray" -> loop coop (betr+1) ng

p :: Bool -> String
p True = "Coop"
p False = "Betray"
