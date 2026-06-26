class = {}


deepcopy = function (o)
  local no = {}
  for key, value in pairs(o) do
    no[key] = value
  end
  return no
end


-- Classes/OOP

function declare (name, initval)
  rawset(_G, name, initval or false)
end

function class.define(name, definition)
    if not (type(definition) == "table") then
        error("Class "..name.."'s definition is not a table")
    end
    if not definition.constructor then
        error("Class "..name.." does not have a constructor")
    end
    definition.name = name
    definition.__index = definition
    declare(name, definition)
end

function class._extends(name, parent, definition)
    local merged = deepcopy(parent)
    for k, v in pairs(definition) do
        merged[k] = v
    end
    merged._parentID = parent.name
    function merged.super()
        return rawget(_G, merged._parentID)
    end
    return {name, merged}
end

function class.extends(name, parent, definition)
    local extended = class._extends(name, parent, definition)
    class.define(name, extended[2])
end

function class.implements(name, interface, definition)
    for key, value in next, interface, nil do
        if type(definition[key]) ~= type(value) then
            error("Class "..name.." does not properly implement interface "..interface)
        end
    end
    class.define(name, definition)
end

function class.extends_and_implements(name, interface, parent, definition)
    class.implements(name, interface, class._extends(name, parent, definition)[2])
end

function class.does_extend(child, parent)
    local child_def = rawget(_G, child)
    local parent_def = rawget(_G, parent)
    if child_def.super then
        if child_def.super() == parent_def then
            return true
        end
    end
    return false
end

function class.new(class, ...)
    local new = setmetatable({}, class)
    if new.constructor then
        new.constructor(new, ...)
    else
        error("Class "..name.." does not have a constructor")
    end
    return new
end