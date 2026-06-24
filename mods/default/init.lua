core.register_node("default:grass", {
    description = "Grass Block",
    tiles = {"grass_block_top.png"}
})
core.register_node("default:dirt", {
    description = "Dirt Block",
    tiles = {"dirt.png"}
})


core.register_node("default:air", {
  description = "Air",
  drawtype = "airlike",     -- tell engine this is an airlike node
  paramtype = "light",     -- (common for airlike-type visuals)
  sunlight_propagates = true,
  walkable = false,
  pointable = false,
  buildable_to = true,     -- allows placement/doesn’t block
  climbable = false,
  diggable = false,
  groups = { not_in_creative_inventory = 1, unbreakable = 1 },
})
core.register_alias("air", "default:air")


core.register_node("default:oak_log", {
    description = "Oak Log",
    tiles = {
        "oak_log_top.png", -- Top
        "oak_log_top.png", -- Bottom
        "oak_log.png", -- Right
        "oak_log.png", -- Left
        "oak_log.png", -- Back
        "oak_log.png" -- Front
    }
})
core.register_node("default:oak_planks", {
    description = "Oak Planks",
    tiles = {
        "oak_planks.png"
    }
})

core.register_node("default:lamp", {
    paramtype = "light",
    paramtype2="none",
    description = "Lamp (on)",
    walkable = false,
    sunlight_propagates = true,

    light_source = 12, 
    tiles = {
        "redstone_lamp_on.png" -- Torch
    }
})
core.register_alias("default:redstone_torch", "default:lamp")

core.register_alias("default:purple_checker", "default:dirt")
core.register_alias("default:black_checker", "default:dirt")

core.register_craft({
    type = "shapeless",
    output = "default:grass 1",
    recipe = {
        "default:dirt"
    }
})

core.register_craft({
    type = "shapeless",
    output = "default:oak_planks 4",
    recipe = {"default:oak_log"}
})


core.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    diggable = true
    prop_unbreakable = core.get_item_group(node.name, "unbreakable")
    if prop_unbreakable == 1 then
        diggable = false
    else
        diggable = true
    end
    if diggable then
        if core.is_creative_enabled(puncher:get_player_name()) then
            core.dig_node(pos)
        else
            core.log("Should change digging status!")
        end
    end
end)

local function fixtime()
    local t = os.date("*t")           -- server local time
    local seconds = t.hour * 3600 + t.min * 60 + t.sec
    local day_fraction = seconds / 86400
    local game_time = math.floor(day_fraction * 24000) % 24000  -- 0..23999

    core.set_timeofday(game_time/24000)
end

core.register_chatcommand("fixtime", {
    privs = { interact = true },
    func = fixtime,
})

core.register_globalstep(fixtime)