local function WheelMove(mov)
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
    mw:Move(mov)
end

local pressed = {
    MenuDown=false, MenuLeft=false, MenuRight=false,
    Down=false, Left=false, Right=false
}

local function ToggleFavoriteForPlayer(player)
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")

    if not mw then
        print("FAVORITES: MusicWheel not found")
        return
    end

    local song = mw:GetSelectedSong()

    if not song then
        print("FAVORITES: No song selected")
        return
    end

    local listName = "Favorites"
    local alreadyFavorite = FavoriteLists.Contains(player, listName, song)

    local success = FavoriteLists.Toggle(player, listName, song)

    if not success then
        print("FAVORITES: Failed to modify favorites")
        return
    end

    if alreadyFavorite then
        print("FAVORITES: Removed '" .. song:GetDisplayMainTitle() ..
              "' from " .. listName .. " for " .. tostring(player))
    else
        print("FAVORITES: Added '" .. song:GetDisplayMainTitle() ..
              "' to " .. listName .. " for " .. tostring(player))
    end
end

local function InputHandler(event)
    local player = event.PlayerNumber

    if event.type == "InputEventType_FirstPress" and event.GameButton == "Coin" then
        ToggleFavoriteForPlayer(player)
    end

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

                                                                -- PERFORMANCE TESTING CHANGES
                                                                -- Commented out music wheel sounds
    
    if MusicWheel ~= nil then
        if event.GameButton == "MenuLeft" and GAMESTATE:IsPlayerEnabled(player) then
            --SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        end
        if event.GameButton == "MenuRight" and GAMESTATE:IsPlayerEnabled(player) then
            --SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        end

                                                                        -- PERFORMANCE TESTING CHANGES
                                                                        -- Simplifying up and down down button presses
        
        --if event.GameButton == "MenuDown" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
        --    if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
        --        WheelMove(3)
        --        if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
        --            WheelMove(-2)
        --            if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
        --                WheelMove(2)
        --                if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
        --                    WheelMove(-1)
        --                    if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
        --                        WheelMove(1)
        --                    end
        --                end
        --            end
        --        end
        --    else
        --        MusicWheel:Move(1)
        --    end
        --    MusicWheel:Move(0)
        --    --SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        --end

        if event.GameButton == "MenuDown"
            and GAMESTATE:IsPlayerEnabled(player)
            and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then

            MusicWheel:Move(1)
            --SOUND:PlayOnce(THEME:GetPathS("", "_MusicWheel change"))
        end
        
        --if event.GameButton == "MenuUp" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
        --    if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
        --        WheelMove(-3)
        --        if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
        --            WheelMove(2)
        --            if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
        --                WheelMove(-2)
        --                if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
        --                    WheelMove(1)
        --                    if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
        --                        WheelMove(-1)
        --                    end
        --                end
        --            end
        --        end
        --    else
        --        WheelMove(-1)
        --    end
        --    WheelMove(0)
        --    --SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
        --end

        if event.GameButton == "MenuUp"
            and GAMESTATE:IsPlayerEnabled(player)
            and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then

            MusicWheel:Move(-1)
            --SOUND:PlayOnce(THEME:GetPathS("", "_MusicWheel change"))
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
