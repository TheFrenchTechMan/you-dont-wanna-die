---@diagnostic disable: cast-local-type

ydwd = require "ydwd_functions"

--MARK:MAIN SCRIPT
script.on_event(
    defines.events.on_player_died,
    function(event)
        local player_index = event.player_index
        local player = game.get_player(player_index)
        local force = player.force
        

        --MARK: TECH CLEARER
        if settings.global["tech-clearer"].value == true then
            local techs = {}
            local localised_techs = {}
            for _, data in pairs(force.technologies) do
                if data.researched then
                    techs[#techs + 1] = data.name
                end
            end

            local count = #techs

            if count > 0 then
                local tech_name = techs[math.random(1, count)]
                if tech_name then
                    ydwd.clear_tech(force, tech_name)
                    game.print('Cleared ' .. tech_name)
                end
            end
        end

        --MARK: ENTITY REMOVER
        if settings.global["entity-remover"].value > 0 then
            local settings_value = settings.global["entity-remover"].value
            valid_entities = ydwd.get_valid_entities()

            if #valid_entities >= settings_value then
                iters = settings_value
            else
                if #valid_entities > 1 then
                    iters = #valid_entities
                else
                    iters = 0
                end
            end
            if iters > 0 then
                for i = 1, iters, 1 do
                    local random_number = math.random(#valid_entities)
                    local selected_entity = valid_entities[random_number]
                    local posX = selected_entity.position["x"]
                    local posY = selected_entity.position["y"]
                    game.print("(" .. tostring(i) .. ") Removed entity " .. selected_entity.name .. " at position (" .. posX .. ";" .. posY .. ").")
                    table_pos = ydwd.indexOf(valid_entities, selected_entity)
                    table.remove(valid_entities, table_pos)
                    selected_entity.destroy()
                end
            else
                game.print("There is nothing left to remove!")
            end
        end
    end
)