core.register_alias("wood:oak_log", "natural_blocks:oak_log")
core.register_node("wood:oak_planks", {
    description = "Oak Planks",
    tiles = {
        "oak_planks.png"
    }
})
core.register_craft({
    type = "shapeless",
    output = "wood:oak_planks 4",
    recipe = {"natural_blocks:oak_log"}
})
core.register_alias("default:oak_planks", "wood:oak_planks")