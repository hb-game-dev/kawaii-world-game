local S = mobs_animals.S
local random = math.random

mobs:register_mob("mobs_animals:chicken", {
	description = S"Chicken",
	type = "animal",
	passive = true,
	hp_min = 5,
	hp_max = 10,
	collisionbox = {-0.3, -0.75, -0.3, 0.3, 0.1, 0.3},
	visual = "mesh",
	mesh = "mobs_chicken.b3d",
	textures = {
		{"mobs_chicken.png"},
		{"mobs_chicken_black.png"},
		{"mobs_chicken_brown.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_chicken"
	},
	run_velocity = 3,
	runaway = true,
	runaway_from = {"player", "mobs_animals:fox"},
	drops = {
		{name = "mobs_animals:chicken_raw", chance = 1, min = 1, max = 1},
	},
	water_damage = 1,
	lava_damage = 5,
	fall_damage = 0,
	fall_speed = -4,
	fear_height = 5,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 30,
		stand_speed = 28,
		stand1_start = 31,
		stand1_end = 70,
		stand1_speed = 32,
		walk_start = 71,
		walk_end = 90,
		walk_speed = 24,
		run_start = 91,
		run_end = 110,
		run_speed = 24,
	},
	follow = {"seed"},

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
	--	if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	end,

	do_custom = function(self, dtime)
		self.egg_timer = (self.egg_timer or 0) + dtime
		if self.child or self.egg_timer < 60 then
			return
		end
		self.egg_timer = 0

		if random(10) == 1 then
			local pos = self.object:get_pos()
			if not pos then
				return
			end
			minetest.add_item(pos, "mobs_animals:chicken_egg")
			minetest.sound_play("default_place_node_hard", {
				pos = pos,
				max_hear_distance = 10
			})
		end
	end
})

mobs:spawn({
	name = "mobs_animals:chicken",
	nodes = mobs_animal.spawn_nodes,
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animals:chicken", S"Chicken Egg", "mobs_chicken_egg_inv.png")


--
-- Egg Throwing
--

local function egg_impact(thrower, pos, dir, hit_object)
	if hit_object and thrower then
		local punch_damage = {
			full_punch_interval = 0,
			damage_groups = {fleshy = 1}
		}
		hit_object:punch(thrower, 0, punch_damage, dir)
	end

	if random(8) == 1 then
		local player_name = thrower and thrower:get_player_name() or ""
		pos.y = pos.y + 1

		if minetest.is_protected(pos, player_name) then
			minetest.add_item(pos, "mobs_animals:chicken_egg")
			return
		end

		local node = minetest.get_node(pos).name
		if node == "ignore" or minetest.registered_nodes[node].walkable then
			return
		end

		local mob = minetest.add_entity(pos, "mobs_animals:chicken")
		local ent2 = mob:get_luaentity()

		local infotext = S("Owned by @1", S(player_name))
		ent2.infotext = infotext
		mob:set_properties({
			infotext = infotext,
			visual_size = {
				x = ent2.base_size.x * .5,
				y = ent2.base_size.y * .5
			},
			collisionbox = {
				ent2.base_colbox[1] * .5,
				ent2.base_colbox[2] * .5,
				ent2.base_colbox[3] * .5,
				ent2.base_colbox[4] * .5,
				ent2.base_colbox[5] * .5,
				ent2.base_colbox[6] * .5
			}
		})
		ent2.child = true
		ent2.tamed = true
		ent2.owner = thrower
	end
end

local function chicken_egg_shoot(itemstack, thrower)
	local playerpos = thrower:get_pos()
	if not minetest.is_valid_pos(playerpos) then
		return
	end
	local obj = minetest.item_throw("mobs:chicken_egg", thrower, 19, -3, egg_impact)
	if obj then
		obj:set_properties({
			visual = "sprite",
			visual_size = {x = 0.5, y = 0.5},
			textures = {"mobs_chicken_egg.png"}
		})
		minetest.sound_play("throwing_sound", {
			pos = playerpos,
			gain = 0.7,
			max_hear_distance = 10
		})
		if not mobs.is_creative(thrower) or
				not minetest.is_singleplayer() then
			itemstack:take_item()
		end
	end
	return itemstack
end


--
-- Items
--

minetest.register_craftitem("mobs_animals:chicken_egg", {
	description = S"Egg",
	inventory_image = "mobs_chicken_egg.png",
	groups = {food = 1, egg = 1},
	on_use = chicken_egg_shoot
})

minetest.register_craftitem("mobs_animals:chicken_egg_fried", {
	description = S"Fried Egg",
	inventory_image = "mobs_chicken_egg_fried.png",
	on_use = minetest.item_eat(3),
	groups = {flammable = 2, food = 1}
})

minetest.register_craftitem("mobs_animals:chicken_raw", {
	description = S"Raw Chicken",
	inventory_image = "mobs_chicken_raw.png",
	on_use = minetest.item_eat(2, nil, -3),
	groups = {food_meat_raw = 1, food_chicken_raw = 1, flammable = 2, food = 1}
})

minetest.register_craftitem("mobs_animals:chicken_cooked", {
	description = S"Cooked Chicken",
	inventory_image = "mobs_chicken_cooked.png",
	on_use = minetest.item_eat(6),
	groups = {food_meat = 1, food_chicken = 1, flammable = 2, food = 1}
})


--
-- Crafting
--

minetest.register_craft({
	type = "cooking",
	recipe = "mobs_animals:chicken_egg",
	output = "mobs_animals:chicken_egg_fried"
})

minetest.register_craft({
	type = "cooking",
	recipe = "mobs_animals:chicken_raw",
	output = "mobs_animals:chicken_cooked"
})


--
-- Aliases
--

mobs:alias_mob("mobs_animal:chicken", "mobs_animals:chicken")
minetest.register_alias("mobs_animal:chicken", "mobs_animals:chicken")
minetest.register_alias("mobs:chicken_raw", "mobs_animals:chicken_raw")
minetest.register_alias("mobs:chicken_cooked", "mobs_animals:chicken_cooked")
minetest.register_alias("mobs:egg", "mobs_animals:chicken_egg")
minetest.register_alias("mobs:chicken_egg", "mobs_animals:chicken_egg")
minetest.register_alias("mobs:chicken_egg_fried", "mobs_animals:chicken_egg_fried")

-- TEMP!
if not minetest.is_singleplayer() and not minetest.settings:get_bool("creative_mode") then
	minetest.register_alias_force("mobs_animals:chicken", "mobs_animals:chicken_egg")
end
