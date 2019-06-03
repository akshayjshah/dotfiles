-- Terminal customizations

local function newTerminal()
    hs.application.launchOrFocus('Terminal')
end

hs.hotkey.bind({'ctrl', 'cmd'}, 'return', newTerminal)
