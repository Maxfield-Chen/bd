{-# LANGUAGE DeriveGeneric, DeriveAnyClass, DuplicateRecordFields #-}

module Bake
  ( Baker
  , createBaker
  )
where

import           Data.Aeson                     ( ToJSON )
import qualified Data.Text.Lazy.Read           as R
import           Data.Text.Lazy                 ( Text )
import           GHC.Generics

data Baker = Baker {name :: Text, yab :: Int} deriving (Show, Generic, ToJSON)

data Percentages  = Percentages {
    flour  :: Double
  , water  :: Double
  , salt   :: Double
  , yeast  :: Double
  , custom :: [(Text, Double)]} deriving (Show, Generic, ToJSON)

data Attempt = Attempt {
    percentages :: Percentages
  , bulkTime    :: Double
  , proofTime   :: Double
  , notes       :: Text } deriving (Show, Generic, ToJSON)

data Recipe = Recipe {
  name        :: Text
, author      :: Text
, source      :: Text
, notes       :: Text
, attempts :: [Attempt] } deriving (Show, Generic, ToJSON)

createBaker :: Text -> Text -> Either String Baker
createBaker name yearsAsBaker =
  let eYearsAsBaker = R.decimal yearsAsBaker
  in  eYearsAsBaker >>= \(yab, _) -> Right (Baker name yab)
