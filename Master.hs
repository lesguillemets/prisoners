import Control.Applicative
import Control.Monad
import qualified Data.Array as DA
import Data.Array ((//), (!))
import qualified System.Directory as SD

import qualified Action as A
import qualified Interface as IF
import ExeUtil (getExecutables)

binPath :: FilePath
binPath = "./players/"

rounds = 200 :: Int

main = do
    players <- getExecutables binPath
    result <- roundRobin rounds players
    print result

roundRobin :: Int -> [FilePath] -> IO (DA.Array (Int,Int) Double)
roundRobin n players = do
    let
        nP = length players
        battles = [(i,j) | i <- [0..nP-1], j <- [i..nP-1]]
        battle i j = do
            res <- trial n (binPath ++ players!!i) (binPath ++ players!!j)
            return $ scores res
        f (i,j) = do
            thisScore <- battle i j
            return [
                   ((i,j), fromIntegral (fst thisScore) / fromIntegral rounds),
                   ((j,i), fromIntegral (snd thisScore) / fromIntegral rounds)
                   ]
    resl <- concat <$> mapM f battles
    return $ DA.array ((0,0), (nP-1,nP-1)) resl

trial :: Int -> FilePath -> FilePath -> IO [(A.Action,A.Action)]
trial n exe0 exe1 = do
    talker0 <- IF.spawn exe0
    talker1 <- IF.spawn exe1
    results <- replicateM n (turn talker0 talker1)
    IF.terminate talker0
    IF.terminate talker1
    return results

scores :: [(A.Action, A.Action)] -> (Int, Int)
scores rs = (p0,p1) where
    firsts = map fst rs
    seconds = map snd rs
    p0 = sum $ zipWith score firsts seconds
    p1 = sum $ zipWith (flip score) firsts seconds

showResults :: (String,String) -> [(A.Action, A.Action)] -> String
showResults (p0,p1) rs = let
    (score0, score1) = scores rs
    winner = case compare score0 score1 of
            GT -> p0
            LT -> p1
            _ -> "DRAW"
    in
        unlines [
                concatMap (A.shortShow . fst) rs,
                concatMap (A.shortShow . snd) rs,
                show score0 ++ " vs " ++ show score1,
                "winner : " ++ winner
                ]

turn :: IF.Talker -> IF.Talker -> IO (A.Action,A.Action)
turn t0 t1 = do
    nextAction0 <- read <$> IF.listen t0
    nextAction1 <- read <$> IF.listen t1
    IF.talk t0 $ show nextAction1
    IF.talk t1 $ show nextAction0
    return (nextAction0, nextAction1)

score :: A.Action -> A.Action -> A.Score
-- score me other
score A.Betray A.Betray = 1
score A.Coop A.Coop = 3
score A.Betray A.Coop = 5
score A.Coop A.Betray = 0
