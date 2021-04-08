--
--Fireworks by InfinityProject
--License code and textures WTFPL 
--Thanks to Mauvebic, Cornernote, and Neuromancer

--REWRITE BY: crayzginger72 (2014)

--Sound will be added soon

local colours_list = {
	{"red",     "Red"},
	{"green",   "Green"},
	{"blue",    "Blue"},
	{"violet",  "Violet"},
	{"orange",  "Orange"},
	{"yellow",  "Yellow"},	
	{"brown",  "Brown"},
	{"cyan",  "Cyan"},
	{"dark_green",  "Dark Green"},
	{"magenta",  "Magenta"},
	{"pink",  "Pink"},	
	{"white",   ""} ,
 }

for i in ipairs(colours_list) do
	local colour = colours_list[i][1]
	local desc = colours_list[i][2]

	if colour == "white" then 
		minetest.register_node("fireworks:white", {
			drawtype = "airlike",
			light_source = 20,
			buildable_to = true,
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = false,
			pointable = false,
			groups = {not_in_creative_inventory=1},
		})

		minetest.register_abm({
			nodenames = {"fireworks:white"},
			interval =20,
			chance = 1,	
			
			action = function(pos, node, active_object_count, active_object_count_wider)
				if node.name == "fireworks:white" then
					minetest.remove_node(pos,{name="fireworks:white"})  
				end
			end
		})

		return
	end

	minetest.register_node("fireworks:".. colour, {
		description = desc .. " Fireworks",
		tiles = {"firework_"..colour..".png"},
		inventory_image = "firework_" .. colour .. ".png",
		is_ground_content = true,
		groups = {oddly_breakable_by_hand = 3, mesecon = 2, falling_node = 1},
		drawtype = "plantlike",
			paramtype = "light",
			selection_box = {
				type = "fixed",
				fixed = {-0.15, -0.5, -0.15, 0.15, 0.38, 0.15},
			},
		sounds = default.node_sound_stone_defaults(),
		mesecons = {effector = { action_on = function(pos, node)
			local f_colour = colour
			fireworks_activate(pos, node, f_colour)
			end}},
			
		on_rightclick = function(pos, node, clicker)
			local f_colour = colour
			fireworks_activate(pos, node, f_colour)
	 	end,	

		on_ignite = function(pos, igniter)
			local pn = igniter and igniter:get_player_name() or ""
			if not minetest.is_protected(pos, pn) then
				local f_colour = colour
				fireworks_activate(pos, node, f_colour)
			end
		end		
	})

	minetest.register_node("fireworks:sparks_"..colour, {
		drawtype = "plantlike",
		description = desc,
		tiles = {"firework_sparks_"..colour..".png"},
		light_source = 20,
		sunlight_propagates = true,
		walkable = false,
		is_ground_content = true,
		pointable = false,
		groups = {cracky=3,not_in_creative_inventory=1},--, hot=1, igniter=3}, --<<<<to enable fire
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = "fireworks:" .. colour,
		recipe = {
			{"", "default:paper", ""},
			{"", "default:gunpowder", ""},
			{"", "dye:" .. colour, ""}
		}
	})

	function fireworks_activate (pos, node, f_colour)
	local zrand = math.random(-3, 3)
	local xrand = math.random(-3,3)
	local yrand = math.random(25, 30)
	minetest.sound_play("FireworkCombo44q5", {
		pos={x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		max_hear_distance = 120,
		gain = 4,
	})
	if minetest.get_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand}).name == "air" 
	or minetest.get_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand}).name == "fireworks:white" then
	minetest.remove_node(pos,{name="fireworks:"..colour})
	minetest.add_node({x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},{name='fireworks:white'})
	minetest.add_particlespawner({
		amount = 250,
		time = .1,
		minpos = {x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		maxpos = {x=pos.x+xrand,y=pos.y+yrand,z=pos.z+zrand},
		minvel = {x=-04, y=-04, z=-04},
 		maxvel = {x=04, y=04, z=04},
 		minacc = {x=0, y=-0.2, z=0},
  		maxacc = {x=0, y=-0.6, z=0},
  		minexptime = .6,
  		maxexptime = .6,
  		minsize = 1,
 		maxsize = 5,
 		collisiondetection = false,
  		vertical = false,
  		texture = "fireworks_white.png",
	})
	end
	if node.name == "fireworks:"..f_colour then
		local radius = math.random(5,8)
			for x=-radius,radius do
			for y=-radius,radius do
			for z=-radius,radius do
				local w = radius/2+5
		   		if x*x+y*y+z*z <= radius*radius then
		   			if minetest.get_node({x=pos.x+x+xrand,y=pos.y+y+yrand-1,z=pos.z+z+zrand}).name == "air" then
		    			minetest.add_node({x=pos.x+x+xrand,y=pos.y+y+yrand-1,z=pos.z+z+zrand},{name="fireworks:white"}) 
		    			if x*x+y*y+z*z >= radius*radius-w and math.random(1, 10) <= 7 then
							minetest.add_particle({
									pos = {x=pos.x+x+xrand,y=pos.y+y+yrand,z=pos.z+z+zrand},
									vel = {x=0, y=0, z=0},
									acc = {x=0, y=-0.2, z=0},
									expirationtime = math.random((radius/3)+(yrand/6)+2, (radius/3)+(yrand/6)-4) ,
									size = math.random(3, 6),
									collisiondetection = false,
									vertical = false,
									texture = "firework_sparks_"..f_colour..".png"
							})
		    			end
		    		end
				end
			end
			end
			end
		end
	end
end