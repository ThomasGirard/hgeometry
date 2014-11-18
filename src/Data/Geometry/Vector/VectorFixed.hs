{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE UndecidableInstances #-}
module Data.Geometry.Vector.VectorFixed where

import           Control.Applicative

import           Control.Lens

import           Data.Proxy

import           Data.Foldable
import           Data.Traversable

import           Data.Vector.Fixed.Boxed
import           Data.Vector.Fixed.Cont(Z(..),S(..),ToPeano(..),ToNat(..))

import           GHC.TypeLits

import           Linear.Affine
import           Linear.Metric
import           Linear.Vector

import qualified Data.Vector.Fixed as V

import qualified Linear.V3 as L3


--------------------------------------------------------------------------------

data C (n :: Nat) = C deriving (Show,Read,Eq,Ord)

--------------------------------------------------------------------------------

newtype Vector (d :: Nat)  (r :: *) = Vector { _unV :: Vec (ToPeano d) r }

unV :: Lens' (Vector d r) (Vec (ToPeano d) r)
unV = lens _unV (const Vector)

----------------------------------------
type Arity  (n :: Nat)  = V.Arity (ToPeano n)

type Index' i d = V.Index (ToPeano i) (ToPeano d)

element   :: forall i d r. (Arity d, Index' i d) => Proxy i -> Lens' (Vector d r) r
element _ = V.elementTy (undefined :: (ToPeano i))



deriving instance (Show r, Arity d) => Show (Vector d r)
deriving instance (Eq r, Arity d)   => Eq (Vector d r)
deriving instance (Ord r, Arity d)  => Ord (Vector d r)
deriving instance Arity d  => Functor (Vector d)

deriving instance Arity d  => Foldable (Vector d)
deriving instance Arity d  => Applicative (Vector d)

instance Arity d => Traversable (Vector d) where
  traverse f (Vector v) = Vector <$> traverse f v


instance Arity d => Additive (Vector d) where
  zero = pure 0
  (Vector u) ^+^ (Vector v) = Vector $ V.zipWith (+) u v

instance Arity d => Affine (Vector d) where
  type Diff (Vector d) = Vector d

  u .-. v = u ^-^ v
  p .+^ v = p ^+^ v


instance Arity d => Metric (Vector d)

type instance V.Dim (Vector d) = ToPeano d

instance Arity d => V.Vector (Vector d) r where
  construct    = Vector <$> V.construct
  inspect    v = V.inspect (_unV v)
  basicIndex v = V.basicIndex (_unV v)

-- ----------------------------------------

type AlwaysTrueDestruct pd d = (Arity pd, ToPeano d ~ S (ToPeano pd))


-- | Get the head and tail of a vector
destruct            :: AlwaysTrueDestruct predD d
                    => Vector d r -> (r, Vector predD r)
destruct (Vector v) = (V.head v, Vector $ V.tail v)


cross       :: Num r => Vector 3 r -> Vector 3 r -> Vector 3 r
u `cross` v = fromV3 $ (toV3 u) `L3.cross` (toV3 v)


toV3   :: Vector 3 a -> L3.V3 a
toV3 v = let [a,b,c] = V.toList v in L3.V3 a b c

fromV3               :: L3.V3 a -> Vector 3 a
fromV3 (L3.V3 a b c) = Vector $ V.mk3 a b c

----------------------------------------------------------------------------------



type AlwaysTrueSnoc d = ToPeano (1 + d) ~ S (ToPeano d)

snoc :: (AlwaysTrueSnoc d, Arity d) => Vector d r -> r -> Vector (1 + d) r
snoc = flip V.snoc

init :: AlwaysTrueDestruct predD d => Vector d r -> Vector predD r
init = Vector . V.reverse . V.tail . V.reverse . _unV



prefix :: (Prefix (ToPeano i) (ToPeano d)) => Vector d r -> Vector i r
prefix (Vector v) = Vector $ prefix' v

class Prefix i d where
  prefix' :: Vec d r -> Vec i r

instance Prefix Z d where
  prefix' _ = V.vector V.empty

instance (V.Arity i, V.Arity d, V.Index i d, Prefix i d) => Prefix (S i) (S d) where
  prefix' v = V.vector $ V.head v `V.cons` (prefix' $ V.tail v)


imap :: Arity d => (Int -> r -> s ) -> Vector d r -> Vector d s
imap = V.imap
