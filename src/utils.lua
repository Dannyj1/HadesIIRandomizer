--[[
Copyright 2024 Danny Jelsma

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

if not Hades2Randomizer.Config.Enabled then
    return
end

function Hades2Randomizer.tableContains(table, value)
    if table == nil then
        return false
    end

    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

function Hades2Randomizer.splitOnCapitalLetters(str)
    local parts = {}
    local currentPart = ""

    for i = 1, #str do
        local char = string.sub(str, i, i)
        if char.match(char, "%u") then
            if currentPart ~= "" then
                table.insert(parts, currentPart)
            end
            currentPart = char
        else
            currentPart = currentPart .. char
        end
    end

    if currentPart ~= "" then
        table.insert(parts, currentPart)
    end

    return parts
end
