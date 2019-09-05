local grid = hs.grid.getGrid()
local GRIDWIDTH = grid.w
local GRIDHEIGHT = grid.h

local function round(num)
    return math.floor(num + 0.5)
end

-- Different sections of the screen that a window can take.
local SECTIONS = {
    rightTwoThird = {
        x = GRIDWIDTH - round(GRIDWIDTH / 3) * 2,
        y = 0,
        w = round(GRIDWIDTH / 3) * 2,
        h = GRIDHEIGHT
    },
    right = {
        x = round(GRIDWIDTH / 2),
        y = 0,
        w = round(GRIDWIDTH / 2),
        h = GRIDHEIGHT
    },
    rightThird = {
        x = GRIDWIDTH - round(GRIDWIDTH / 3),
        y = 0,
        w = round(GRIDWIDTH / 3),
        h = GRIDHEIGHT
    },
    leftTwoThird = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 3) * 2,
        h = GRIDHEIGHT
    },
    left = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 2),
        h = GRIDHEIGHT
    },
    leftThird = {
        x = 0,
        y = 0,
        w = round(GRIDWIDTH / 3),
        h = GRIDHEIGHT
    },
    full = {
        x = 0,
        y = 0,
        w = GRIDWIDTH,
        h = GRIDHEIGHT
    },
    centerThird = {
        x = round(GRIDWIDTH / 3),
        y = 0,
        w = round(GRIDWIDTH / 3),
        h = GRIDHEIGHT
    },
}

local section = {
    -- default sections to which the given keys map
    defaults = {
        up    = 'full',
        right = 'right',
        down  = 'centerThird',
        left  = 'left',
    },
    -- transitions between sections based on the key that was pressed.
    transitions = {
        right = { right = 'rightThird' },
        rightThird = { right = 'rightTwoThird' },
        left = { left = 'leftThird' },
        leftThird     = { left  =  'leftTwoThird' },
    }
}

-- section.get(win) -> string
--
-- Get the name of the section (as defined in SECTIONS) occupied by the given
-- window or nil if a match wasn't found.
function section.get(win)
    local current = hs.grid.get(win)
    for name, geom in pairs(SECTIONS) do
        if current:equals(geom) then
            return name
        end
    end
    return nil
end

-- section.set(win, name)
--
-- Resize the window to occupy the given section on the same screen.
function section.set(win, name)
    local geom = SECTIONS[name]
    if geom ~= nil then
        hs.grid.set(win, geom, win:screen())
    end
end

function sectionResizer(direction, defaultSection)
    return function()
        local win = hs.window.focusedWindow()
        if win == nil then
            return
        end

        local sec = section.get(win)
        if sec == nil then
            section.set(win, defaultSection)
            return
        end

        local transitions = section.transitions[sec]
        if transitions == nil then
            section.set(win, defaultSection)
            return
        end

        local target = transitions[direction]
        if target == nil then
            section.set(win, defaultSection)
            return
        end

        section.set(win, target)
    end
end

for direction, default in pairs(section.defaults) do
    hs.hotkey.bind(
        {'ctrl', 'cmd'}, direction, sectionResizer(direction, default))
    hs.hotkey.bind(
        {'ctrl', 'cmd', 'shift', 'option'}, direction, sectionResizer(direction, default))
end
