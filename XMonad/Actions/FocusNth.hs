-----------------------------------------------------------------------------
-- |
-- Module       : XMonad.Actions.FocusNth
-- Description  : Focus the nth window of the current workspace.
-- Copyright    : (c) Karsten Schoelzel <kuser@gmx.de>
-- License      : BSD
--
-- Maintainer   : Karsten Schoelzel <kuser@gmx.de>
-- Stability    : stable
-- Portability  : unportable
--
-- Focus the nth window of the current workspace.
-----------------------------------------------------------------------------

module XMonad.Actions.FocusNth (
                 -- * Usage
                 -- $usage
                 focusNth,focusNth',
                 swapNth,swapNth') where

import XMonad.StackSet
import XMonad

-- $usage
-- Add the import to your @~\/.xmonad\/xmonad.hs@:
--
-- > import XMonad.Actions.FocusNth
--
-- Then add appropriate keybindings, for example:
--
-- > -- mod4-[1..9] @@ Switch to window N
-- > ++ [((modm, k), focusNth i)
-- >     | (i, k) <- zip [0 .. 8] [xK_1 ..]]
--
-- For detailed instructions on editing your key bindings, see
-- "XMonad.Doc.Extending#Editing_key_bindings".

-- | Give focus to the nth window of the current workspace.
focusNth :: Int -> X ()
focusNth = windows . modify' . focusNth'

focusNth' :: Int -> Stack a -> Stack a
focusNth' n s@(Stack _ ls rs) | (n < 0) || (n > length ls + length rs) = s
                              | otherwise = listToStack n (integrate s)

-- | Swap current window with nth. Focus stays in the same position
swapNth :: Int -> X ()
swapNth = windows . modify' . swapNth'

swapNth' :: Int -> Stack a -> Stack a
swapNth' n s@(Stack c l r)
  | (n < 0) || (n > length l + length r) || (n == length l) = s
  | n < length l = let (nl, nc:nr) = splitAt (length l - n - 1) l in Stack nc (nl ++ c : nr) r
  | otherwise    = let (nl, nc:nr) = splitAt (n - length l - 1) r in Stack nc l (nl ++ c : nr)

listToStack :: Int -> [a] -> Stack a
listToStack n l = Stack t ls rs
 where
    (t:rs)    = drop n l
    ls        = reverse (take n l)
