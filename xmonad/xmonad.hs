import Data.Monoid
import System.Exit
import System.IO

import qualified Data.Map as Map

import XMonad

import qualified Graphics.X11.ExtraTypes.XF86 as XF86
import qualified XMonad.Actions.CycleWS as CycleWS
import qualified XMonad.Actions.Submap as Submap
import qualified XMonad.Actions.Warp as Warp
import qualified XMonad.Hooks.EwmhDesktops as EwmhDesktops
import qualified XMonad.Hooks.ManageDocks as ManageDocks
import qualified XMonad.Hooks.ManageHelpers as ManageHelpers
import qualified XMonad.Layout.NoBorders as NoBorders
import qualified XMonad.StackSet as StackSet
import qualified XMonad.Util.EZConfig as EZConfig
import qualified XMonad.Util.Run as Run

mastrumadaKroĉilo :: ManageHook
mastrumadaKroĉilo =
  composeAll . concat $
  [ [title =? w --> doFloat | w <- titoloFlosigi]
  , [title =? w --> doSink | w <- titoloMalflosigi]
  , [className =? w --> doFloat | w <- klasoFlosigi]
  , [className =? w --> doSink | w <- klasoMalflosigi]
  , [title =? w --> ManageHelpers.doHideIgnore | w <- titoloKaŝi]
  ]
  where
    titoloFlosigi = []
    titoloMalflosigi = []
    klasoFlosigi = ["Xmessage", "Gxmessage", "Gimp"]
    klasoMalflosigi = ["Mpv", "TeamViewer.exe", "Vncviewer", "skanlite", "Wine"]
    titoloKaŝi = ["Wine System Tray"]
    doSink = ask >>= doF . StackSet.sink

modMasko :: KeyMask
modMasko = mod4Mask

terminalo :: String
terminalo = "tx"

bordaLarĝo :: Dimension
bordaLarĝo = 1

normalaBordaKoloro :: String
normalaBordaKoloro = "#000"

fokusitaBordaKoloro :: String
fokusitaBordaKoloro = "#696969"

fokusoSekvasMuson :: Bool
fokusoSekvasMuson = True

klakoNurFokusas :: Bool
klakoNurFokusas = True

laborSpacoj :: [String]
laborSpacoj = map show $ [1 .. 9] ++ [0]

klavoj =
  [ ((controlMask, xK_Escape), kill)
  , ((mod1Mask, xK_space), sendMessage NextLayout)
  , ((mod1Mask .|. shiftMask, xK_space), asks config >>= setLayout . layoutHook)

  , ((mod1Mask .|. controlMask, xK_Delete), io (exitWith ExitSuccess))

  , ((mod1Mask, xK_Tab), windows StackSet.focusDown)
  , ((mod1Mask .|. shiftMask, xK_Tab), windows StackSet.focusUp)

  , ((0, XF86.xF86XK_MonBrightnessDown), spawn "xbacklight -set 0")
  , ((0, XF86.xF86XK_MonBrightnessUp), spawn "xbacklight -set 100")
  , ((0, XF86.xF86XK_Display), spawn "disper -e")
  , ((shiftMask, XF86.xF86XK_Display), spawn "disper -c")

  , ((mod1Mask, xK_Prior), CycleWS.prevWS)
  , ((mod1Mask, xK_Next), CycleWS.nextWS)

  , ( (controlMask, xK_semicolon)
    , Submap.submap . Map.fromList $
      [ ((0, xK_Return), windows StackSet.swapMaster)
      , ((0, xK_space), CycleWS.toggleWS)

      , ((0, xK_minus), sendMessage (IncMasterN (-1)))
      , ((0, xK_equal), sendMessage (IncMasterN 1))
      , ((shiftMask, xK_minus), sendMessage Shrink)
      , ((shiftMask, xK_equal), sendMessage Expand)

      , ((0, xK_Prior), withFocused float)
      , ((0, xK_Next), withFocused $ windows . StackSet.sink)

      , ((controlMask, xK_Up), windows StackSet.swapUp)
      , ((controlMask, xK_Down), windows StackSet.swapDown)

      , ((0, xK_period), spawn "xmonad --recompile; xmonad --restart")
      , ((shiftMask, xK_1), spawn "xrun")
      , ((0, xK_b), Warp.banishScreen Warp.LowerRight)

      , ((0, xK_a), spawn "za")
      , ((0, xK_x), spawn "x")
      , ((0, xK_o), spawn "o")
      , ((0, xK_t), spawn "tx")
      , ((0, xK_v), spawn "vv")
      , ((0, xK_c), spawn "cv")
      , ((0, xK_w), spawn "sw")
      , ((0, xK_z), spawn "zu")

      , ((0, xK_d), spawn "wallpaper chromecast")
      , ((shiftMask, xK_d), spawn "wallpaper wallhaven")

      , ((0, xK_e), spawn "screenshot region")
      , ((shiftMask, xK_e), spawn "screenshot full")
      ])
  ]

main :: IO ()
main =
  xmonad $
  defaultConfig
    { modMask = modMasko
    , terminal = terminalo
    , workspaces = laborSpacoj
    , borderWidth = bordaLarĝo
    , normalBorderColor = normalaBordaKoloro
    , focusedBorderColor = fokusitaBordaKoloro
    , focusFollowsMouse = fokusoSekvasMuson
    , clickJustFocuses = klakoNurFokusas
    , logHook = EwmhDesktops.ewmhDesktopsLogHook
    , layoutHook =
        ManageDocks.avoidStruts $
        NoBorders.smartBorders $ layoutHook defaultConfig
    , handleEventHook = EwmhDesktops.ewmhDesktopsEventHook
    , startupHook = EwmhDesktops.ewmhDesktopsStartup
    , manageHook =
        ManageDocks.manageDocks <+>
        mastrumadaKroĉilo <+> manageHook defaultConfig
    } `EZConfig.additionalKeysP`
  [ ("C-" ++ otherModMasks ++ [key], action tag)
  | (tag, key) <- zip laborSpacoj (concat laborSpacoj)
  , (otherModMasks, action) <-
      [("", windows . StackSet.view), ("S-", windows . StackSet.shift)]
  ] `EZConfig.additionalKeys`
  klavoj `EZConfig.additionalMouseBindings`
  -- fenestron movi kaj ĝin malkaheligi
  [ ( (mod1Mask, button1)
    , \w -> focus w >> mouseMoveWindow w >> windows StackSet.shiftMaster)
  -- fenestron altigi al la supro de la stako
  , ((mod1Mask, button2), windows . (StackSet.shiftMaster .) . StackSet.focusWindow)
  -- fenestron flosigi kaj ĝin regrandigi per trenado
  , ( (mod1Mask, button3)
    , \w -> focus w >> mouseResizeWindow w >> windows StackSet.shiftMaster)
  ]
