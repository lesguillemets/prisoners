import System.IO
main = do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    putStrLn "Coop"
    step

step :: IO ()
step = do
    prev <- getLine
    putStrLn prev
    step
