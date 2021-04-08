if minetest.settings:get_bool("creative_mode") then
	return
end
local armor = minetest.get_modpath("3d_armor")

local function formspec(player)
	local player_name = player:get_player_name()
	local form = "bgcolor[#08080880;true]" ..
		"size[9,8.75]" ..
		"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
		"background[0,0;0,0;formspec_backround.png;true]" ..
		"background[0,0;0,0;formspec_inventory.png;true]" ..
		"image_button_exit[8.55,-0.25;0.75,0.75;blank.png;exit;;true;false;blank.png]" ..
		"list[current_player;main;0.01,4.51;9,3;9]" ..
		"list[current_player;main;0.01,7.75;9,1;]" ..
		"background[0,0;0,0;inventory_formspec.png;true]" ..
		"list[current_player;craft;0,1.5;2,1;1]" ..
		"list[current_player;craft;0,2.5;2,1;4]" ..
		"list[current_player;craftpreview;3.05,2.03;1,1;]" ..
		"list[detached:" .. player_name .. "_split;main;4,3.14;1,1;]" ..
		"image[6.5,0.15;2.2,4.4;" .. player_api.preview(player) .. "]" ..
		"image[-0.23,-0.26;9,1;formspec_inventory_btn.png]" ..
		"image_button[0.92,-0.25;1,1;blank.png;craftguide;;true;false;blank.png]" ..
		"tooltip[craftguide;" .. Sl("Crafting Guide") .. "]"

	-- Armor
	if armor then
		form = form ..
			"list[detached:" .. player_name .. "_armor;armor;5,0.15;1,1;]" ..
			"list[detached:" .. player_name .. "_armor;armor;5,1.15;1,1;1]" ..
			"list[detached:" .. player_name .. "_armor;armor;5,2.15;1,1;2]" ..
			"list[detached:" .. player_name .. "_armor;armor;5,3.15;1,1;3]"
	end

	return form
end

local function drop_craft(player, inventory)
	local inv = player:get_inventory()
	local pos = player:get_pos()
	local stack

	local function do_drop(stack)
		if stack:get_count() > 0 then
			if inventory and inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			else
				minetest.item_drop(stack, player, pos)
			end
			return true
		end
	end

	for i = 1, inv:get_size("craft") do
		stack = inv:get_stack("craft", i)
		do_drop(stack)
	end
	inv:set_list("craft", {})

	local split = minetest.get_inventory({type = "detached", name = player:get_player_name() .. "_split"})
	if split then
		stack = split:get_stack("main", 1)
		if do_drop(stack) then
			split:set_list("main", {})
		end
	end
end

local function inventory_fields(_, player, _, fields)
	if not player or not player:is_player() then
		return
	end

	if fields.quit then
		drop_craft(player)
		return
	elseif fields.craftguide then
		sfinv.set_page(player, "craftguide:craftguide_inv")
	end
	
	drop_craft(player, true)
end

minetest.register_on_joinplayer(function(player)
	if not (creative and creative.is_enabled_for and
			creative.is_enabled_for(player)) then
		local player_name = player:get_player_name()
		local split_inv = minetest.create_detached_inventory(player_name .. "_split", {
			allow_put = function(_, _, _, stack, _)
				return stack:get_count() / 2
			end
		})
		split_inv:set_size("main", 1)
	end
end)

sfinv.override_page("sfinv:inventory", {
	get = function(_, player, context)
		return sfinv.make_formspec(player, context, formspec(player), false)
	end,
	on_player_receive_fields = inventory_fields
})
