-- Terminal customizations

local function newTerminal()
    hs.application.launchOrFocus('Alacritty')
end

hs.hotkey.bind({'ctrl', 'cmd'}, 'return', newTerminal)
