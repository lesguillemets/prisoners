import Control.Applicative
import Control.Monad (replicateM)
import System.Environment (getArgs)

import qualified Action as A
import qualified Interface as IF

main = do
    args <- getArgs
    let p0 = head args
    let p1 = head . tail $ args
    trial 100 p0 p1 >>= putStrLn . showResults (p0,p1)

trial :: Int -> String -> String -> IO [(A.Action,A.Action)]
trial n exe0 exe1 = do
    talker0 <- IF.spawn exe0
    talker1 <- IF.spawn exe1
    results <- replicateM n (turn talker0 talker1)
    IF.terminate talker0
    IF.terminate talker1
    return results

points :: [(A.Action, A.Action)] -> (Int, Int)
points rs = (p0,p1) where
    firsts = map fst rs
    seconds = map snd rs
    p0 = sum $ zipWith result firsts seconds
    p1 = sum $ zipWith (flip result) firsts seconds

showResults :: (String,String) -> [(A.Action, A.Action)] -> String
showResults (p0,p1) rs = let
    (point0, point1) = points rs
    winner = case compare point0 point1 of
            GT -> p0
            LT -> p1
            _ -> "DRAW"
    in
        unlines [
                concatMap (A.shortShow . fst) rs,
                concatMap (A.shortShow . snd) rs,
                show point0 ++ " vs " ++ show point1,
                "winner : " ++ winner
                ]

turn :: IF.Talker -> IF.Talker -> IO (A.Action,A.Action)
turn t0 t1 = do
    nextAction0 <- read <$> IF.listen t0
    nextAction1 <- read <$> IF.listen t1
    IF.talk t0 $ show nextAction1
    IF.talk t1 $ show nextAction0
    return (nextAction0, nextAction1)


result :: A.Action -> A.Action -> A.Result
-- result me other
result A.Betray A.Betray = 1
result A.Coop A.Coop = 3
result A.Betray A.Coop = 5
result A.Coop A.Betray = 0
