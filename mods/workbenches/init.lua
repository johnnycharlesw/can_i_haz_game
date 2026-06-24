function on_rightclick_crafting_table (pos, node, player)
    local meta = core.get_meta(pos)
    local inv = meta:get_inventory()

    -- 3x3 crafting grid + output
    local formspec =
    "size[8,7.5]"..
    "model[1,0.6;1,2;Player Character;player.obj;player.png]"..
    "list[current_player;main;0,3.5;8,4;]"..
    "list[current_player;craft;3,0;3,3;]"..
    "list[current_player;craftpreview;7,1;1,1;]"

    -- show formspec for this node's inventory
    core.show_formspec(player:get_player_name(), "yourgame:crafting_table_formspec", formspec, {pos=pos})
end


core.register_node("workbenches:crafting_table", {
    description = "Crafting Table",
    tiles = {
        "crafting_table_top.png", -- Top
        "oak_planks.png", -- Bottom
        "crafting_table_side.png", -- Right
        "crafting_table_side.png", -- Left
        "crafting_table_side.png", -- Back
        "crafting_table_side.png" -- Front
    },
    on_rightclick = on_rightclick_crafting_table
    
})


core.register_craft({
    output = "workbenches:crafting_table",
    recipe = {
        {"default:oak_planks", "default:oak_planks"},
        {"default:oak_planks", "default:oak_planks"}
    }
})

core.register_alias("default:crafting_table", "workbenches:crafting_table")