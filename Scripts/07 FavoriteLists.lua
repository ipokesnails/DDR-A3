FavoriteLists = {}

local function GetPrefs(profileID)
        local prefs = ProfilePrefs.Read(profileID)

        if not prefs.favoriteLists then
                prefs.favoriteLists = {}
        end

        return prefs
end

function FavoriteLists.GetLists(profileID)
        local prefs = GetPrefs(profileID)
        return prefs.favoriteLists
end

function FavoriteLists.Create(profileID, listName)
        local prefs = GetPrefs(profileID)

        if not listName or listName == "" then
                return false
        end

        if prefs.favoriteLists[listName] then
                return false
        end

        prefs.favoriteLists[listName] = {}
        ProfilePrefs.Save(profileID)

        return true
end

function FavoriteLists.Delete(profileID, listName)
        local prefs = GetPrefs(profileID)

        if not prefs.favoriteLists[listName] then
                return false
        end

        prefs.favoriteLists[listName] = nil
        ProfilePrefs.Save(profileID)

        return true
end

function FavoriteLists.Contains(profileID, listName, song)
        local prefs = GetPrefs(profileID)
        local list = prefs.favoriteLists[listName]

        if not list or not song then
                return false
        end

        return list[song:GetSongDir()] == true
end

function FavoriteLists.Add(profileID, listName, song)
        local prefs = GetPrefs(profileID)

        if not song then
                return false
        end

        local list = prefs.favoriteLists[listName]

        if not list then
                return false
        end

        local songDir = song:GetSongDir()

        if list[songDir] then
                return false
        end

        list[songDir] = true
        ProfilePrefs.Save(profileID)

        return true
end

function FavoriteLists.Remove(profileID, listName, song)
        local prefs = GetPrefs(profileID)

        if not song then
                return false
        end

        local list = prefs.favoriteLists[listName]

        if not list then
                return false
        end

        local songDir = song:GetSongDir()

        if not list[songDir] then
                return false
        end

        list[songDir] = nil
        ProfilePrefs.Save(profileID)

        return true
end

function FavoriteLists.Toggle(profileID, listName, song)
        if FavoriteLists.Contains(profileID, listName, song) then
                return FavoriteLists.Remove(profileID, listName, song)
        else
                return FavoriteLists.Add(profileID, listName, song)
        end
end
