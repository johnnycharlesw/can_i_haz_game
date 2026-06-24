wool_colors = {"Black", "Blue", "Brown", "Cyan", "Gray", "Green", "Light Blue", "Light Gray", "Lime", "Magenta", "Orange", "Pink", "Purple", "Red", "White", "Yellow"}

function generate_id_from_color (color)
    id = string.lower(color)
    id = string.gsub(id, " ", "_") .. "_wool"
    return id
end

for index, value in ipairs(wool_colors) do
    id = generate_id_from_color(value)
    nodeid = "wool:"..id
    image = id..".png"
    core.register_node(nodeid, {
        description = value.." Wool",
        tiles = {image}
    })
    core.register_alias(id, nodeid)
end