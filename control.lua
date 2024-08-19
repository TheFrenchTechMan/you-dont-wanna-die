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

local function get_valid_entities()
    return game.surfaces["nauvis"].find_entities_filtered{
        type={
        "ammo", 
        "ammo-category", 
        "character",
        "cliff", 
        "corpse", 
        "entity-ghost", 
        "explosion", 
        "fire",
        "fish", 
        "fluid", 
        "optimized-decorative", 
        "optimized-particle", 
        "projectile", 
        "resource", 
        "simple-entity", 
        "tile", 
        "tree", 
        "unit"
        }, 
        name="character-corpse", 
        valid=false, --remember, it's reversed
        invert=true
    }
end

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
            local j = 0
            local entities = get_valid_entities()
            local entity_count = #entities
            if entity_count == 0 then
                game.print("You're so poor the mod found nothing to remove!")
            end
            if entity_count < settings.global["entity-remover"].value then
                j = entity_count
            else
                j = settings.global["entity-remover"].value
            end
            for i = 1, j, 1 do
                local entities = get_valid_entities()
                local entity_count = #entities
                if entity_count < settings.global["entity-remover"].value then
                    j = entity_count
                else
                    j = settings.global["entity-remover"].value
                end
                local random_number = math.random(j)
                local selected_entity = entities[random_number] --it says error but it's fine
                local posX = selected_entity.position["x"]
                local posY = selected_entity.position["y"]                    
                game.print("(" .. tostring(i) .. ") Removed entity " .. selected_entity.name .. " at position (" .. posX .. ";" .. posY .. ").")
                selected_entity.destroy()
            end
        end
    end
)