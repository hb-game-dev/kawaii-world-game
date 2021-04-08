local S = workbench.S
local ceil, min = math.ceil, math.min

local w_version = "7"

--
-- Formspecs
--

-- You can't place 'image' on top of 'item_image'
minetest.register_craftitem("workbench:saw", {
	inventory_image = "workbench_saw.png",
	groups = {not_in_creative_inventory = 1}
})

-- Workbench formspec
local workbench_cells = ""
for x = 1, 3 do
for y = 1, 3 do
	workbench_cells = workbench_cells ..
		"item_image[" .. x + 1 .. "," .. y - 0.15 .. ";1,1;default:cell]"
end
end

local workbench_fs = [[
	image[-0.23,-0.26;9,1;formspec_workbench_btn.png]
	image_button[0.92,-0.25;1,1;blank.png;creating;;true;false;blank.png]
	tooltip[creating;]] .. S("Сutting") .. [[]
	image_button[1.87,-0.25;1,1;blank.png;anvil;;true;false;blank.png]
	tooltip[anvil;]] .. S("Anvil") .. [[]

	]] .. workbench_cells .. [[
	list[current_player;craft;2,0.85;3,3;]
	image[5.055,1.85;1,1;default_arrow_bg.png^[transformR270]
	item_image[5.925,1.775;1.2,1.2;default:cell]
	list[current_player;craftpreview;6,1.8505;1,1;]
]]

-- Creating formspec
local creating_cells = ""
for x = 1, 4 do
for y = 1, 3 do
	creating_cells = creating_cells ..
		"item_image[" .. x + 2 .. "," .. y - 0.15 .. ";1,1;default:cell]"
end
end

local creating_fs = [[
	image[-0.23,-0.26;9,1;formspec_cutting_btn.png]
	image_button[0.02,-0.25;1,1;blank.png;back;;true;false;blank.png]
	tooltip[back;]] .. S("Workbench") .. [[]
	image_button[1.87,-0.25;1,1;blank.png;anvil;;true;false;blank.png]
	tooltip[anvil;]] .. Sl("Anvil") .. [[]

	item_image[1,1.85;1,1;default:cell]
	list[context;craft;1,1.8505;1,1;]
	image[2,1.85;1,1;default_arrow_bg.png^[transformR270]
	]] .. creating_cells .. [[
	list[context;forms;3.01,0.86;4,3;]
]]

-- Repair formspec
local repair_fs = [[
	image[-0.23,-0.26;9,1;formspec_anwil_btn.png]
	image_button[0.02,-0.25;1,1;blank.png;back;;true;false;blank.png]
	tooltip[back;]] .. Sl("Workbench") .. [[]
	image_button[0.92,-0.25;1,1;blank.png;creating;;true;false;blank.png]
	tooltip[creating;]] .. Sl("Сutting") .. [[]

	item_image[2,1.5;1,1;default:cell]
	list[context;tool;2,1.5;1,1;]
	item_image[2,2.5;1,1;default:pick_steel]
	
	image[4,1.5;1,1;workbench_plus.png]

	item_image[6,1.5;1,1;default:cell]
	list[context;hammer;6,1.5;1,1;]
	item_image[6,2.5;1,1;workbench:hammer]
]]

local formspecs = {
	-- Workbench formspec
	workbench_fs,

	-- Crafting formspec
	creating_fs,

	-- Repair formspec
	repair_fs
}

local function set_formspec(meta, id)
	meta:set_string("formspec",
		default.gui ..
		"list[context;split;8,3.14;1,1;]" ..
		formspecs[id])
end

local function construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("tool", 1)
	inv:set_size("craft", 1)
	inv:set_size("hammer", 1)
	inv:set_size("split", 1)
	inv:set_size("forms", 12)

	meta:set_string("infotext", S("Workbench"))
	meta:set_string("version", w_version)
	set_formspec(meta, 1)
end

-- Tools allowed to be repaired
local repairable_tools = {"pick", "axe", "shovel", "sword", "hoe", "armor"}
local function repairable(stack)
	local tool
	for i = 1, #repairable_tools do
		tool = repairable_tools[i]
		if stack:find(tool) then
			return true
		end
	end
end

local function get_output(inv, input, name)
	local output = {}
	for i = 1, #workbench.defs do
		local nbox = workbench.defs[i]
		local count = min(nbox[2] * input:get_count(), input:get_stack_max())
		local item = "stairs:" .. nbox[1] .. "_" .. name:gsub(":", "_")
		output[#output+1] = item .. " " .. count
	end
	inv:set_list("forms", output)
end

local function fields(pos, _, field, sender)
	if not pos or not sender or
			minetest.is_protected(pos, sender:get_player_name()) then
		return
	end
	local meta = minetest.get_meta(pos)
	local id = field.back and 1 or field.creating and 2 or field.anvil and 3
	if field.craftguide then
		sfinv.set_page(sender, "craftguide:craftguide", true)
	end

	if field.craft_all then
		workbench.craft_all(sender)
		return
	end

	if not id or id == 1 then
		pos.y = pos.y + 1
		local inv = sender:get_inventory()
		if inv then
			local stack
			for i = 1, inv:get_size("craft") do
				stack = inv:get_stack("craft", i)
				if stack:get_count() > 0 then
					minetest.add_item(pos, stack)
				end
			end
			inv:set_list("craft", {})
		end
		local workbench = meta:get_inventory()
		if workbench then
			local lists = {"craft", "tool", "hammer", "split"}
			local name, wstack
			for i = 1, #lists do
				name = lists[i]
				wstack = workbench:get_stack(name, 1)
				if wstack:get_count() > 0 then
					minetest.add_item(pos, wstack)
					workbench:set_stack(name, 1, nil)
				end
			end
			workbench:set_list("forms", {})
		end
	end

	if id then
		set_formspec(meta, id)
	end
end

local function timer(pos)
	local node_timer = minetest.get_node_timer(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	local tool = inv:get_stack("tool", 1)
	local hammer = inv:get_stack("hammer", 1)
	if tool:is_empty() or tool:get_wear() == 0
	or hammer:is_empty() or hammer:get_name() ~= "workbench:hammer" then
		node_timer:stop()
		return false
	end

	-- Tool's wearing range: 0-65535; 0 = new condition
	tool:add_wear(-500)
	hammer:add_wear(1000)

	inv:set_stack("tool", 1, tool)
	inv:set_stack("hammer", 1, hammer)

	return true
end

local function on_put(pos, listname, _, stack)
	if listname == "craft" then
		local inv = minetest.get_meta(pos):get_inventory()
		local input = inv:get_stack("craft", 1)
		get_output(inv, input, stack:get_name())
	elseif listname == "tool" or listname == "hammer" then
		local ntimer = minetest.get_node_timer(pos)
		ntimer:start(0.5)
	end
end

local function on_take(pos, listname, index, stack, player)
	if listname ~= "craft" and listname ~= "forms" then
		return
	end

	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("craft", 1)
	local inputname = input:get_name()
	local stackname = stack:get_name()

	if listname == "craft" then
		if stackname == inputname and workbench.nodes[stackname] then
			get_output(inv, input, stackname)
		else
			inv:set_list("forms", {})
		end
	elseif listname == "forms" then
		local fromstack = inv:get_stack(listname, index)
		if not fromstack:is_empty() and fromstack:get_name() ~= stackname then
			local player_inv = player:get_inventory()
			if player_inv:room_for_item("main", fromstack) then
				player_inv:add_item("main", fromstack)
			end
		end

		input:take_item(ceil(stack:get_count() / workbench.defs[index][2]))
		inv:set_stack("craft", 1, input)
		get_output(inv, input, inputname)
	end
end

local function put(pos, listname, _, stack, player)
	if not minetest.is_protected(pos, player:get_player_name()) then
		local stackname = stack:get_name()
		if (listname == "tool" and stack:get_wear() > 0 and
			repairable(stackname)) or
			(listname == "craft" and workbench.nodes[stackname] and
			minetest.get_item_group(stackname, "not_cuttable") == 0) or
			(listname == "hammer" and stackname == "workbench:hammer") then
			return stack:get_count()
		end
		if listname == "split" then
			return stack:get_count() / 2
		end
	end

	return 0
end

local function take(pos, _, _, stack, player)
	if not minetest.is_protected(pos, player:get_player_name()) then
		return stack:get_count()
	end

	return 0
end

--
-- Workbench
--


-- Registration helper
local wb_nodes = {}
local function register_workbench(name, def)
	wb_nodes[#wb_nodes+1] = name

	minetest.register_craft({
		output = name,
		recipe = {
			{def.material, def.material},
			{def.material, def.material}
		}
	})

	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		on_timer = timer,
		on_construct = construct,
		on_receive_fields = fields,
		on_metadata_inventory_put = on_put,
		on_metadata_inventory_take = on_take,
		allow_metadata_inventory_put = put,
		allow_metadata_inventory_take = take,
		allow_metadata_inventory_move = function() return 0 end
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	def.description = S(def.description)

	def.material = nil

	minetest.register_node(name, def)
end

register_workbench("workbench:workbench", {
	description = "Apple Wood Workbench",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	tiles = {
		"default_wood.png^workbench_top.png",   "default_wood.png^workbench_top.png",
		"default_wood.png^workbench_sides.png", "default_wood.png^workbench_sides.png",
		"default_wood.png^workbench_front.png", "default_wood.png^workbench_front.png"
	},
	material = "default:wood"
})

register_workbench("workbench:workbench_acacia_wood", {
	description = "Acacia Wood Workbench",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	tiles = {
		"default_acacia_wood.png^workbench_top.png",   "default_acacia_wood.png^workbench_top.png",
		"default_acacia_wood.png^workbench_sides.png", "default_acacia_wood.png^workbench_sides.png",
		"default_acacia_wood.png^workbench_front.png", "default_acacia_wood.png^workbench_front.png"
	},
	material = "default:acacia_wood"
})

register_workbench("workbench:workbench_birch_wood", {
	description = "Birch Wood Workbench",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	tiles = {
		"default_birch_wood.png^workbench_top.png",   "default_birch_wood.png^workbench_top.png",
		"default_birch_wood.png^workbench_sides.png", "default_birch_wood.png^workbench_sides.png",
		"default_birch_wood.png^workbench_front.png", "default_birch_wood.png^workbench_front.png"
	},
	material = "default:birch_wood"
})

register_workbench("workbench:workbench_jungle_wood", {
	description = "Jungle Wood Workbench",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	tiles = {
		"default_junglewood.png^workbench_top.png",   "default_junglewood.png^workbench_top.png",
		"default_junglewood.png^workbench_sides.png", "default_junglewood.png^workbench_sides.png",
		"default_junglewood.png^workbench_front.png", "default_junglewood.png^workbench_front.png"
	},
	material = "default:junglewood"
})

register_workbench("workbench:workbench_pine_wood", {
	description = "Pine Wood Workbench",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	tiles = {
		"default_pine_wood.png^workbench_top.png",   "default_pine_wood.png^workbench_top.png",
		"default_pine_wood.png^workbench_sides.png", "default_pine_wood.png^workbench_sides.png",
		"default_pine_wood.png^workbench_front.png", "default_pine_wood.png^workbench_front.png"
	},
	material = "default:pine_wood"
})

register_workbench("workbench:workbench_cherry_blossom_wood", {
	description = "Cherry Blossom Wood Workbench",
	groups = {cracky = 2, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	tiles = {
		"default_cherry_blossom_wood.png^workbench_top.png",   "default_cherry_blossom_wood.png^workbench_top.png",
		"default_cherry_blossom_wood.png^workbench_sides.png", "default_cherry_blossom_wood.png^workbench_sides.png",
		"default_cherry_blossom_wood.png^workbench_front.png", "default_cherry_blossom_wood.png^workbench_front.png"
	},
	material = "default:cherry_blossom_wood"
})

-- LBM for updating Workbench
minetest.register_lbm({
	label = "Workbench updater",
	name = "workbench:updater_v" .. w_version,
	nodenames = wb_nodes,
	action = function(pos)
		if minetest.get_meta(pos):get_string("version") ~= w_version then
			construct(pos)
		end
	end
})

--
-- Craft items
--

minetest.register_tool("workbench:hammer", {
	description = "Hammer",
	inventory_image = "workbench_hammer.png",
	tool_capabilities = {
		full_punch_interval = 1.5,
		max_drop_level = 0,
		damage_groups = {fleshy = 6}
	},
	sound = {breaks = "default_tool_breaks"}
})

minetest.register_craft({
	output = "workbench:hammer",
	recipe = {
		{"default:steel_ingot", "default:stick", "default:steel_ingot"},
		{"", "default:stick", ""},
		{"", "default:stick", ""}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "workbench:workbench",
	burntime = 30
})
