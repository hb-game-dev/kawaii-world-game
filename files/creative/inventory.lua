local has_armor = minetest.get_modpath("3d_armor")
local search_button = minetest.is_singleplayer() ~= true or PLATFORM == "Android" or PLATFORM == "iOS"
local inventory_cache = {}
local player_inventory = {}
local show_creative_tabs = true

local registered_items = minetest.registered_items

local ofs_tab = {
	["blocks"] = "0,1",
	["stairs"] = "1,1",
	["bluestone"] = "2,1",
	["mobs"] = "3,1",
	["misc"] = "4,1",
	["food"] = "5,1",
	["tools"] = "6,1",
	["matr"] = "7,1",
	["brew"] = "8,1",
	["all"] = "0,0",
	["inv"] = "1,0"
}

local ofs_img = {
	["blocks"] = "0.1,1.2",
	["stairs"] = "1.1,1.2",
	["bluestone"] = "2.1,1.2",
	["mobs"] = "3.1,1.2",
	["misc"] = "4.1,1.2",
	["food"] = "5.1,1.2",
	["tools"] = "6.1,1.2",
	["matr"] = "7.1,1.2",
	["brew"] = "8.1,1.2",
	["all"] = "0.15,0",
	["inv"] = "1.15,0"
}

local bg = {
	["blocks"] = "default:dirt_with_grass",
	["stairs"] = "stairs:stair_default_mossycobble",
	["bluestone"] = "mesecons_lightstone:lightstone_on",
	["mobs"] = "mobs_animal:cow",
	["misc"] = "bucket:bucket_lava",
	["food"] = "default:apple",
	["tools"] = "default:pick_emerald",
	["matr"] = "default:ruby",
	["brew"] = "vessels:glass_bottle",
	["all"] = "default:paper",
	["inv"] = "default:chest"
}

local rot = {
	["all"] = "^[transformR270",
	["inv"] = "^[transformR270"
}

local function found_in_list(name, list)
	for _, v in pairs(list) do
		if name:find(v) then return true end
	end
end

local filters = {
	["all"] = function(_, def)
		return true and not def.groups.stairs
	end,
	["blocks"] = function(name, def)
	return minetest.registered_nodes[name] and
		not def.mesecons and not def.groups.stairs and
		(def.drawtype == "normal" or def.drawtype:sub(1, 5) == "glass" or def.drawtype:sub(1, 8) == "allfaces") or
		found_in_list(name, {"cactus", "slimeblock"})
	end,
	["stairs"] = function(_, def)
		return def.groups.stairs
	end,
	["bluestone"] = function(name)
		return name:find("mese") or found_in_list(name, {"^bluestone", "^tnt:", "^doors:", "^boats:", "^carts:"})
	end,
	["mobs"] = function(name, def)
		return def.groups.spawn_egg or found_in_list(name, {"mobs:nametag"}) or found_in_list(name, {"mobs:shears"})
	end,
	["food"] = function(_, def)
		return (def.groups.food or def.groups.farming or def.groups.seed) and not def.groups.stairs
	end,
	["tools"] = function(name)
		return minetest.registered_tools[name] or found_in_list(name, {"arrow"})
	end,
	["matr"] = function(name, def)
		return minetest.registered_craftitems[name] and
		not found_in_list(name, {"^boats:", "^carts:", "^boats:", "^bucket:", "^farming", "^doors:", "^pep:", "^vessels:", "mobs:nametag"}) and
		not def.groups.food and not def.on_use or def.groups.dye -- not a mistake!
	end,
	["brew"] = function(name)
		return found_in_list(name, {"^vessels:", "^pep:"})
	end
}

-- Not found in any other category except all
filters["misc"] = function(name, def)
	for filter, func in pairs(filters) do
		if filter ~= "misc" and filter ~= "all" and func(name, def) then
			return
		end
	end
	return true
end

minetest.after(2, function()
	local creative_items = {}
	for name, def in pairs(registered_items) do
		if def.description and def.description ~= "" then
			local ncinv = def.groups.not_in_creative_inventory
			if not ncinv or ncinv <= 0 then
				creative_items[name] = def
			end
		end
	end

	for tab_name, _ in pairs(filters) do
		inventory_cache[tab_name] = {}
		local i_cache = inventory_cache[tab_name]
		local filter = filters[tab_name]
		for name, def in pairs(creative_items) do
			if filter(name, def) then
				i_cache[name] = def.description
			end
		end
	end
	creative_items = nil
end)

local function init_creative_inventory(player_name)
	player_inventory[player_name] = {
		size = 0,
		filter = "",
		start_i = 0,
		list = {}
	}
	return player_inventory[player_name]
end


local function filtermatch(s, filter)
	if s:find(filter, 1, true) then
		return #s - #filter
	end
	return nil
end

local tsort = table.sort
local function update_creative_inventory(player_name, tab_name)
	local inv = player_inventory[player_name] or
			init_creative_inventory(player_name)
	local creative_list = inv.list
	local order = {}
	for i = 1, #creative_list do
		creative_list[i] = nil
	end
	local items = inventory_cache[tab_name] or {}
	local filter = tab_name == "all" and inv.filter or nil
	for name, description in pairs(items) do
		if filter then
			local m = filtermatch(description:lower(), filter) or filtermatch(name, filter)
			if m then
				creative_list[#creative_list + 1] = name
				order[name] = m
			end
		else
			creative_list[#creative_list + 1] = name
		end
	end

	if tab_name == "stairs" then
		tsort(creative_list, function(a, b) return items[a] < items[b] end)
	else
		if filter then
			tsort(creative_list, function(a, b) return order[a] < order[b] end)
		else
			tsort(creative_list)
		end
	end
	inv.size = #creative_list
	inv.filter = filter or ""
end

local function get_button_formspec(player_name, start_i, page)
	local buttons = ""
	local inv = player_inventory[player_name] or {}
	local creative_list = inv.list or {}
	local i = start_i + 1
	if page == "all" then 
		for y = 0, 5 do
		for x = 0, 8 do
			local pos = x .. "," .. y + 1.15
			local item = creative_list[i]
			if not item then return buttons end
			local def = registered_items[item]
			local tooltip = def and def.description or ""
			buttons = buttons .. "item_image[" .. pos .. ";1,1;" .. item .. "]" ..
				"image_button[" .. pos .. ";1,1;blank.png;" .. item .. ";;;false;default_item_pressed.png]" ..
				"tooltip[" .. item .. ";" .. tooltip .. "]"
			i = i + 1
		end
		end
	else
		for y = 0, 4 do
		for x = 0, 8 do
			local pos = x .. "," .. y + 2.05
			local item = creative_list[i]
			if not item then return buttons end
			local def = registered_items[item]
			local tooltip = def and def.description or ""
			buttons = buttons .. "item_image[" .. pos .. ";1,1;" .. item .. "]" ..
				"image_button[" .. pos .. ";1,1;blank.png;" .. item .. ";;;false;default_item_pressed.png]" ..
				"tooltip[" .. item .. ";" .. tooltip .. "]"
			i = i + 1
		end
		end
	end
	return buttons
end

local function get_creative_formspec(player_name, start_i, pagenum, page, pagemax, title)
	page = page or "blocks"
	pagenum = pagenum or 1
	pagemax = (pagemax and pagemax ~= 0) and pagemax or 1
	title = title or ""
	
	local formspec = 
		"bgcolor[#08080880;true]" ..
		"listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]" ..
		"background[0,0;0,0;formspec_backround.png;true]" ..
		"image_button_exit[8.55,-0.25;0.75,0.75;blank.png;exit;;true;false;blank.png]"
		
	local main_list
	if show_creative_tabs == true then
		main_list = get_button_formspec(player_name, start_i, page)
		formspec = formspec ..
		"image[-0.23,-0.26;9,1;formspec_tabs_btn.png]" ..
		"image_button[0.92,-0.25;1,1;blank.png;default;;true;false;blank.png]" ..
		"tooltip[default;" .. Sl("Search Item") .. "]" ..
		"image_button[1.87,-0.25;1,1;blank.png;inv;;true;false;blank.png]" ..
		"tooltip[inv;" .. Sl("Inventory") .. "]" ..
			
		"item_image[" .. ofs_img["blocks"] .. ";0.7,0.7;" .. bg["blocks"] .. "]" ..
		"image_button[" .. ofs_tab["blocks"] .. ";1,1;blank.png;build;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["stairs"] .. ";0.7,0.7;" .. bg["stairs"] .. "]" ..
		"image_button[" .. ofs_tab["stairs"] .. ";1,1;blank.png;stairs;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["bluestone"] .. ";0.7,0.7;" .. bg["bluestone"] .. "]" ..
		"image_button[" .. ofs_tab["bluestone"] .. ";1,1;blank.png;bluestone;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["mobs"] .. ";0.7,0.7;" .. bg["mobs"] .. "]" ..
		"image_button[" .. ofs_tab["mobs"] .. ";1,1;blank.png;mobs;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["misc"] .. ";0.7,0.7;" .. bg["misc"] .. "]" ..
		"image_button[" .. ofs_tab["misc"] .. ";1,1;blank.png;misc;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["food"] .. ";0.7,0.7;" .. bg["food"] .. "]" ..
		"image_button[" .. ofs_tab["food"] .. ";1,1;blank.png;food;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["tools"] .. ";0.7,0.7;" .. bg["tools"] .. "]" ..
		"image_button[" .. ofs_tab["tools"] .. ";1,1;blank.png;tools;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["matr"] .. ";0.7,0.7;" .. bg["matr"] .. "]" ..
		"image_button[" .. ofs_tab["matr"] .. ";1,1;blank.png;matr;;true;false;blank.png]" ..
		
		"item_image[" .. ofs_img["brew"] .. ";0.7,0.7;" .. bg["brew"] .. "]" ..
		"image_button[" .. ofs_tab["brew"] .. ";1,1;blank.png;brew;;true;false;blank.png]"
				
		if page == "blocks" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_blocks_tab.png;true]"
		elseif page == "stairs" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_stairs_tab.png;true]"
		elseif page == "bluestone" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_bluestone_tab.png;true]"
		elseif page == "mobs" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_mobs_tab.png;true]"
		elseif page == "misc" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_misc_tab.png;true]"
		elseif page == "food" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_food_tab.png;true]"
		elseif page == "tools" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_tools_tab.png;true]"
		elseif page == "matr" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_matr_tab.png;true]"
		elseif page == "brew" then
			formspec = formspec .. "background[0,0;0,0;formspec_creative_brew_tab.png;true]"
		end
		
		formspec = formspec ..
			main_list ..
			"list[current_player;main;0.01,7.75;9,1;]" .. 
			"label[3.8,7.15;" .. pagenum .. Sl("of") .. pagemax .. "]" ..
			"image_button[0,7.2;1,0.5;blank.png;creative_prev;;;false]" ..
			"image_button[8,7.2;1,0.5;blank.png;creative_next;;;false]"
	elseif page == "inv" then
		formspec = formspec ..
		"background[0,0;0,0;formspec_creative_inventory.png;true]" ..
		"image[-0.23,-0.26;9,1;formspec_inventory_alt_btn.png]" ..
		"image_button[0.02,-0.25;1,1;blank.png;tabs;;true;false;blank.png]" ..
		"tooltip[tabs;" .. Sl("Creative") .. "]" ..
		"image_button[0.92,-0.25;1,1;blank.png;default;;true;false;blank.png]" ..
		"tooltip[default;" .. Sl("Search Item") .. "]" ..
		
		"list[current_player;main;0.01,4.51;9,3;9]" ..
		"list[current_player;main;0.01,7.75;9,1;]"
		
		if has_armor then
			formspec = formspec .. 
			"image[5.5,0.15;2.2,4.4;" .. player_api.preview(minetest.get_player_by_name(player_name)) .. "]" ..
			
			"list[detached:" .. player_name .. "_armor;armor;4,0.15;1,1;]" ..
			"list[detached:" .. player_name .. "_armor;armor;4,1.15;1,1;1]" ..
			"list[detached:" .. player_name .. "_armor;armor;4,2.15;1,1;2]" ..
			"list[detached:" .. player_name .. "_armor;armor;4,3.15;1,1;3]"
		end
	elseif page == "all" then
		main_list = get_button_formspec(player_name, start_i, page)
		formspec = formspec ..
		"background[0,0;0,0;formspec_creative_search.png;true]" ..
		"image[-0.23,-0.26;9,1;formspec_search_btn.png]" ..
		"image_button[0.02,-0.25;1,1;blank.png;tabs;;true;false;blank.png]" ..
		"tooltip[tabs;" .. Sl("Creative") .. "]" ..
		"image_button[1.87,-0.25;1,1;blank.png;inv;;true;false;blank.png]" ..
		"tooltip[inv;" .. Sl("Inventory") .. "]"
		
		local inv = player_inventory[player_name] or {}
		local filter = inv.filter or ""
		formspec = formspec .. "field_close_on_enter[Dsearch;false]"
		if search_button then
			formspec = formspec ..
				"field[4.5,0.25;3.4,0.75;Dsearch;;" .. filter .. "]" ..
				"image_button[7.4,-0.1;0.83,0.83;search_button.png;creative_search;;;false]"
		else
			formspec = formspec .. "field_close_on_enter[Dsearch;false]" ..
				"field[4.5,0.25;4.03,0.75;Dsearch;;" .. filter .. "]"
		end
		formspec = formspec ..
			main_list ..
			"list[current_player;main;0.01,7.75;9,1;]" ..
			"label[3.8,7.15;" .. pagenum .. Sl("of") .. pagemax .. "]" ..
			"image_button[0,7.2;1,0.5;blank.png;creative_prev;;;false]" ..
			"image_button[8,7.2;1,0.5;blank.png;creative_next;;;false]"
		
	end
	return formspec .. "p" .. pagenum
end

local function add_to_player_inventory(player, item)
	if not player or not item then return end
	local inv = player:get_inventory()
	if not inv or not inv:room_for_item("main", item) then return end
	local def = registered_items[item]
	local ncinv = def and def.groups and def.groups.not_in_creative_inventory
	if def and (not ncinv or ncinv <= 0) then
		inv:add_item("main", item)
	end
end

local ceil, floor, max = math.ceil, math.floor, math.max
local function register_tab(name, title)
	sfinv.register_page("creative:" .. name, {
		get = function(_, player, context)
			local player_name = player:get_player_name()
			update_creative_inventory(player_name, name)
			local inv = player_inventory[player_name] or
					init_creative_inventory(player_name)
			local start_i = inv.start_i
			local pagenum = floor(start_i / 45 + 1)
			local pagemax = ceil(inv.size / 45)
			local formspec = get_creative_formspec(player_name, start_i,
					pagenum, name, pagemax, title)
			return sfinv.make_formspec(player, context, formspec, false, "size[9,8.75]")
		end,
		on_enter = function(_, player)
			local player_name = player:get_player_name()
			local inv = player_inventory[player_name]
			if inv then
				inv.start_i = 0
			end
		end,
		on_player_receive_fields = function(_, player, context, fields)
			local player_name = player:get_player_name()
			local inv = player_inventory[player_name]
			if not inv or not creative.is_enabled_for(player_name) then
				return
			end
			for field, _ in pairs(fields) do
				if field:find(":") then
					add_to_player_inventory(player, field)
					return
				end
			end

			if fields.build then
				sfinv.set_page(player, "creative:blocks")
			elseif fields.tabs then
				show_creative_tabs = true
				sfinv.set_page(player, "creative:blocks")
			elseif fields.stairs then
				sfinv.set_page(player, "creative:stairs")
			elseif fields.bluestone then
				sfinv.set_page(player, "creative:bluestone")
			elseif fields.mobs then
				sfinv.set_page(player, "creative:mobs")
			elseif fields.misc then
				sfinv.set_page(player, "creative:misc")
			elseif fields.default then
				show_creative_tabs = false
				sfinv.set_page(player, "creative:all")
			elseif fields.food then
				sfinv.set_page(player, "creative:food")
			elseif fields.tools then
				sfinv.set_page(player, "creative:tools")
			elseif fields.combat then
				sfinv.set_page(player, "creative:combat")
			elseif fields.matr then
				sfinv.set_page(player, "creative:matr")
			elseif fields.inv then
				show_creative_tabs = false
				sfinv.set_page(player, "creative:inv")	
			elseif fields.brew then
				sfinv.set_page(player, "creative:brew")
			elseif (fields.Dsearch and fields.Dsearch ~= "") or
					fields.creative_search or
					fields.key_enter_field == "Dsearch" then
				inv.filter = fields.Dsearch and fields.Dsearch:lower()
				inv.start_i = 0
				sfinv.set_player_inventory_formspec(player, context)
			elseif not fields.quit then
				local start_i = inv.start_i or 0
				local size = inv.size
				if fields.creative_prev then
					start_i = start_i - 45
					if start_i < 0 then
						start_i = size - (size % 45)
						if size == start_i then
							start_i = max(0, size - 45)
						end
					end
				elseif fields.creative_next then
					start_i = start_i + 45
					if start_i >= size then
						start_i = 0
					end
				end
				inv.start_i = start_i
				sfinv.set_player_inventory_formspec(player, context)
			end
		end
	})
end

register_tab("inv", "Inventory")
register_tab("all", "Search Items")
register_tab("blocks", "Building Blocks")
register_tab("stairs", "Cutted Blocks")
register_tab("bluestone", "Bluestone and Transport")
register_tab("mobs", "Mob Spawning Eggs")
register_tab("misc", "Non Cubic Stuff")
register_tab("food", "Food and Seeds")
register_tab("tools", "Tools and Armor")
register_tab("matr", "Items and Dyes")
register_tab("brew", "Potions")

local old_homepage_name = sfinv.get_homepage_name
function sfinv.get_homepage_name(player)
	if creative.is_enabled_for(player:get_player_name()) then
		show_creative_tabs = true
		return "creative:blocks"
	else
		return old_homepage_name(player)
	end
end

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	player_inventory[player_name] = nil
end)

function creative.set_tabs_status(status)
	if status ~= nil and status == true then
		show_creative_tabs = true
	elseif status ~= nil and status == false then
		show_creative_tabs = false
	end
end
-- Create the trash field
local trash = minetest.create_detached_inventory("creative_trash", {
	on_put = function(inv, listname, _, stack)
		inv:remove_item(listname, stack)
	end
})
trash:set_size("main", 1)
