{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Grep.Core where

import qualified System.Environment as Sys
import qualified Data.Text as T
import           Data.Text (Text)
import qualified Data.Text.IO as T
import System.Directory
import Control.Exception
import Data.Text.Internal.Search

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
searchFile searchTerm searchLocation = do
  eContent <- try $ T.lines <$> T.readFile searchLocation :: IO (Either IOError [T.Text])
  case eContent of
    Left _ -> pure ()
    Right content -> searchString searchTerm content

searchString :: Text -> [Text] -> IO ()
searchString searchTerm = mapM_ (\hayStack -> searchString' searchTerm hayStack)

searchString' :: Text -> Text -> IO ()
searchString' searchTerm hayStack = do
  case indices searchTerm hayStack of
    [] -> pure ()
    _ -> T.putStrLn hayStack
