local translator = minetest.get_translator
local S = translator and translator("throwing") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local creative = minetest.settings:get_bool("creative_mode")
local singleplayer = minetest.is_singleplayer()

local function arrow_impact(thrower, pos, dir, hit_object)
	if hit_object then
		local punch_damage = {
			full_punch_interval = 0,
			damage_groups = {fleshy = 5}
		}
		hit_object:punch(thrower, 0, punch_damage, dir)
	end
	minetest.add_item(pos, "throwing:arrow")
end

local throwing_shoot_arrow = function(player)
	local pos = player:get_pos()
	if not minetest.is_valid_pos(pos) then
		return
	end
	local obj = minetest.item_throw("throwing:arrow_item", player,
			24, -2, arrow_impact)
	if obj then
		local ent = obj:get_luaentity()
		if ent then
			minetest.sound_play("throwing_sound", {
				pos = pos,
				gain = 0.7,
				max_hear_distance = 10
			})
			obj:set_yaw(player:get_look_horizontal() - math.pi / 2)
			return true
		else
			obj:remove()
		end
	end
end

minetest.register_tool("throwing:bow", {
	description = S"Bow",
	inventory_image = "throwing_bow.png",

	on_use = function(itemstack, user)
		local inv = user:get_inventory()
		if inv:contains_item("main", "throwing:arrow") then
			if not creative or not singleplayer then
				inv:remove_item("main", "throwing:arrow")
			end
			local wear = itemstack:get_wear()
			itemstack:replace("throwing:bow_arrow")
			itemstack:add_wear(wear)
		end
		return itemstack
	end
})

minetest.register_tool("throwing:bow_arrow", {
	description = S"Bow with arrow",
	inventory_image = "throwing_bow_arrow.png",
	groups = {not_in_creative_inventory = 1},

	on_use = function(itemstack, user)
		local wear = itemstack:get_wear()
		itemstack:replace("throwing:bow")
		itemstack:add_wear(wear)
		if throwing_shoot_arrow(user) then
			if not creative then
				itemstack:add_wear(65535/256)
			end
		end
		return itemstack
	end
})

minetest.register_craftitem("throwing:arrow_item", {
	inventory_image = "throwing_arrow.png",
	groups = {not_in_creative_inventory = 1}
})

minetest.register_craft({
	output = "throwing:bow",
	recipe = {
		{"", "group:wood", "farming:string"},
		{"group:wood", "", "farming:string"},
		{"", "group:wood", "farming:string"}
	}
})

minetest.register_craftitem("throwing:arrow", {
	description = S"Arrow",
	inventory_image = "throwing_arrow_inv.png",
	groups = {wieldview = 2}
})

minetest.register_craft({
	output = "throwing:arrow 4",
	recipe = {
		{"default:flint"},
		{"default:stick"},
		{"default:paper"}
	}
})
