core.register_on_joinplayer(function(ObjectRef, last_login)
    core.log(ObjectRef:get_player_name() .. " joined the game")
    ObjectRef:set_properties({
        visual      = "mesh",
        mesh        = "player.obj",
        textures    = {"player.png"},
        visual_size = {x=-10, y=10},
    })
end)


core.register_entity("player_manager:npc_builder", {
  initial_properties = {
    visual      = "mesh",
    mesh        = "player.obj",
    textures    = {"npc.png"},
    visual_size = {x=10, y=10},
    physical = true,
    collide_with_objects = true,
    collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},

    stepheight = 0.6
  },
  on_activate = function (self, staticdata, dtime_s)
    -- This is an old NPC that does not work anymore - respawn it as a new version of the NPC
    local pos = self.object:get_pos()
    local name = "npc:npc"
    local staticdata = self:get_staticdata(self)
    core.add_entity(pos, name, staticdata)
    self.object:remove()
  end,
    get_staticdata = function(self)
    return core.serialize({
      state = self.state,
      reaction_until = self.reaction_until,
      wander_target = self.wander_target,
      last_react_at = self.last_react_at,
      name_ = self.name_
    })
  end,
})