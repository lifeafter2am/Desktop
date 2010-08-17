import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W

-- layouts
import XMonad.Layout
import XMonad.Layout.IM
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Reflect
import XMonad.Layout.Combo
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import Data.Ratio ((%))
import XMonad.Layout.Gaps


-- layout definitions
customLayout = gaps [(D,16)] $ avoidStruts $ ResizableTall 2 (3/100) (1/2) [] ||| withIM (1%7) (ClassName "Buddy List") Grid ||| layoutHook defaultConfig

-- Workspaces
myWorkspaces = ["1:term","2:www","3:blender","4:media","5:image"] ++ map show [6..9] 

-- Window rules
myManageHook = composeAll
	[ title =? "Blender" --> doShift "3:blender"
	, title =? "SmallLuxGPU v1.6beta2dev (LuxRays demo: http://www.luxrender.net)" --> doFloat
	, title =? "SmallLuxGPU v1.6beta3dev (LuxRays demo: http://www.luxrender.net)" --> doFloat
	, title =? "Namoroka" --> doShift "2:www"
	, className =? "Gimp" --> doShift "5:image"
	, title =? "Nitrogen" --> doShift "5:image"
	]

-- icons directory
myBitmapsDir = "/home/ishikawa/.dzen"

-- main config
main = do
    dzenSbar <- spawnPipe sBarCmd
    dzenConkyTop <- spawnPipe topBarCmd
    dzenConkyBot <- spawnPipe botBarCmd
    spawn "xcompmgr"  
    xmonad $ defaultConfig
        { manageHook = myManageHook <+> manageHook defaultConfig
        , terminal = "urxvt"
        , workspaces = myWorkspaces
        , borderWidth = 0
        , normalBorderColor = "#000000"
        , focusedBorderColor = "#3399ff"
        , layoutHook = customLayout
        , logHook = dynamicLogWithPP $ myDzenPP dzenSbar
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        ([ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
	, ((mod4Mask, xK_a), sendMessage MirrorShrink)
	, ((mod4Mask, xK_z), sendMessage MirrorExpand)
	]
	 ++
 
	  --
  	  -- mod-[1..9], Switch to workspace N
          -- mod-shift-[1..9], Move client to workspace N
	  --
        [((m .|. mod4Mask, k), windows $ f i)
        | (i, k) <- zip (myWorkspaces) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]])



-- dzen config
sBarCmd = "dzen2 -fn nu -bg '#000000' -fg '#ffffff' -h 16 -w 840 -ta l"
topBarCmd = "conky -c ~/.conkyrc | dzen2 -fn nu -bg '#000000' -fg '#ffffff' -h 16 -w 840 -x 840 -ta r"
botBarCmd = "conky -c ~/.conky_bottom_dzen | dzen2 -fn nu -bg '#000000' -fg '#ffffff' -h 16 -y 1034 -w 1680 -ta c"

myDzenPP dzenSbar = defaultPP
     { ppCurrent = wrap "^p()^fg(#1086b8)" "^fg()^p()"
     , ppUrgent = wrap "!^fg(purple)^p()" "^fg()^p()"
     , ppVisible = wrap "^p()^fg()" "^fg()^p()"
     , ppTitle = wrap "^fg(#1086b8) ^fg(#ffffff)" "^fg(#1086b8) ^fg()" . shorten 90
     , ppSep = " : "
     , ppWsSep = " : "
     , ppLayout = dzenColor "#1086b8" "#000000" .
            (\x -> case x of
                   "Tall" -> "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                   "Mirror Tall" -> "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                   "Full" -> "^i(" ++ myBitmapsDir ++ "/full.xbm)"
		   "ResizableTall" -> "^i(" ++ myBitmapsDir ++ "/resizableGrid.xbm)"
		   "IM Grid" -> "^i(" ++ myBitmapsDir ++ "/im-layout.xbm)"
                   _ -> x
                   )
     , ppOutput = hPutStrLn dzenSbar
}
