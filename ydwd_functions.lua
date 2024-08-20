local ydwd_functions = {}



function ydwd_functions.clear_tech(force, tech_name)
    

    local t = {}

    function get_tech_and_neighbour(filtered_tech)
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


function ydwd_functions.get_valid_entities()
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
        invert=true
    }
end

function ydwd_functions.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end


return ydwd_functions