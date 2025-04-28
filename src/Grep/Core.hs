{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Grep.Core where

import qualified System.Environment as Sys
import qualified Data.Text as T
import           Data.Text (Text)
import qualified Data.Text.IO as T
import System.Directory

data LocationType = DirectoryType | FileType deriving (Eq, Show)

data SearchType = SearchType {
    searchTerm :: Text
  , searchLocation :: FilePath
  , searchLocationType :: LocationType
} deriving (Eq, Show)

-- TODO: Make less imperative
fetchVals :: IO (Either Text SearchType)
fetchVals = do 
  argList <- Sys.getArgs
  if length argList < 2 then pure $ Left "Incorrect number of arguments.\nUsage: agrep [SEARCH TERM] [SEARCH LOCATION]" else do
    let searchLocation = argList !! 1
    fb <- doesFileExist searchLocation
    db <- doesDirectoryExist searchLocation
    if fb then pure $ Right $ SearchType (T.pack $ head argList) searchLocation FileType
      else if db then pure $ Right $ SearchType (T.pack $ head argList) searchLocation DirectoryType
      else pure $ Left $ "Invalid search location" <> T.pack searchLocation

main' :: IO ()
main' = do
  eRes <- fetchVals 
  case eRes of 
    Left e -> T.putStrLn e
    Right r -> processSearching r

processSearching :: SearchType -> IO ()
processSearching SearchType{..} = do
  case searchLocationType of
    FileType -> searchFile searchTerm searchLocation
    DirectoryType -> undefined

searchFile :: Text -> FilePath -> IO ()
searchFile = undefined
