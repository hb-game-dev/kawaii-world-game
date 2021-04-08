local S = sethome.S
local esc = minetest.formspec_escape
local string_to_pos = minetest.string_to_pos
function pos_to_string(pos, decimal)
	decimal = decimal or 1
	return minetest.pos_to_string(pos, decimal)
end
local is_valid_pos = minetest.is_valid_pos
local b = "blank.png"
local ceil, min, max = math.ceil, math.min, math.max

local function get_homes_list()
	local list = {}
	for _, p in ipairs(minetest.get_connected_players()) do
		local pos = minetest.string_to_pos(p:get_attribute("sethome:public"))
		local desc = p:get_attribute("sethome:public_desc")
		if not desc or desc == "" then
			desc = S"My Home"
		end
		if is_valid_pos(pos) then
			local name = p:get_player_name()
			list[#list + 1] = {name = name, pos = pos, desc = desc}
		end
	end

	return list
end

local pages = {}
minetest.register_on_leaveplayer(function(player)
	pages[player:get_player_name()] = nil
end)

local function get_page(name)
	local list = get_homes_list()
	local total_pages = ceil(#list / 8)
	local page = min(max(pages[name] or 1, 1), total_pages)
	return page, total_pages, list
end

local function get_head_texture(name)
	return player_api.preview(name, nil, true)
end

local fs_prepend = default.gui_bg ..
	"background[0,0;0,0;formspec_background_color.png;true]" ..
	"background[0,0;0,0;formspec_backround.png;true]"

local function get_formspec(name)
	local page, total_pages, list = get_page(name)
	local start = (page - 1) * 8 + 1

	local player = minetest.get_player_by_name(name)
	if not player then return "" end
	local pos = string_to_pos(player:get_attribute("sethome:home"))
	local public_pos = string_to_pos(player:get_attribute("sethome:public"))
	local desc = player:get_attribute("sethome:public_desc")
	if not desc or desc == "" then
		desc = S"My Home"
	end
	local current_home
	if is_valid_pos(pos) then
		current_home = S("Private Home point:\n@1", pos_to_string(pos, 0))
	else
		current_home = S"Private Home point:\nnot set!"
	end

	local fs = "size[9.21,11.4]" .. fs_prepend ..
		"image_button_exit[8.6,-0.1;0.75,0.75;close.png;exit;;true;false;close_pressed.png]" ..
		"image[0,-0.1;1,1;sethome.png]" ..
		"label[0.9,0.1;" .. S"Your Home" .. "]" ..
		"label[0.1,0.69;" .. current_home .. "]" ..
		"image_button[5.5,0.8;3.8,0.78;" .. b .. ";set_home;" .. S"Update" ..
			"]" ..
		"image[0,2.35;1,1;sethome.png]" ..
		"label[0.9,2.55;" .. S"Other Player's Homes" .. "]" ..
		"image_button[0.1,10.7;1.4,0.8;" .. b .. ";first;<<]" ..
		"image_button[6.5,10.7;1.4,0.8;" .. b .. ";next;>]" ..
		"image_button[7.7,10.7;1.4,0.8;" .. b .. ";last;>>]" ..
		"image_button[1.3,10.7;1.4,0.8;" .. b .. ";prev;<]" ..
		"image_button[2.5,10.7;4.2,0.8;" .. b .. ";;" ..
			S("Page: @1 of @2", page, total_pages) .. ";false;false;]"

	if is_valid_pos(public_pos) then
		fs = fs ..
			"label[0.1,1.55;" .. S("Public Home point:\n@1 - @2",
				pos_to_string(public_pos, 0), desc) .. "]" ..
			"image_button[5.5,1.65;2,0.78;" .. b .. ";set_public_home;" ..
				S"Update" .. "]" ..
			"image_button[7.3,1.65;2,0.78;" .. b .. ";remove_public_home;" ..
				S"Remove" .. "]"
	else
		fs = fs ..
			"label[0.1,1.55;" .. S"Public Home point:\nnot set!" .. "]" ..
			"image_button[5.5,1.65;3.8,0.78;" .. b .. ";set_public_home;" ..
				S"Set" .. "]"
	end

	local y = 1.593
	for i = 0, 7 do
		local home = list[start + i]
		if home == nil then break end
		local x
		if i % 2 == 0 then
			x = 0.1
			y = y + 1.727
		else
			x = 4.9
		end
		local player_iter = minetest.get_player_by_name(home.name)
		fs = fs .. "image[" .. x .. "," .. y .. ";1.5,1.5;" ..
				get_head_texture(player_iter) .. "]" ..
			"label[" .. (x + 1.5) .. "," .. y .. ";" .. esc(home.name) ..
			--	": " .. pos_to_string(home.pos, 0) .. "]" ..
				"]" ..
			"image_button_exit[" .. (x + 1.5) .. "," .. (y + 0.65) ..
				";2.7,0.78;" .. b .. ";->" .. esc(home.name) .. ";" ..
				home.desc .. "]"
	end

	return fs
end

function sethome.gui(name)
	if type(name) ~= "string" then
		name = name:get_player_name()
	end
	minetest.show_formspec(name, "sethome:homes", get_formspec(name))
end

local function yes_no_fs(name, msg, yes_btn, no_btn, field)
	minetest.show_formspec(name, "sethome:homes",
		"size[8.01,2.5]" .. fs_prepend ..
		"label[0.1,0;" .. msg .. "]" ..
		(field and field or "") ..
		"image_button[0.1,1.84;3.81,0.78;" .. b .. ";" .. yes_btn .. ";" ..
			S"Yes" .. "]" ..
		"image_button[4.1,1.84;3.81,0.78;" .. b .. ";" .. no_btn .. ";" ..
			S"No" .. "]")
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "sethome:homes" then return end
	local name = player:get_player_name()

	local page, total_pages = get_page(name)
	if fields.first then
		pages[name] = nil
	elseif fields.prev then
		pages[name] = page - 1
	elseif fields.next then
		pages[name] = page + 1
	elseif fields.last then
		pages[name] = total_pages
	elseif fields.set_home then
		local pos = player:get_pos()
		if is_valid_pos(pos) then
			yes_no_fs(name, S("Are you sure you want to update your Private " ..
				"Home point at @1?", pos_to_string(pos)),
				"confirm_set_home", "cancel_set")
		end
		return
	elseif fields.confirm_set_home then
		sethome.set(player, name)
	elseif fields.set_public_home then
		local pos = player:get_pos()
		if is_valid_pos(pos) then
			local field = "field[2.5,1.1;3.5,0.8;home_name;" ..
				S"Enter Home name:" .. ";" .. S"My Home" .. "]"
			yes_no_fs(name, S("Are you sure you want to update your Public " ..
				"Home point at @1?", pos_to_string(pos)),
				"confirm_set_public_home", "cancel_set", field)
			end
		return
	elseif fields.confirm_set_public_home then
		local param = "public"
		local home_name = fields.home_name
		if home_name and home_name ~= "" then
			param = param .. " name " .. esc(home_name):sub(1, 24)
		end
		sethome.set(player, name, param)
	elseif fields.remove_public_home then
		yes_no_fs(name, S("Are you sure you want to delete your Public " ..
			"Home point?"), "confirm_remove_public_home", "cancel_set")
		return
	elseif fields.confirm_remove_public_home then
		sethome.set(player, name, "public delete")
	elseif not fields.cancel_set then
		if fields.quit then pages[name] = nil end
		for field in pairs(fields) do
			if field:sub(1, 2) == "->" then
				sethome.go(player, name, field:sub(3))
				break
			end
		end
		return
	end
	sethome.gui(name)
end)

minetest.register_chatcommand("homes", {
	description = "Home GUI",
	func = sethome.gui
})
