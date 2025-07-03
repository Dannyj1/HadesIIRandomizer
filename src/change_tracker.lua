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

local NIL_VALUE_MARKER = {}

Hades2Randomizer.ChangeTracker = {}

function Hades2Randomizer.trackAndChange(targetTable, key, newValue)
    if Hades2Randomizer.ChangeTracker[targetTable] == nil then
        Hades2Randomizer.ChangeTracker[targetTable] = {}
    end

    if Hades2Randomizer.ChangeTracker[targetTable][key] == nil then
        local originalValue = targetTable[key]
        if originalValue == nil then
            Hades2Randomizer.ChangeTracker[targetTable][key] = NIL_VALUE_MARKER
        elseif type(originalValue) == 'table' then
            Hades2Randomizer.ChangeTracker[targetTable][key] = DeepCopyTable(originalValue)
        else
            Hades2Randomizer.ChangeTracker[targetTable][key] = originalValue
        end
    end

    targetTable[key] = newValue
end

function Hades2Randomizer.revertAllChanges()
    for tbl, changes in pairs(Hades2Randomizer.ChangeTracker) do
        for key, originalValue in pairs(changes) do
            if originalValue == NIL_VALUE_MARKER then
                tbl[key] = nil
            else
                tbl[key] = originalValue
            end
        end
    end

    Hades2Randomizer.ChangeTracker = {}
    DebugPrint({ Text = "All changes have been reverted." })
end
