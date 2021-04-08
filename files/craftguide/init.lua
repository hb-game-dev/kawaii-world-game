local player_data = {}
local init_items = {}
local recipes_cache = {}
local usages_cache = {}

local table_concat = table.concat
local colorize = minetest.colorize
local registered_items = minetest.registered_items

local group_stereotypes = {
	dye = "dye:white",
	wool = "wool:white",
	coal = "default:coal_lump",
	vessel = "vessels:glass_bottle",
	flower = "flowers:dandelion_yellow",
	water_bucket = "bucket:bucket_water",
	mesecon_conductor_craftable = "mesecons:wire_00000000_off",
	stone = "default:cobble",
	algae = "ocean:ammania_bonsai"
}

local translator = minetest.get_translator
local S = translator and translator("craftguide") or intllib.make_gettext_pair()

if translator and minetest.is_singleplayer and
		not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local function table_replace(t, val, new)
	for k, v in pairs(t) do
		if v == val then
			t[k] = new
		end
	end
end

local function item_in_recipe(item, recipe)
	for _, recipe_item in pairs(recipe.items) do
		if recipe_item == item then
			return true
		end
	end
	return false
end

local function extract_groups(str)
	if str:sub(1, 6) == "group:" then
		return str:sub(7):split()
	end
end

local function item_has_groups(item_groups, groups)
	for i = 1, #groups do
		local group = groups[i]
		if (item_groups[group] or 0) == 0 then return end
	end

	return true
end

-- If item can be used in recipe because recipe takes a `group:` item that item
-- matches, return a copy of recipe with the `group:` item replaced with item.
local function groups_item_in_recipe(item, recipe)
	local item_groups = registered_items[item].groups

	for _, recipe_item in pairs(recipe.items) do
		local groups = extract_groups(recipe_item)
		if groups and item_has_groups(item_groups, groups) then
			local usage = table.copy(recipe)
			table_replace(usage.items, recipe_item, item)
			return usage
		end
	end
end

local function get_item_usages(item)
	local usages = {}
	local count = 1
	for _, recipes in pairs(recipes_cache) do
		for _, recipe in pairs(recipes) do
			if item_in_recipe(item, recipe) then
				usages[count] = recipe
				count = count + 1
			else
				recipe = groups_item_in_recipe(item, recipe)
				if recipe then
					usages[count] = recipe
					count = count + 1
				end
			end
		end
	end
	return #usages > 0 and usages
end

minetest.after(0, function()
	for name, def in pairs(registered_items) do
		if  def.groups.not_in_craft_guide ~= 1 and def.groups.stairs ~= 1 and
			def.description ~= "" and def.groups.not_in_creative_inventory ~= 1 then
			recipes_cache[name] = minetest.get_all_craft_recipes(name)
		end
	end
	local count = 1
	for name, def in pairs(registered_items) do
		if  def.groups.not_in_craft_guide ~= 1 and def.groups.stairs ~= 1 and
			def.description ~= "" and def.groups.not_in_creative_inventory ~= 1 then
			usages_cache[name] = get_item_usages(name)
			if recipes_cache[name] or usages_cache[name] then
				init_items[count] = name
				count = count + 1
			end
		end
	end
	table.sort(init_items)
end)

local function groups_to_item(groups)
	if #groups == 1 then
		local group = groups[1]
		if group_stereotypes[group] then
			return group_stereotypes[group]
		elseif registered_items["default:" .. group] then
			return "default:" .. group
		end
	end

	for name, def in pairs(registered_items) do
		if item_has_groups(def.groups, groups) then
			return name
		end
	end
	return ":unknown"
end

local function get_burntime(item)
	return minetest.get_craft_result({method = "fuel", width = 1, items = {item}}).time
end

local function get_tooltip(item, groups, burntime)
	local tooltip
	if groups then
		local groupstr = {}
		local count = 1
		for _, group in pairs(groups) do
			groupstr[count] = colorize("yellow", group)
			count = count + 1
		end
		groupstr = table_concat(groupstr, ", ")
		tooltip = Sl("Any item belonging to the groups:") .. " " .. groupstr
	else
		local itemdef = registered_items[item]
		tooltip = itemdef and itemdef.description or "Unknown Item"
	end

	if burntime > 0 then
		tooltip = tooltip .. "\n" .. Sl("Burning time:") .. " " .. colorize("yellow", burntime)
	end
	return ("tooltip[%s;%s]"):format(item, tooltip)
end

local function get_recipe_formspec(data)
	local fs = {}
	local recipe = data.recipes[data.rnum]
	local width = recipe.width
	local cooktime, shapeless

	if recipe.method == "cooking" then
		cooktime, width = width, 1
	elseif width == 0 then
		shapeless = true
		width = #recipe.items <= 4 and 2 or math.min(3, #recipe.items)
	end
	
	local r_x = 3.8
	
	if #data.recipes > 9 and data.rnum < 10 then
		r_x = 3.7
	elseif #data.recipes > 9 and data.rnum > 9 then
		r_x = 3.6
	end
	
	fs[#fs+1] = ("label[" .. r_x .. ",3.1;%s %d" .. Sl("of") .. "%d]")
		:format(data.show_usages and Sl("") or Sl(""), data.rnum, #data.recipes)

	if #data.recipes > 1 then
		fs[#fs+1] = "image_button[3.1,3;0.8,0.8;craftguide_button.png^craftguide_prev.png;recipe_prev;;true;false]" ..
			"image_button[5.1,3;0.8,0.8;craftguide_button.png^craftguide_next.png;recipe_next;;true;false]"
	end

	local cells = ""
	for x = 0, 2 do
	for y = 1, 3 do
		cells = cells ..
			"image_button[" .. x .. "," .. y - 0.1 .. ";1,1;formspec_cell.png;%s;;;false;formspec_cell.png^default_item_pressed.png]"
	end
	end
	
	fs[#fs+1] = cells

	local rows = math.ceil(table.maxn(recipe.items) / width)
	if width > 3 or rows > 3 then
		fs[#fs+1] = "label[0,1.5;Recipe is too big to be displayed.]"
		return table_concat(fs)
	end

	for i, item in pairs(recipe.items) do
		local x = ((i - 1) % width + 4 - math.min(width + 1, 3)) - 1
		local y = math.ceil(i / width + 6 - (rows > 1 and rows - 1 or 1)) - 4.1

		local burntime = get_burntime(item)
		local groups = extract_groups(item)
		local tooltip
		if groups then
			item = groups_to_item(groups)
		else
			local def = registered_items[item]
			tooltip = (def and def.description or "")
		end
		fs[#fs+1] = (
			"item_image[%d,%f;1,1;%s]" ..
			"image_button[%d,%f;1,1;blank.png;%s;;;false;default_item_pressed.png]" ..
			"tooltip[%s;%s]"
			):format(x, y, item, x, y, item, item, tooltip or "")

		if groups or burntime > 0 then
			fs[#fs+1] = get_tooltip(item, groups, burntime)
		end
	end

	if shapeless or recipe.method == "cooking" then
		fs[#fs+1] = ("image_button[7,1.9;1,1;%s.png;tooltip_image;;false;false]")
			:format(shapeless and "craftguide_shapeless" or "default_furnace_front_active")
		local tooltip = shapeless and "Shapeless" or
			Sl("Cooking time:") .. colorize("yellow", cooktime)
		local t_x = 5.75
		
		if tooltip == "Shapeless" then
			t_x = 6.4
		end
		fs[#fs+1] = "label[" .. t_x .. ",3.1;" .. tooltip .. "]"
	end

	local output_name = recipe.output:match("%S*")
	local def = registered_items[output_name]
	local tooltip = def and def.description or ""
	local item_name = def.description
	local l_x = 4.3 - (item_name:len() / 10) 
	if l_x < 3 then
		l_x = 3
	end
	fs[#fs+1] = (
		"label[" .. l_x .. ",0.9;" .. item_name .. "]" ..
		"image[3,1.9;1,1;default_arrow_bg.png^[transformR270]" ..
		"item_image[4,1.9;1,1;%s]" ..
		"image_button[3.9,1.8;1.2,1.2;formspec_cell.png;%s;;;false;formspec_cell.png^default_item_pressed.png]" ..
		"tooltip[%s;%s]"
		):format(recipe.output, recipe.output, recipe.output, recipe.output, tooltip)
	local burntime = get_burntime(output_name)
	if burntime > 0 then
		fs[#fs+1] = get_tooltip(output_name, nil, burntime)
	end
	return table_concat(fs)
end

local function get_formspec(name, inv)
	local data = player_data[name]
	data.pagemax = math.max(1, math.ceil(#data.items / 36))

	local fs = {
		"background[-0.2,-0.26;9.41,9.49;formspec_backround.png;true]"
	}

	fs[#fs+1] = ("field[4.3,0.35;2.69,0.75;filter;;%s]")
		:format(minetest.formspec_escape(data.filter))
	fs[#fs+1] = ("label[3.5,8.3;" .. " %s " .. Sl("of") .. " %s]")
		:format(colorize("yellow", data.pagenum), colorize("yellow", data.pagemax))
	fs[#fs+1] = [[
		image_button[0.02,-0.25;1,1;blank.png;inventory;;true;false]
		image[-0.23,-0.26;9,1;formspec_craftguid_btn.png]
		image_button[6.49,0;0.83,0.83;search_button.png;search;;true;false]
		image_button[7.19,0;0.83,0.83;craftguide_button.png^craftguide_clear.png;clear;;true;false]
		image_button[0,8.15;0.8,0.8;craftguide_button.png^craftguide_prev.png;prev;;true;false]
		image_button[8.2,8.15;0.8,0.8;craftguide_button.png^craftguide_next.png;next;;true;false]
		tooltip[inventory;]] .. Sl("Inventory") .. [[]		
		tooltip[search;]] .. Sl("Search") .. [[]
		tooltip[clear;]] .. Sl("Clear") .. [[]
		tooltip[prev;]] .. Sl("Previous page") .. [[]
		tooltip[next;]] .. Sl("Next page") .. [[]
		field_close_on_enter[filter;false]
	]]


	fs[#fs+1] = "image_button_exit[8.55,-0.25;0.75,0.75;blank.png;exit;;true;false;blank.png]"

	if #data.items == 0 then
		fs[#fs+1] = "label[0,1.5;" .. Sl("No items to show.") .. "]"
	else
		local first_item = (data.pagenum - 1) * 36
		for i = first_item, first_item + 35 do
			local item = data.items[i + 1]
			if not item then
				break
			end
			local def = registered_items[item]
			local tooltip = def and def.description or ""
			local x = i % 9
			local y = (i % 36 - x) / 9 + 4
			fs[#fs+1] = (
				"item_image[%d,%d;1,1;%s]" ..
				"image_button[%d,%d;1,1;formspec_cell.png;%s_inv;;;false;formspec_cell.png^default_item_pressed.png]" ..
				"tooltip[%s_inv;%s]"
					):format(x, y, item, x, y, item, item, tooltip)
		end
	end

	if data.recipes then
		if #data.recipes > 0 then
			fs[#fs+1] = get_recipe_formspec(data)
		elseif data.show_usages then
			fs[#fs+1] = "label[0,1.5;" .. Sl("No usages.\nClick again to show recipes.") .. "]"
		else
			fs[#fs+1] = "label[0,1.5;" .. Sl("No recipes.\nClick again to show usages.") .. "]"
		end
	else
		fs[#fs+1] = "label[0,1.5;" .. Sl("Select an item from the list\nto view recipes and usages.") .. "]"
	end
	return table_concat(fs)
end

local function execute_search(data)
	local filter = data.filter
	if filter == "" then
		data.items = init_items
		return
	end
	data.items = {}
	local count = 1

	for _, item in pairs(init_items) do
		local itemdef = registered_items[item]
		local desc = itemdef and itemdef.description:lower() or ""

		if item:find(filter, 1, true) or desc:find(filter, 1, true) then
			data.items[count] = item
			count = count + 1
		end
	end
end

local function reset_data(data)
	data.filter = ""
	data.pagenum = 1
	data.prev_item = nil
	data.recipes = nil
	data.items = init_items
end

local function on_receive_fields(player, fields)
	local name = player:get_player_name()
	local data = player_data[name]
		
	if fields.inventory then
		sfinv.set_page(player, sfinv.get_homepage_name(player))
		return true

	elseif fields.clear then
		reset_data(data)
		return true

	elseif fields.key_enter_field == "filter" or fields.search then
		local new = fields.filter:lower()
		if new ~= "" and data.filter == new then
			return
		end
		data.filter = new
		data.pagenum = 1
		execute_search(data)
		return true

	elseif fields.prev or fields.next then
		if data.pagemax == 1 then
			return
		end
		data.pagenum = data.pagenum + (fields.next and 1 or -1)
		if data.pagenum > data.pagemax then
			data.pagenum = 1
		elseif data.pagenum == 0 then
			data.pagenum = data.pagemax
		end
		return true

	elseif fields.recipe_next or fields.recipe_prev then
		data.rnum = data.rnum + (fields.recipe_next and 1 or -1)
		if not data.recipes then return false end
		if data.rnum > #data.recipes then
			data.rnum = 1
		elseif data.rnum == 0 then
			data.rnum = #data.recipes
		end
		return true

	else
		local item
		for field in pairs(fields) do
			if field:find(":") then
				item = field
				break
			end
		end
		if not item then
			return
		end
		if item:sub(-4) == "_inv" then
			item = item:sub(1, -5)
		end

		if item == data.prev_item then
			data.show_usages = not data.show_usages
		else
			data.show_usages = nil
		end
		if data.show_usages then
			data.recipes = usages_cache[item] or {}
		else
			data.recipes = recipes_cache[item] or {}
		end
		data.prev_item = item
		data.rnum = 1
		return true
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	player_data[name] = {
		filter = "",
		pagenum = 1,
		items = init_items
	}
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_data[name] = nil
end)

sfinv.register_page("craftguide:craftguide", {
	get = function(_, player, context)
		local name = player:get_player_name()
		return sfinv.make_formspec(player, context, get_formspec(name), false)
	end,
	on_player_receive_fields = function(_, player, _, fields)
		if on_receive_fields(player, fields) then
			sfinv.open_formspec(player)
		end
	end
})

sfinv.register_page("craftguide:craftguide_inv", {
	get = function(_, player, context)
		local name = player:get_player_name()
		return sfinv.make_formspec(player, context, get_formspec(name, true), false)
	end,
	on_player_receive_fields = function(_, player, _, fields)
		if on_receive_fields(player, fields) then
			sfinv.set_player_inventory_formspec(player)
		end
	end
})
