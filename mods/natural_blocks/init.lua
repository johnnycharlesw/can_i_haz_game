core.register_node("natural_blocks:grass", {
    description = "Grass Block",
    tiles = {"grass_block_top.png"}
})
core.register_node("natural_blocks:dirt", {
    description = "Dirt Block",
    tiles = {"dirt.png"}
})

core.register_node("natural_blocks:oak_log", {
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
core.register_node("natural_blocks:oak_leaves", {
    description = "Oak Leaves",
    drawtype = "allfaces_optional",
    tiles = {
        "oak_leaves.png"
    },
    paramtype = "light",
    sunlight_propagates = true,
    groups = {tree=1, leafdecay=1, snappy=3, leaves=1},
    use_texture_alpha = true
})

core.register_alias("default:grass", "natural_blocks:grass")
core.register_alias("default:dirt", "natural_blocks:dirt")
core.register_alias("default:oak_log", "natural_blocks:oak_log")
core.register_alias("default:oak_leaves", "natural_blocks:oak_leaves")
