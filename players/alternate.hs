import System.IO
main = do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    step True

step :: Bool -> IO ()
step b = do
    putStrLn $ if b then "Coop" else "Betray"
    _ <- getLine
    step (not b)
