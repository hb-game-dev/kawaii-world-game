sethome = {}

local translator = minetest.get_translator
sethome.S = translator and translator("sethome") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		sethome.S = intllib.make_gettext_pair()
	end
end

local S = sethome.S

local chat_player = minetest.chat_send_player
local colorize = minetest.colorize
local function green(s) return colorize("limegreen", s) end
local function red(s) return colorize("red", s) end
local function pos_to_string(p) return minetest.pos_to_string(p, 2) end

function sethome.set(player, name, param)
	if player and player:is_player() then
		name = name or player:get_player_name()
		local pos = player:get_pos()
		if minetest.is_valid_pos(pos) then
			if not param or param == "" then
				player:set_attribute("sethome:home", pos_to_string(pos))
				chat_player(name, green(S"Home position set!"))
			elseif param == "public delete" then
				player:set_attribute("sethome:public", nil)
				chat_player(name, red(S"Public Home position deleted!"))
			elseif param:find("public") then
				local node_name_above2 = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name
				local node_name_above = minetest.get_node(pos).name
				local node_name_under = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name
				local def_above2 = minetest.registered_nodes[node_name_above2]
				local def_above = minetest.registered_nodes[node_name_above]
				local def_under = minetest.registered_nodes[node_name_under]

				if not minetest.is_protected(pos, name) and
						def_above2 and --[[not def_above2.walkable and]] def_above2.liquidtype == "none" and
						def_above and --[[not def_above.walkable and]] def_above.liquidtype == "none" and
						def_under and def_under.walkable and def_under.liquidtype == "none" then
					player:set_attribute("sethome:public", pos_to_string(pos))
					local public_desc = S"My Home"
					if param:find("name") then
						public_desc = param:sub(13)
					end
					player:set_attribute("sethome:public_desc", public_desc)
					chat_player(name, green(S"Public Home position set!"))
					chat_player(name, green(S("Other players can teleport to you using \"/home @1\"", name)))
				else
					chat_player(name, red(S"You cannot set Public Home on this place!"))
					return false
				end
			else
				chat_player(name, red(S"Wrong parameter! Please, check input"))
				return false
			end

			return true
		else
			chat_player(name, red(S"Home position is not set!"))
		end
	end

	return false
end

local function check_node(pos)
	local node_name = minetest.get_node_or_nil(pos)

	if not node_name then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node_name = minetest.get_node(pos)
	end

	return node_name
end

local function find_free_pos(pos)
	local check = {
		{x = 0,  y = 0, z =  0},
		{x = 1,  y = 0, z =  0},
		{x = 1,  y = 1, z =  0},
		{x = -1, y = 0, z =  0},
		{x = -1, y = 1, z =  0},
		{x = 0,  y = 0, z =  1},
		{x = 0,  y = 1, z =  1},
		{x = 0,  y = 0, z = -1},
		{x = 0,  y = 1, z = -1}
	}

	for _, c in pairs(check) do
		local npos = {x = pos.x + c.x, y = pos.y + c.y, z = pos.z + c.z}
		local node = minetest.get_node_or_nil(npos)
		if node and node.name then
			local def = minetest.registered_nodes[node.name]
			if def and not def.walkable and
					def.liquidtype == "none" then
				return npos
			end
		end
	end

	return pos
end

function sethome.go(player, name, public)
	if player and player:is_player() then
		name = name or player:get_player_name()
		if not public or public == "" then
			local pos = minetest.string_to_pos(player:get_attribute("sethome:home"))
			if minetest.is_valid_pos(pos) then
				local panimation = player_api.get_animation(player).animation
				if panimation ~= "sit" and panimation ~= "lay" and panimation ~= "ride" then
					player:set_pos(pos)
					chat_player(name, green(S"Teleported to Home!"))
					return true
				else
					chat_player(name, red(S"You should stand to teleport!"))
					return true
				end
			else
				chat_player(name, red(S"Home position is not set!"))
			end
		else
			local public_player = minetest.get_player_by_name(public)
			if public_player and public_player:is_player() then
				local pos = minetest.string_to_pos(public_player:get_attribute("sethome:public"))
				if minetest.is_valid_pos(pos) then
					pos = find_free_pos(pos)
					local node_name_above = check_node(pos).name
					local node_name_under = check_node({x = pos.x, y = pos.y - 1, z = pos.z}).name
					local def_above = minetest.registered_nodes[node_name_above]
					local def_under = minetest.registered_nodes[node_name_under]

					if def_above and not def_above.walkable and def_above.liquidtype == "none" and
							def_under and def_under.walkable and def_under.liquidtype == "none" then
						local panimation = player_api.get_animation(player).animation
						if panimation ~= "sit" and panimation ~= "lay" and panimation ~= "ride" then
							player:set_pos(pos)
							chat_player(name, green(S("Teleported to \"@1\" Home!", public)))
							return true
						else
							chat_player(name, red(S"You should stand to teleport!"))
							return true
						end
					else
						chat_player(name, red(S"Teleportation to this Home is unsafe!"))
					end
				else
					chat_player(name, red(S("Player \"@1\" haven't public Home!", public)))
				end
			else
				chat_player(name, red(S("Player \"@1\" is not in the game!", public)))
			end
		end
	end

	return false
end

minetest.register_chatcommand("sethome", {
	description = S"Set your Private or Public Home point",
	params = "[public] | [public delete] | [public name <HomeName>]",
	privs = {interact = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if sethome.set(player, name, param) then
			return true
		end
		return false
	end
})

minetest.register_chatcommand("home", {
	description = S"Teleport you to your Private or Public Home point",
	params = S"[<PlayerName>]",
	privs = {interact = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if sethome.go(player, name, param) then
			return true
		end
		return false,
			param == "" and red(S"Set a Home position using \"/sethome\"")
	end
})

dofile(minetest.get_modpath("sethome") .. "/gui.lua")
