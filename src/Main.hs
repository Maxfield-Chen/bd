{-# LANGUAGE OverloadedStrings, DeriveGeneric, DeriveAnyClass #-}

module Main where

import           GHC.Generics
import qualified Data.Text.Lazy.Read           as R
import           Data.Text.Lazy                 ( Text )
import qualified Data.Text.Lazy.IO             as I
import           Data.Aeson.Text                ( encodeToLazyText )
import           Data.Aeson                     ( ToJSON )

configFile = "baker_profile.json"
data Baker = Baker {name :: Text, yab :: Int} deriving (Show, Generic, ToJSON)

-- Practice unsugaring do notation :) 
initialSetup :: IO (Either String Baker)
initialSetup =
  I.putStrLn "Hello Baker!"
    >>  I.putStrLn "Please enter your username: "
    >>  I.getLine
    >>= \name ->
          I.putStrLn "Enter number of years as a baker: "
            >>  I.getLine
            >>= \yab -> return $ createBaker name yab

createBaker :: Text -> Text -> Either String Baker
createBaker n tyab =
  let eyab = R.decimal tyab in eyab >>= \(i, _) -> Right (Baker n i)

writeBakerToFile :: Baker -> IO ()
writeBakerToFile b = I.writeFile configFile (encodeToLazyText b)

main :: IO ()
main = do
  eBaker <- initialSetup
  case eBaker of
    Right baker -> writeBakerToFile baker
    Left  error -> fail error
