import Control.Monad (forever)
import System.IO
main :: IO ()
main = forever $ do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    putStrLn "Coop"
    _ <- getLine
    return ()
