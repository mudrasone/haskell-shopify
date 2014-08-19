{-# LANGUAGE OverloadedStrings #-}

module Shopify.Types.Variant(
  Variant(..)
  ) where

import           Control.Applicative ((<$>), (<*>))
import           Control.Monad (mzero)
import           Data.Aeson ( (.:)
                            , (.:?)
                            , (.=)
                            , FromJSON(parseJSON)
                            , object
                            , Value(Object)
                            , ToJSON(toJSON)
                            )
import qualified Data.Aeson as A
import           Data.Maybe (catMaybes)
import           Data.Scientific (fromFloatDigits, scientific)
import           Data.Text (Text)
import           Data.Time (UTCTime)
import Shopify.Types.InventoryPolicy (InventoryPolicy)

data Variant = Variant { variantBarcode :: Maybe Text
                       , variantCompareAtPrice :: Maybe Float
                       , variantCreatedAt :: UTCTime
                       , variantFulfillmentService :: Text
                       , variantGrams :: Int
                       , variantId :: Integer
                       , variantInventoryManagement :: Maybe Text
                       , variantInventoryPolicy :: InventoryPolicy
                       , variantInventoryQuantity :: Int
                       , variantOldInventoryQuantity :: Int
                       -- , variantOptions :: [???]
                       , variantPosition :: Int
                       , variantPrice :: Float
                       , variantProductId :: Integer
                       , variantRequiresShipping :: Bool
                       , variantSku :: Maybe Text
                       , variantTaxable :: Bool
                       , variantTitle :: Text
                       , variantUpdatedAt :: UTCTime
                       , variantImageId :: Maybe Integer
                       }

instance FromJSON Variant where
  parseJSON(Object v) = Variant <$> v .:? "barcode"
                                <*> v .:? "compare_at_price"
                                <*> v .:  "created_at"
                                <*> v .:  "fulfillment_service"
                                <*> v .:  "grams"
                                <*> v .:  "id"
                                <*> v .:? "inventory_management"
                                <*> v .:  "inventory_policy"
                                <*> v .:  "inventory_quantity"
                                <*> v .:  "old_inventory_quantity"
                                <*> v .:  "position"
                                <*> v .:  "price"
                                <*> v .:  "product_id"
                                <*> v .:  "requires_shipping"
                                <*> v .:? "sku"
                                <*> v .:  "taxable"
                                <*> v .:  "title"
                                <*> v .:  "updated_at"
                                <*> v .:? "image_id"
  parseJSON _         = mzero

instance ToJSON Variant where
  toJSON (Variant barcode
                  compareAtPrice
                  createdAt
                  fulfillmentService
                  grams
                  varId 
                  inventoryManagement
                  inventoryPolicy
                  inventoryQuantity
                  oldInventoryQuantity
                  position
                  price
                  productId
                  requiresShipping
                  sku
                  taxable
                  title
                  updatedAt
                  imageId
                  ) = object $ [ "created_at"             .= createdAt
                               , "fulfillment_service"    .= fulfillmentService
                               , "grams"                  .= grams
                               , "id"                     .= varId
                               , "inventory_policy"       .= inventoryPolicy
                               , "inventory_quantity"     .= inventoryQuantity
                               , "old_inventory_quantity" .= oldInventoryQuantity
                               , "position"               .= position
                               , "price"                  .= price
                               , "product_id"             .= productId
                               , "requires_shipping"      .= requiresShipping
                               , "taxable"                .= taxable
                               , "title"                  .= title
                               , "updated_at"             .= updatedAt
                               ] ++ catMaybes
                               [ ("barcode" .=)              . A.String <$> barcode
                               , ("compare_at_price" .=)     . A.Number . fromFloatDigits <$> compareAtPrice
                               , ("inventory_management" .=) . A.String <$> inventoryManagement
                               , ("sku" .=)                  . A.String <$> sku
                               , ("image_id" .=)             . A.Number . flip scientific 0 <$> imageId
                               ]
