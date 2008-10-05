-- -*- mode: haskell; Encoding: UTF-8 -*-
-- コインを取ったときの演出コイン

module Actor.CoinGet (
	newCoinGet
) where

import Multimedia.SDL hiding (Event)

import Actor (Actor(..))
import AppUtil
import Const
import Images
import Event


data CoinGet = CoinGet {
	sx :: Int,
	y :: Int,
	vy :: Int,
	cnt :: Int,
	starty :: Int
	}

imgtbl = [ImgCoin0, ImgCoin1, ImgCoin2, ImgCoin3]

instance Actor CoinGet where
	update _ self
		| bDead self'	= (self', [EvScoreAddEfe (sx self) (y self `div` one) pointGetCoin])
		| otherwise		= (self', [])
		where
			self' = self { y = y self + vy self, vy = vy self + gravity, cnt = cnt self + 1 }

	render self imgres scrx sur = do
		blitSurface (getImageSurface imgres imgtype) Nothing sur (pt (sx self - scrx) (y self `div` one - 8))
		return ()
		where
			imgtype = imgtbl !! (cnt self `div` 2 `mod` 4)

	bDead self = vy self > 0 && y self >= (starty self - chrSize * one)

newCoinGet :: Int -> Int -> CoinGet
newCoinGet cx cy =
	CoinGet { sx = xx, y = yy, vy = -12 * gravity, cnt = 0, starty = yy }
	where
		xx = cx * chrSize + 4
		yy = (cy - 1) * chrSize * one
