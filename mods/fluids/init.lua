core.register_node("fluids:water", {
    description = "Water (yes, I know it should spill, but I'll get to that soon)",
    tiles = {"water.png"},
    drawtype = "liquid",
    sunlight_propagates = true,
    walkable = false,
    pointable = false,
    buildable_to = true,     -- allows placement/doesn’t block
    climbable = false,
    diggable = false,
    groups = { not_in_creative_inventory = 1},
})
core.register_node("fluids:lava", {
    description = "Lava (yes, I know it should extremely burn, but I'll get to that soon)",
    tiles = {"lava.png"},
    drawtype = "liquid",
    walkable = false,
    pointable = false,
    buildable_to = true,     -- allows placement/doesn’t block
    climbable = false,
    diggable = false,
    light_source = 12,
    groups = { not_in_creative_inventory = 1},
})

core.register_alias("default:water", "fluids:water")
core.register_alias("default:lava", "fluids:lava")


