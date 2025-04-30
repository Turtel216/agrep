{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Grep.Core where

import qualified System.Environment as Sys
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Data.Text (Text)
import System.Directory (doesFileExist, doesDirectoryExist, listDirectory)
import Control.Exception (try)
import Data.Text.Internal.Search (indices)
import System.FilePath ((</>))
import Control.Monad (forM_, unless)

-- | Represents the type of location being searched
data LocationType = DirectoryType | FileType deriving (Eq, Show)

-- | Contains search parameters
data SearchType = SearchType
  { searchTerm :: !Text
  , searchLocation :: !FilePath
  , searchLocationType :: !LocationType
  } deriving (Eq, Show)

-- | Parse command line arguments and validate the search location
fetchVals :: IO (Either Text SearchType)
fetchVals = do
  argList <- Sys.getArgs
  case argList of
    (term:location:_) -> validateLocation term location
    _ -> pure $ Left "Incorrect number of arguments.\nUsage: agrep [SEARCH TERM] [SEARCH LOCATION]"
  where
    validateLocation :: String -> FilePath -> IO (Either Text SearchType)
    validateLocation term location = do
      isFile <- doesFileExist location
      isDir <- doesDirectoryExist location
      if isFile
        then pure $ Right $ SearchType (T.pack term) location FileType
        else if isDir
          then pure $ Right $ SearchType (T.pack term) location DirectoryType
          else pure $ Left $ "Invalid search location: " <> T.pack location

-- | Main entry point
main' :: IO ()
main' = do
  result <- fetchVals
  case result of
    Left err -> T.putStrLn err
    Right searchParams -> processSearching searchParams

-- | Process a search based on the provided search parameters
processSearching :: SearchType -> IO ()
processSearching SearchType{..} =
  case searchLocationType of
    FileType -> searchFile searchTerm searchLocation
    DirectoryType -> do
      files <- listDirectory searchLocation
      forM_ files $ \file -> do
        let fullPath = searchLocation </> file
        isDir <- doesDirectoryExist fullPath
        if isDir
          then processSearching (SearchType searchTerm fullPath DirectoryType)
          else searchFile searchTerm fullPath

-- | Search a single file for the search term
searchFile :: Text -> FilePath -> IO ()
searchFile searchTerm filePath = do
  result <- try $ T.readFile filePath :: IO (Either IOError Text)
  case result of
    Left _ -> pure ()  -- Silently ignore files that can't be read
    Right content -> searchInLines searchTerm (T.lines content)

-- | Search for a term in lines of text and print matches with line numbers
searchInLines :: Text -> [Text] -> IO ()
searchInLines searchTerm = go 1
  where
    go _ [] = pure ()
    go lineNum (line:rest) = do
      unless (null $ indices searchTerm line) $
        T.putStrLn $ T.pack (show lineNum) <> "\t" <> line
      go (lineNum + 1) rest
