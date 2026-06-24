core.register_on_cheat(function(ObjectRef, cheat)
    -- core.ban_player(ObjectRef:get_player_name()) -- I'm not sure...
    core.kick_player(ObjectRef:get_player_name(), "The server admin did not allow you to be doing "..cheat.type)
end)


local function inv_formspec(player)
    local name = player:get_player_name()
    -- return table.concat({
	-- 	"formspec_version[8]",
	-- 	"size[15,15]",
	-- 	-- Player inventory (backpack): keep the same slots; adjust coordinates as you like
	-- 	"label[0.3,3.3;Inventory]",
	-- 	"list[current_player;main;0.5,3.6;8,1; ]",
	-- 	"list[current_player;main;0.5,4.6;8,4; ]",

	-- 	"label[0.3,0.9;Crafting (2x2)]",
	-- 	-- 2x2 crafting grid: the engine’s "craft" list is what matters;
	-- 	-- we only *display* it in a 2x2 area.
	-- 	"list[current_player;craft;0.25,1.6;2,2; ]",
	-- 	"list[current_player;craftpreview;3.0,1.6;1,1; ]",

	-- 	"listring[current_player;main]",
	-- 	"listring[current_player;craft]"
	-- })
    return table.concat({
        "size[8,7.5]",
        "model[1,0.6;1,2;Player Character;player.obj;player.png]",
        "list[current_player;main;0,3.5;8,4;]",
        "list[current_player;craft;4,0.5;2,2;]",
        "list[current_player;craftpreview;7,1;1,1;]"
    })
end

core.register_on_joinplayer(function(ObjectRef, last_login)
    ObjectRef:set_inventory_formspec(inv_formspec(ObjectRef))
end)