import System.IO
import System.Random

main = do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    gen <- getStdGen
    loop gen

loop :: (RandomGen g) => g -> IO()
loop = mapM_ (putStrLn . p) . randomRs (True,False)

p :: Bool -> String
p True = "Coop"
p False = "Betray"

