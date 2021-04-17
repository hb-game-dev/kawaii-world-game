
local translator = minetest.get_translator
local S = translator and translator("mob_horse") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local y_off = 24
if minetest.features and minetest.features.object_independent_selectionbox then
	y_off = 14
end

-- horse shoes (speed, jump, break, overlay texture)
local shoes = {
	["mobs:horseshoe_steel"] = {6, 4, 3, "mobs_horseshoe_steelo.png"},
	["mobs:horseshoe_gold"] = {7, 5, 4, "mobs_horseshoe_goldio.png"},
	["mobs:horseshoe_diamond"] = {8, 6, 6, "mobs_horseshoe_diamondo.png"},
	["mobs:horseshoe_emerald"] = {9, 8, 8, "mobs_horseshoe_emeraldio.png"}
}

local function do_custom(self, dtime)
	-- set needed values if not already present
	if not self.v2 then
		self.v2 = 0
		self.max_speed_forward = 5
		self.max_speed_reverse = 2
		self.accel = 4
		self.terrain_type = 3
		self.driver_attach_at = {x = 0, y = y_off, z = 0}
		self.driver_eye_offset = {x = 0, y = 5, z = 0}
	end

	-- if driver present allow control of horse
	if self.driver then
		mobs.drive(self, "run", "stand", false, dtime)
		return false -- skip rest of mob functions
	end

	return true
end

local function on_die(self, pos)
	if self.driver then
		minetest.add_item(pos, "mobs:saddle")
		mobs.detach(self.driver, {x = 1, y = 0, z = 1})
		self.saddle = nil
	end

	-- drop any horseshoes added
	if self.shoed then
		minetest.add_item(pos, self.shoed)
	end
end

local function do_punch(self, hitter)	
	-- don't cut the branch you're... ah, that's not about that
	if hitter ~= self.driver then
		return true
	end
end

local function on_rightclick(self, clicker)	
	-- make sure player is clicking
	if not clicker or not clicker:is_player() then
		return
	end

	-- feed, tame or heal horse
	if mobs:feed_tame(self, clicker, 10, true, true) then
		return
	end

	local player_name = clicker:get_player_name()

	-- make sure tamed horse is being clicked by owner only
	if self.tamed and self.owner == player_name then
		local inv = clicker:get_inventory()
		local tool = clicker:get_wielded_item()
		local item = tool:get_name()

		-- detatch player already riding horse
		if self.driver and clicker == self.driver then

			mobs.detach(clicker, {x = 1, y = 0, z = 1})

			-- add saddle back to inventory
			if inv:room_for_item("main", "mobs:saddle") then
				inv:add_item("main", "mobs:saddle")
			else
				minetest.add_item(clicker:get_pos(), "mobs:saddle")
			end

			self.saddle = nil

		-- attach player to horse
		elseif (not self.driver and not self.child
		and clicker:get_wielded_item():get_name() == "mobs:saddle")
		or self.saddle then

			self.object:set_properties({stepheight = 1.1})
			mobs.attach(self, clicker)

			-- take saddle from inventory
			if not self.saddle then
				inv:remove_item("main", "mobs:saddle")
			end

			self.saddle = true
		end

		-- apply horseshoes
		if item:find("mobs:horseshoe") then

			-- drop any existing shoes
			if self.shoed then
				minetest.add_item(self.object:get_pos(), self.shoed)
			end

			local speed = shoes[item][1]
			local jump = shoes[item][2]
			local reverse = shoes[item][3]
			local overlay = shoes[item][4]

			self.max_speed_forward = speed
			self.jump_height = jump
			self.max_speed_reverse = reverse
			self.accel = speed
			self.shoed = item

			-- apply horseshoe overlay to current horse texture
			if overlay then
				self.texture_mods = "^" .. overlay
				self.object:set_texture_mod(self.texture_mods)
			end

			-- show horse speed and jump stats with shoes fitted
			minetest.chat_send_player(player_name,
					S("Horse shoes fitted -")
					.. S(" speed: ") .. speed
					.. S(" , jump height: ") .. jump
					.. S(" , stop speed: ") .. reverse)

			tool:take_item()

			clicker:set_wielded_item(tool)
			return
		end
	end
end


-- rideable horse
mobs:register_mob("mob_horse:horse", {
	type = "animal",
	visual = "mesh",
	mesh = "mobs_horse.b3d",
	collisionbox = {-0.75, 0, -0.75, 0.75, 1.7, 0.75},
	selectionbox = {-0.75, 0, -0.75, 0.75, 1.5, 0.75},
	animation = {
		speed_normal = 30,
		speed_run = 75,
		stand_start = 300,
		stand_end = 460, 
		walk_start = 10,
		walk_end = 60,
		run_start = 70,
		run_end = 119,
	},
	textures = {
		{"mobs_horse.png"}, 
		{"mobs_horsepeg.png"},
		{"mobs_horseara.png"}
	},
	fear_height = 3,
	runaway = true,
	fly = false,
	walk_chance = 60,
	view_range = 5,
	follow = {
		"default:apple", "farming:wheat", "farming_addons:carrot",
		"farming_addons:corn", "flowers:mushroom_brown"
	},
	passive = true,
	hp_min = 30,
	hp_max = 40,
	armor = 100,
	lava_damage = 5,
	fall_damage = 5,
	water_damage = 1,
	makes_footstep_sound = true,
	drops = {
		{name = "mobs:leather", max = 3},
		{name = "mobs:meat_raw", max = 3}
	},

	do_custom = do_custom,
	on_die = on_die,
	do_punch = do_punch,
	on_rightclick = on_rightclick
})

mobs:spawn({
	name = "mob_horse:horse",
	nodes = {
		"default:dirt", "default:sand", "default:redsand",
		"default:snow", "default:snowblock",
		"default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"
	},
	min_light = 14,
	interval = 60,
	chance = 40000,
	min_height = 10,
	max_height = 31000,
	day_toggle = true,
})

mobs:register_egg("mob_horse:horse", S("Horse"), "mobs_horse_egg.png")


-- steel horseshoes
minetest.register_craftitem(":mobs:horseshoe_steel", {
	description = S("Steel HorseShoes (use on horse to apply)"),
	inventory_image = "mobs_horseshoe_steel.png",
})

minetest.register_craft({
	output = "mobs:horseshoe_steel",
	recipe = {
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
})

-- gold horseshoes
minetest.register_craftitem(":mobs:horseshoe_gold", {
	description = S("Gold HorseShoes (use on horse to apply)"),
	inventory_image = "mobs_horseshoe_gold.png",
})

minetest.register_craft({
	output = "mobs:horseshoe_gold",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"default:gold_ingot", "", "default:gold_ingot"},
	}
})

-- emerald horseshoes
minetest.register_craftitem(":mobs:horseshoe_emerald", {
	description = S("Emerald HorseShoes (use on horse to apply)"),
	inventory_image = "mobs_horseshoe_emerald.png",
})

minetest.register_craft({
	output = "mobs:horseshoe_emerald",
	recipe = {
		{"", "default:emerald", ""},
		{"default:emerald", "", "default:emerald"},
		{"default:emerald", "", "default:emerald"},
	}
})

-- diamond horseshoes
minetest.register_craftitem(":mobs:horseshoe_diamond", {
	description = S("Diamond HorseShoes (use on horse to apply)"),
	inventory_image = "mobs_horseshoe_diamond.png",
})

minetest.register_craft({
	output = "mobs:horseshoe_diamond",
	recipe = {
		{"", "default:diamond", ""},
		{"default:diamond", "", "default:diamond"},
		{"default:diamond", "", "default:diamond"},
	}
})
