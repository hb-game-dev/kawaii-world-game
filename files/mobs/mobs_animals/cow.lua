local S = mobs_animals.S

mobs:register_mob("mobs_animals:cow", {
	description = S"Cow",
	type = "animal",
	damage = 2,
	hp_min = 10,
	hp_max = 20,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.2, 0.4},
	visual = "mesh",
	mesh = "mobs_cow.b3d",
	textures = {
		{"mobs_cow.png"},
		{"mobs_cow2.png"},
		{"mobs_cow3.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_cow",
		attack = "mobs_cow"
	},
	walk_velocity = 1,
	run_velocity = 2,
	jump = true,
	jump_height = 6,
	pushable = true,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 3},
		{name = "mobs:leather", chance = 1, min = 0, max = 2},
	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		stand_start = 0,
		stand_end = 30,
		stand_speed = 20,
		stand1_start = 35,
		stand1_end = 75,
		stand1_speed = 20,
		walk_start = 85,
		walk_end = 114,
		walk_speed = 20,
		run_start = 120,
		run_end = 140,
		run_speed = 30,
		punch_start = 145,
		punch_end = 160,
		punch_speed = 20,
		die_start = 165,
		die_end = 185,
		die_speed = 10,
		die_loop = false,
	},
	follow = {"flora", "farming:wheat"},
	view_range = 8,
	fear_height = 2,
	replace_rate = 10,
	replace_what = {
		{"group:flora", "air"},
		{"default:dirt_with_grass", "default:dirt", -1}
	},

	on_rightclick = function(self, clicker)
		-- feed or tame
		if mobs:feed_tame(self, clicker, 8, true, true) then
			-- after feeding 7 times the cow can be milked again
			if self.food and self.food > 6 then
				self.gotten = false
			end
			return
		end

		local tool = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		-- milk cow with empty bucket
		if tool:get_name() == "bucket:bucket_empty" then
			if self.child then return end

			if self.gotten then
				minetest.chat_send_player(name, S"Cow already milked!")
				return
			end

			local inv = clicker:get_inventory()
			tool:take_item()
			clicker:set_wielded_item(tool)

			if inv:room_for_item("main", {name = "bucket:bucket_milk"}) then
				inv:add_item("main", "bucket:bucket_milk")
			else
				local pos = self.object:get_pos()
				pos.y = pos.y + 0.5
				minetest.add_item(pos, {name = "bucket:bucket_milk"})
			end

			self.gotten = true -- milked
			return
		end

		--	if mobs:capture_mob(self, clicker, 0, 5, 60, false, nil) then return end
	end,

	on_replace = function(self)
		self.food = (self.food or 0) + 1

		-- after the cow replaces grass 8 times, it can be milked again
		if self.food >= 8 then
			self.food = 0
			self.gotten = false
		end
	end
})

mobs:spawn({
	name = "mobs_animals:cow",
	nodes = mobs_animal.spawn_nodes,
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg(":mobs_animal:cow", S"Cow Egg", "mobs_cow_egg.png")


--
-- Items
--

minetest.register_craftitem("mobs_animals:cheese", {
	description = S"Cheese",
	inventory_image = "mobs_cheese.png",
	wield_image = "mobs_cheese_wield.png",
	on_use = minetest.item_eat(4),
	groups = {food_cheese = 1, flammable = 2, food = 1}
})

minetest.register_node("mobs_animals:cheeseblock", {
	description = S"Cheese Block",
	tiles = {"mobs_cheeseblock.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults()
})


--
-- Crafting
--

minetest.register_craft({
	type = "cooking",
	output = "mobs_animals:cheese",
	recipe = "bucket:bucket_milk",
	cooktime = 5,
	replacements = {{"bucket:bucket_milk", "bucket:bucket_empty"}}
})

minetest.register_craft({
	output = "mobs_animals:cheeseblock",
	recipe = {
		{"mobs_animals:cheese", "mobs_animals:cheese", "mobs_animals:cheese"},
		{"mobs_animals:cheese", "mobs_animals:cheese", "mobs_animals:cheese"},
		{"mobs_animals:cheese", "mobs_animals:cheese", "mobs_animals:cheese"}
	}
})

minetest.register_craft({
	output = "mobs_animals:cheese 9",
	recipe = {
		{"mobs_animals:cheeseblock"}
	}
})


--
-- Aliases
--

mobs:alias_mob("mobs_animal:cow", "mobs_animals:cow")
minetest.register_alias("mobs:cheese", "mobs_animals:cheese")
minetest.register_alias("mobs:cheeseblock", "mobs_animals:cheeseblock")