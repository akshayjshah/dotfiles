-- Keybindings:
--
-- ctrl-cmd + L
--      Start the screen saver.
--
-- ctrl-alt + up/down/left/right
--      Move a window in the specified direction.
--
-- ctrl-alt-cmd + up/down/left/right
--      Resize the window in the specified direction while keeping the
--      top-left anchored.
--
-- ctrl-cmd + up/down/left/right
-- ctrl-shift-option-cmd (hyper) + up/down/left/right
--      Smart resize. By default, left/right resize to take half the screen.
--      When already taking half the screen, cycle through taking a third and
--      two-thirds. Up takes the whole screen and down takes the center
--      third.
--
-- ctrl-cmd + Enter:
--      Launch or focus Alacritty.

-----------------------------------------------------------------------------
-- Reload automatically when this file changes
-----------------------------------------------------------------------------

local function reload(files)
    local shouldReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == '.lua' then
            shouldReload = true
        end
    end
    if shouldReload then
        hs.reload()
    end
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reload):start()

-----------------------------------------------------------------------------
-- Global configuration
-----------------------------------------------------------------------------

-- Set up grid
local GRIDWIDTH = 6
local GRIDHEIGHT = 1
hs.grid.setGrid(GRIDWIDTH .. 'x' .. GRIDHEIGHT)
hs.grid.setMargins({w = 0, h = 0})
hs.grid.ui.textSize = 16

-- No animations
hs.window.animationDuration = 0

require('term')
require('lock')
require('sections')
