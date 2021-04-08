local get_craft_result = minetest.get_craft_result

local function add_item(player, inv, item)
	local remaining_stack = inv:add_item("main", item)
	if not remaining_stack:is_empty() then
		minetest.add_item(player:get_pos(), remaining_stack)
	end
end

-- This is horrible because I don't want to break with replacements
local function do_craft(player, inv, expected_item)
	local output, decremented_input = get_craft_result({
		method = "normal",
		width = 3,
		items = inv:get_list("craft")
	})

	if output.item:is_empty() then return false end

	-- Abort if the recipe changed
	local item_name = output.item:to_string()
	if expected_item and item_name ~= expected_item then
		return false
	end

	-- Update inventory lists
	inv:set_list("craft", decremented_input.items)
	add_item(player, inv, output.item)

	-- Replacements feel hacky
	for _, item in ipairs(output.replacements) do
		add_item(player, inv, item)
	end

	return true
end

function workbench.craft_all(player)
	local inv = player:get_inventory()

	local items = inv:get_list("craft")
	local output = get_craft_result({
		method = "normal",
		width = 3,
		items = items
	})

	-- Don't do anything if the recipe is invalid.
	if output.item:is_empty() then
		return
	end

	local expected_item = output.item:to_string()
	local count = 0
	if #output.replacements > 0 then
		-- If there are replacements, do each craft individually to try and
		-- work around any side-effects.
		while do_craft(player, inv, expected_item) do
			-- Limit the amount of crafts to prevent lag.
			count = count + 1
			if count > 200 then break end
		end
	else
		-- Craft results are guaranteed to only have one item at the moment
		for _, stack in ipairs(items) do
			local stack_count = stack:get_count()
			if (count > stack_count or count == 0) and stack_count > 0 then
				count = stack_count
			end
		end

		-- Take items
		for _, stack in ipairs(items) do
			stack:take_item(count)
		end
		inv:set_list("craft", items)

		local result = ItemStack(output.item)
		local resulting_count = result:get_count() * count

		-- Split the item into stacks
		local stack_max = result:get_stack_max()
		if resulting_count >= stack_max then
			local full_stack = ItemStack(result)
			full_stack:set_count(stack_max)
			for _ = 1, math.floor(resulting_count / stack_max) do
				add_item(player, inv, full_stack)
			end
			result:set_count(resulting_count % stack_max)
		else
			result:set_count(resulting_count)
		end

		if not result:is_empty() then
			add_item(player, inv, result)
		end
	end

	minetest.log("action", ("player %s crafts %dx %s"):format(
		player:get_player_name(), count, expected_item
	))
end
