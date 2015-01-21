module Interface where

import qualified System.Process as P
import qualified System.IO as IO
import qualified GHC.IO.Handle as H

data Talker = Talker {
            _inp :: H.Handle,
            _out :: H.Handle,
            _err :: H.Handle,
            _pid :: P.ProcessHandle
}

spawn :: String -> IO Talker
spawn executable = do
    (i,o,e,p) <- P.runInteractiveProcess executable [] Nothing Nothing
    IO.hSetBuffering i IO.LineBuffering
    IO.hSetBuffering o IO.LineBuffering
    IO.hSetBuffering e IO.LineBuffering
    return (Talker i o e p)

talk :: Talker -> String -> IO ()
talk t= IO.hPutStrLn (_inp t)

listen :: Talker -> IO String
listen = IO.hGetLine . _out

talkAndListen :: Talker -> String -> IO String
talkAndListen t message = do
    IO.hPutStrLn (_inp t) message
    IO.hGetLine (_out t)

terminate :: Talker -> IO ()
terminate = P.terminateProcess . _pid
