import System.IO
import System.Random

main = do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    gen <- getStdGen
    loop gen

loop :: (RandomGen g) => g -> IO()
loop g = do
    let (b,ng) = randomR (True,False) g
    putStrLn . p $ b
    _ <- getLine
    loop ng

p :: Bool -> String
p True = "Coop"
p False = "Betray"

