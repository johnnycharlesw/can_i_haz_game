core.register_node("stones:stone", {
    description = "Stone Block",
    tiles = {"stone.png"}
})
core.register_node("stones:cobblestone", {
    description = "Cobblestone Block",
    tiles = {"cobblestone.png"}
})
core.register_node("stones:obsidian", {
    description = "Obsidian",
    tiles = {"obsidian.png"}
})

core.register_alias("default:checker", "stones:stone")
core.register_alias("default:stone", "stones:stone")
core.register_alias("default:cobblestone", "stones:cobblestone")