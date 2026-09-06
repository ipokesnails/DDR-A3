local function WheelMove(mov)
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
    mw:Move(mov)
end

local pressed = {
    MenuDown=false, MenuLeft=false, MenuRight=false,
    Down=false, Left=false, Right=false
}

local function TestSelectedSong()                                              -- Added for favorites list testing
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")                 -- Added for favorites list testing

    if not mw then                                                             -- Added for favorites list testing
        print("FAVORITES TEST: MusicWheel not found")                          -- Added for favorites list testing
        return                                                                 -- Added for favorites list testing
    end                                                                        -- Added for favorites list testing

    local song = mw:GetSelectedSong()                                          -- Added for favorites list testing

    if song then                                                               -- Added for favorites list testing
        print("FAVORITES TEST: Selected song = "..song:GetDisplayMainTitle())  -- Added for favorites list testing
        print("FAVORITES TEST: Song dir = "..song:GetSongDir())                -- Added for favorites list testing
    else                                                                       -- Added for favorites list testing
        print("FAVORITES TEST: No song selected")                              -- Added for favorites list testing
    end                                                                        -- Added for favorites list testing
end                                                                            -- Added for favorites list testing

local function InputHandler(event)
    local player = event.PlayerNumber

    if event.type == "InputEventType_FirstPress" and event.GameButton == "Coin" then    -- Added for favorites list testing  -- Using coin button as potential unused input
    TestSelectedSong()                                                                  -- Added for favorites list testing
    end                                                                                 -- Added for favorites list testing
    
    local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel")
    if event.type == "InputEventType_Release" then
        pressed[event.GameButton] = false
        return false
    end

    pressed[event.GameButton] = true

    local downHeld = pressed["MenuDown"] or pressed["Down"]
    local leftHeld = pressed["MenuLeft"] or pressed["Left"]
    local rightHeld = pressed["MenuRight"] or pressed["Right"]

    local currentStyle = GAMESTATE:GetCurrentStyle():GetName()
    
    if currentStyle ~= "versus" then
        if downHeld and rightHeld and currentStyle ~= "double" then
            setenv("ForceStyle", "double")
            SCREENMAN:SetNewScreen("ScreenSelectMusic")
            return
        elseif downHeld and leftHeld and currentStyle ~= "single" then
            setenv("ForceStyle", "single")
            SCREENMAN:SetNewScreen("ScreenSelectMusic")
            return
        end
    end
    if MusicWheel ~= nil then
        if event.GameButton == "MenuLeft" and GAMESTATE:IsPlayerEnabled(player) then
            SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        end
        if event.GameButton == "MenuRight" and GAMESTATE:IsPlayerEnabled(player) then
            SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        end
        if event.GameButton == "MenuDown" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
            if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
                WheelMove(3)
                if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
                    WheelMove(-2)
                    if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                        WheelMove(2)
                        if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
                            WheelMove(-1)
                            if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                                WheelMove(1)
                            end
                        end
                    end
                end
            else
                MusicWheel:Move(1)
            end
            MusicWheel:Move(0)
            SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        end
        if event.GameButton == "MenuUp" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
            if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
                WheelMove(-3)
                if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
                    WheelMove(2)
                    if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                        WheelMove(-2)
                        if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
                            WheelMove(1)
                            if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                                WheelMove(-1)
                            end
                        end
                    end
                end
            else
                WheelMove(-1)
            end
            WheelMove(0)
            SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        end
    end
end

return Def.ActorFrame{
    OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) end;
    OffCommand=function(self) SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler) end,
    SongChosenMessageCommand=function(self) self:playcommand("Off") end;
    SongUnchosenMessageCommand=function(self)
        self:sleep(0.5):queuecommand("On");
    end;
};
