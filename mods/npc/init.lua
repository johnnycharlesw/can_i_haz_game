local function now_s()
  return core.get_us_time() / 1e6
end


-- Entity definition

class.define("npc", {
  initial_properties = {
    visual      = "mesh",
    mesh        = "player.obj",
    textures    = {"npc.png"},
    visual_size = {x=-10, y=10},
    physical = true,
    collide_with_objects = true,
    -- collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},

    stepheight = 0.6
  },

  generate_npc_username = function (self)
    if self.name_ then
       return
     end
    local prefixes = {"Focus", "Solidest", "Era", "Sneeky", "Spew", "Sweet", "celeron", "ruben", "sfan", "ners", "Small", "para", "est"}
    local suffixes = {"Pup", "Tiara", "", "Pat", "Dog", "pea", "wardy", "hul", "Joker", "mat"}
    local number = math.random(0,999)

    local prefixId = math.random(1, #prefixes)
    local suffixID = math.random(1, #suffixes)
    local prefix = prefixes[prefixId]
    local suffix = suffixes[suffixID]
    local baseString = prefix .. suffix
    local name
    if number == 0 then
      name = baseString 
    else
      name = baseString .. number
    end

    self.name_ = name
    
  end,

  constructor = function ()
    print("NPC registered")
  end,

  on_activate = function(self, staticdata, dtime_s)
    local data = staticdata and staticdata ~= "" and core.deserialize(staticdata) or {}
    self.state = data.state or "idle"
    self.reaction_until = data.reaction_until or 0
    self.wander_target = data.wander_target or nil
    self.last_react_at = data.last_react_at or 0
    local inv_size = 8
    self.generate_npc_username(self)
    self.inv = core.get_inventory({type="detached", name="npc_builder_" .. self.name_})
    --self.inv:set_size("main", inv_size)
  end,

  on_deactivate = function(self, removal) end,

  on_step = function(self, dtime, moveresult)

    -- gravity fallback (if your engine setup doesn’t apply it automatically)
    local v = self.object:get_velocity()
    -- self.object:set_velocity({x=v.x, y=v.y - 9.81 * dtime, z=v.z})

    local t = now_s()
    local mypos = self.object:get_pos()
    if not mypos then return end

    -- idle -> wander
    if (self.state or "idle") == "idle" then
      -- pick/refresh wander target occasionally
      if (not self.wander_target) or t >= (self.wander_until or 0) then
        -- target within radius, on same approximate Y (keeps it simple)
        local r = 10
        local dx = {x=0, y=(math.random()-0.5)*180, z=0}
        local angle = math.random() * math.pi * 2
        local dist = 3 + math.random() * 7
        local tx = mypos.x + math.cos(angle) * dist
        local tz = mypos.z + math.sin(angle) * dist

        -- Rotate the NPC
        self.object:set_rotation(dx)
        local up_bias = (math.random() < 0.5) and (1 + math.random() * 6) or 0
        self.wander_target = {x = tx, y = mypos.y + up_bias, z = tz}
        self.wander_until = t + 2.0
      end

      self.last_pos = self.last_pos or mypos
      self.stuck_time = self.stuck_time or 0



      if not self.path then
              -- move toward target
            local target = self.wander_target
            local max_height_change = 50
            local path = core.find_path(
                mypos,
                target,
                20,  -- search distance
                max_height_change,   -- max jump
                max_height_change,   -- max drop
                "A*"
            )
            if path and #path>1 then
              self.path_index = #path
              self.path=path
            else
              return
            end

      end



      -- if self.path and self.path_index <= #self.path then
      --   -- local vx = target.x - mypos.x
      --   -- local vz = target.z - mypos.z
      --   -- local dist = math.sqrt(vx*vx + vz*vz)

      --   -- -- stop if close
      --   -- if dist < 0.6 then
      --   --   self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
      --   -- else
      --   --   vx = vx / dist
      --   --   vz = vz / dist
      --   --   local speed = 2.5 -- tune
      --   --   self.object:set_velocity({x=vx * speed, y=self.object:get_velocity().y, z=vz * speed})
      --   -- end

        
      --   -- -- Check node ahead
      --   -- local ahead = vector.add(mypos, vector.multiply(vector.normalize(dir), 0.5))
      --   -- local node = core.get_node(vector.round(ahead))

      --   -- if core.registered_nodes[node.name].walkable then
      --   --     -- Attempt jump
      --   --     local vel = self.object:get_velocity()
      --   --     vel.y = 5
      --   --     self.object:set_velocity(vel)
      --   -- end
      --       local wp = self.path[self.path_index]
      --       if not wp then return end

      --       local dist = vector.distance(mypos, wp)
      --       local dir

      --       if dist < 0.5 then
      --           self.path_index = self.path_index + 1
      --       else
      --           dir = vector.direction(mypos, wp)

      --           self.object:set_velocity({
      --               x = dir.x * 2,
      --               y = self.object:get_velocity().y,
      --               z = dir.z * 2
      --           })
      --       end
      --   -- Check node ahead
      --   if not wp then
      --       return
      --   end

      --   local ahead = vector.add(
      --       mypos,
      --       vector.multiply(vector.direction(mypos, wp), 0.5)
      --   )
      --   local node = core.get_node(vector.round(ahead))

      --   if core.registered_nodes[node.name].walkable then
      --        -- Attempt jump
      --        local vel = self.object:get_velocity()
      --        vel.y = 5
      --        self.object:set_velocity(vel)
      --   end

      -- end
      
      -- must have: self.path, self.path_index
      if self.path and self.path_index and self.path_index < #self.path then
        local mypos = self.object:get_pos()
        local wp = self.path[self.path_index]
        if not (mypos and wp) then
          self.path = nil
          return
        end

        local dist = vector.distance(mypos, wp)
        if dist < 0.8 then
          self.path_index = self.path_index + 1
          return
        end

        local dir = vector.direction(mypos, wp)
        local vel = self.object:get_velocity()
        self.object:set_velocity({
          x = dir.x * 3,
          y = vel.y,      -- keep current vertical
          z = dir.z * 3
        })

        local moved = vector.distance(mypos, self.last_pos)
        if moved < 0.15 then
          self.stuck_time = self.stuck_time + dtime
        else
          self.stuck_time = 0
          self.last_pos = mypos
        end

        if self.stuck_time > 1.5 then
          -- forced escape attempt
          local vel = self.object:get_velocity()
          vel.y =vel.y + 6
          self.object:set_velocity(vel)

          -- force replanning / new wander target  
          self.path = nil
          self.path_index = nil
          self.wander_target = nil
          self.wander_until = 0
          self.stuck_time = 0
        end
      else
        self.path = nil
      end




      return
    end

    -- react -> chase puncher briefly
    if self.state == "react" then
      if t >= (self.reaction_until or 0) then
        self.state = "idle"
        self.last_react_at = t
        self.wander_target = nil
        self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
        return
      end

      local puncher_obj = self.puncher_obj
      if puncher_obj and puncher_obj:get_pos() then
        local ppos = puncher_obj:get_pos()
        local vx = ppos.x - mypos.x
        local vz = ppos.z - mypos.z
        local dist = math.sqrt(vx*vx + vz*vz)

        if dist < 1.0 then
          self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
        else
          vx = vx / dist
          vz = vz / dist
          local speed = 4.5 -- tune
          self.object:set_velocity({x=vx * speed, y=self.object:get_velocity().y, z=vz * speed})
        end
      else
        -- puncher gone: return to idle early
        self.state = "idle"
        self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
      end
      return
    end
  end,

  on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
    if not puncher or not puncher:is_player() then return end

    local t = now_s()

    -- rate limit: don’t restart react state too frequently
    if (t - (self.last_react_at or 0)) < 0.5 then
      return
    end

    self.state = "react"
    self.reaction_until = t + 2.0
    self.puncher_obj = puncher
    self.last_react_at = t

    core.chat_send_player(puncher:get_player_name(), "Ouch!")
  end,

  on_death = function(self, killer) end,
  on_rightclick = function(self, clicker)
    core.chat_send_player(clicker:get_player_name(), "Hi, I'm "..self.name_)
   end,
  on_attach_child = function(self, child) end,
  on_detach_child = function(self, child) end,
  on_detach = function(self, parent) end,

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


class.extends("cow", npc, {
  initial_properties = {
    visual = "mesh",
    mesh = "cow.obj",
    textures = {"cow.png"},
    visual_size = {x=-5, y=5},
    physical = true,
    collide_with_objects = true,
  },
  on_rightclick = function(self, clicker)
    core.chat_send_player(clicker:get_player_name(), self.name_.." says MOOOOOO!")
  end,
  generate_npc_username = function (self)
    if self.name_ then
       return
     end
    local names = {"Betsy", "Princess", "Swagger", "Conrad"}
    local number = math.random(0,999)

    local prefixId = math.random(1, #names)
    local prefix = names[prefixId]
    local baseString = prefix
    local name
    if number == 0 then
      name = baseString 
    else
      name = baseString .. number
    end

    self.name_ = name
    
  end,
  on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
    if not puncher or not puncher:is_player() then return end

    local t = now_s()

    -- rate limit: don’t restart react state too frequently
    if (t - (self.last_react_at or 0)) < 0.5 then
      return
    end

    self.state = "react"
    self.reaction_until = t + 2.0
    self.puncher_obj = puncher
    self.last_react_at = t

    core.chat_send_player(puncher:get_player_name(), "YOU DONT NEED MY BEEF, ~!@#$%^&*()_+!, AND I CAN\"T EVEN SAY THAT WORD UNCENSORED!")
  end,
})

core.register_entity("npc:npc", class.new(npc))
core.register_entity("npc:cow", class.new(cow))
core.register_alias("player_manager:npc_builder", "npc:npc")