import System.IO

main = do
    hSetBuffering stdout LineBuffering
    hSetBuffering stdin LineBuffering
    (c,b) <- smallSample 5
    loop c b

smallSample :: Int -> IO (Int,Int)
smallSample = smallSample' 0 0
smallSample' :: Int -> Int -> Int -> IO (Int,Int)
smallSample' c b 0 = return (c,b)
smallSample' c b n = do
    putStrLn "Coop"
    r <- getLine
    case r of
        "Coop" -> smallSample' (c+1) b (n-1)
        "Betray" -> smallSample' c (b+1) (n-1)

loop :: Int -> Int -> IO ()
loop coop betr = do
    putStrLn . p $ coop >= betr
    r <- getLine
    case r of
        "Coop" -> loop (coop+1) betr
        "Betray" -> loop coop (betr+1)

p :: Bool -> String
p True = "Coop"
p False = "Betray"
