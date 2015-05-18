{-# LANGUAGE TemplateHaskell  #-}
{-# LANGUAGE DeriveFunctor  #-}
module Data.Geometry.PolyLine where

import           Control.Applicative
import           Control.Lens
import           Data.Bifunctor
import           Data.Ext
import qualified Data.Foldable as F
import           Data.Geometry.Box
import           Data.Geometry.Interval
import           Data.Geometry.Point
import           Data.Geometry.Properties
import           Data.Geometry.Transformation
import           Data.Geometry.Vector
import qualified Data.Seq2 as S2
import           Data.Semigroup

--------------------------------------------------------------------------------
-- * d-dimensional Polygonal Lines (PolyLines)

-- | A Poly line in R^d
newtype PolyLine d p r = PolyLine { _points :: S2.Seq2 (Point d r :+ p) }
makeLenses ''PolyLine

deriving instance (Show r, Show p, Arity d) => Show    (PolyLine d p r)
deriving instance (Eq r, Eq p, Arity d)     => Eq      (PolyLine d p r)
deriving instance (Ord r, Ord p, Arity d)   => Ord     (PolyLine d p r)

instance Arity d => Functor (PolyLine d p) where
  fmap f (PolyLine ps) = PolyLine $ fmap (first (fmap f)) ps

type instance Dimension (PolyLine d p r) = d
type instance NumType   (PolyLine d p r) = r

instance Semigroup (PolyLine d p r) where
  (PolyLine pts) <> (PolyLine pts') = PolyLine $ pts <> pts'

instance Arity d => IsBoxable (PolyLine d p r) where
  boundingBox = boundingBoxList . toListOf (points.traverse.core)

instance (Num r, AlwaysTruePFT d) => IsTransformable (PolyLine d p r) where
  transformBy = transformPointFunctor

instance PointFunctor (PolyLine d p) where
  pmap f = over points (fmap (first f))


-- | pre: The input list contains at least two points
fromPoints :: (Monoid p) => [Point d r] -> PolyLine d p r
fromPoints = PolyLine . S2.fromList . map (\p -> p :+ mempty)
