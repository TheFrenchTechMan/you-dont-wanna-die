local function clear_tech(force, tech_name)
    

    local t = {}

    local function get_tech_and_neighbour(filtered_tech)
        for _, data in pairs(force.technologies) do
            for _, req in pairs(data.prerequisites) do
                if req.name == filtered_tech then
                    force.technologies[data.name].researched = false
                    force.technologies[req.name].researched = false
                    t[#t + 1] = data.name
                end
            end
        end
    end

    get_tech_and_neighbour(tech_name)

    if #t > 0 then
        for _, tech in pairs(t) do
            get_tech_and_neighbour(tech)
        end
    end
end

script.on_event(
    defines.events.on_player_died,
    function(event)
        local player_index = event.player_index
        local player = game.get_player(player_index)
        local force = player.force
        

        --MARK: TECH CLEARER
        if settings.global["tech-clearer"].value == true then
            local techs = {}
            for _, data in pairs(force.technologies) do
                if data.researched then
                    techs[#techs + 1] = data.name
                end
            end

            local count = #techs

            if count > 0 then
            
                local tech_name = techs[math.random(1, count)]
                if tech_name then
                    clear_tech(force, tech_name)
                    game.print('Cleared ' .. tech_name .. ' for ' .. force.name)
                end
            end
        end

        --MARK: ENTITY REMOVER
        if settings.global["entity-remover"].value > 0 then
            local entities = game.surfaces["nauvis"].find_entities()
            local selected_entity = entities[math.random(#entities)]
            game.print(selected_entity)
        end
    end
)