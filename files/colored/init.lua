local translator = minetest.get_translator
local S = translator and translator("colored") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local dyes = dye.dyes

for i = 1, #dyes do
	local name, _, desc2, desc3 = unpack(dyes[i])

	--
	-- Colored Glass
	--

	minetest.register_node(":default:glass_" .. name, {
		description = desc3 .. " " .. S"Glass",
		drawtype = "glasslike",
		tiles = {"glass_" .. name .. ".png"},
		paramtype = "light",
		paramtype2 = "glasslikeliquidlevel",
		sunlight_propagates = true,
		is_ground_content = false,
		use_texture_alpha = true,
		groups = {cracky = 3, oddly_breakable_by_hand = 3, colorglass = 1},
		sounds = default.node_sound_glass_defaults(),
		drop = ""
	})

	minetest.register_craft({
		type = "shapeless",
		output = "default:glass_" .. name,
		recipe = {"group:dye,color_" .. name, "default:glass"}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "default:glass_" .. name,
		recipe = {"group:dye,color_" .. name, "group:colorglass"}
	})

	--
	-- Colored Hardened Clay
	--

	minetest.register_node(":hardened_clay:" .. name, {
		description = desc2 .. " " .. S"Hardened Clay",
		tiles = {"hardened_clay_stained_" .. name .. ".png"},
		is_ground_content = false,
		groups = {cracky = 3, hardened_clay = 1},
		sounds = default.node_sound_stone_defaults()
	})

	minetest.register_craft({
		output = "hardened_clay:" .. name .. " 8",
		recipe = {
			{"group:hardened_clay", "group:hardened_clay", "group:hardened_clay"},
			{"group:hardened_clay", "group:dye,color_" .. name, "group:hardened_clay"},
			{"group:hardened_clay", "group:hardened_clay", "group:hardened_clay"}
		}
	})

	--
	-- Colored Wool
	--

	minetest.register_node(":wool:" .. name, {
		description = desc2 .. " " .. S"Wool",
		tiles = {"wool_" .. name .. ".png"},
		is_ground_content = false,
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
				flammable = 3, wool = 1},
		sounds = default.node_sound_wool_defaults()
	})

	minetest.register_craft({
		type = "shapeless",
		output = "wool:" .. name,
		recipe = {"group:dye,color_" .. name, "group:wool"}
	})

	--
	-- Colored Beds
	--

	beds.register_bed(":beds:bed_" .. name, {
		description = desc2 .. " " .. S"Bed",
		inventory_image = "beds_bed_inv.png",
		wield_image = "beds_bed_inv.png",
		tiles = {"beds_bed.png", "wool_" .. name .. ".png"},
		mesh = "beds_bed.b3d",
		selectionbox = beds.box,
		collisionbox = beds.box,
		groups = {not_in_creative_inventory = 1},
		recipe = {
			{"wool:" .. name, "wool:" .. name, "wool:" .. name},
			{"group:wood", "group:wood", "group:wood"}
		},

		on_rightclick = beds.dyeing
	})

	--
	-- Colored Xpanes
	--

	xpanes.register_pane("pane_" .. name, {
		description = desc2 .. " " .. S"Glass Pane",
		textures = {"glass_" .. name .. ".png", "xpanes_top_glass_" .. name .. ".png"},
		sounds = default.node_sound_glass_defaults(),
		groups = {snappy = 2, cracky = 3, oddly_breakable_by_hand = 3, glasspane = 1},
		drop = ""
	})

	minetest.register_craft({
		type = "shapeless",
		output = "xpanes:pane_" .. name .. "_flat",
		recipe = {"group:dye,color_" .. name, "group:glasspane"}
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "group:wool",
	burntime = 4
})
