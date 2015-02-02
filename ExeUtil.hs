module ExeUtil where
import Control.Monad
import qualified System.Directory as SD

getExecutables :: FilePath -> IO [FilePath]
getExecutables dir = do
    files <- SD.getDirectoryContents dir
    cdir <- SD.getCurrentDirectory
    SD.setCurrentDirectory dir
    exes <- filterM (liftM SD.executable . SD.getPermissions) files
    SD.setCurrentDirectory cdir
    return exes
