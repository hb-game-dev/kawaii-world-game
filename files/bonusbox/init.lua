bonusbox = {}
-- Load files
local default_path = minetest.get_modpath("bonusbox")

dofile(default_path .. "/timer.lua")

-- Format of each item:
-- {item_name, minimum, maximum}

local items_ore = {
	{"mesecons:wire_00000000_off", 4, 16},
	{"default:steel_ingot", 1, 3},
	{"default:gold_ingot", 1, 3},
	{"default:tin_ingot", 1, 3},
	{"default:silver_ingot", 1, 3},
	{"default:copper_ingot", 1, 3}
}

local items_food = {
	{"default:apple", 2, 6},
	{"mobs:pork", 1, 3},
	{"mobs:meat", 1, 3},
	{"mobs:chicken_cooked", 1, 3},
	{"farming_addons:chocolate", 1, 2}
}

local items_material = {
	{"default:wood", 8, 32},
	{"default:cobble", 8, 64},
	{"default:obsidian", 2, 8},
	{"default:tree", 4, 16},
	{"tnt:tnt", 1, 2}
}

local items_jewel = {
    {"default:diamond", 3, 3},
    {"default:emerald", 2, 2},
    {"default:ruby", 3, 3}
}

local random = math.random
local t_player

local lang = core.settings:get("language")
if not (lang and (lang ~= "")) then lang = os.getenv("LANG") end

local m_pos
local m_node

local function get_rewarded_bg()
    local bg = "rewarded_window_bg_" .. lang ..".png"
    if bg == nil then
        bg = "rewarded_window_bg_en.png"
    end
    return bg
end
local function get_error_bg()
    local bg = "error_window_bg_" .. lang ..".png"
    if bg == nil then
        bg = "error_window_bg_en.png"
    end
    return bg
end
local function get_exit_btn_bg()
    local bg = "exit_btn_" .. lang ..".png"
    if bg == nil then
        bg = "exit_btn_en.png"
    end
    return bg
end
local function get_watch_btn_bg()
    local bg = "watch_btn_" .. lang ..".png"
    if bg == nil then
        bg = "watch_btn_en.png"
    end
    return bg
end

t1 = Timer(function()
           if(core:is_rewarded_shown()) then
               if(core:can_reward()) then
                    if t_player then
                        sfinv.set_page(t_player, sfinv.get_homepage_name(t_player))
                    else
                        sfinv.set_page(sfinv.get_homepage_name())
                    end
                    item_spawn(t_player)
               end
               t1:stop()
           end
    end
    , {
    interval = 1,
    repeats = true,
})

local function show_rewarded_ads()
    core:show_ads()
    t1:start()
end

function bonusbox.show_formspec(player)
    t_player = player
    local name = player:get_player_name()
    
    local formspec
    
    if core:can_show_rewarded_ads() then
        formspec =
            "size[8,4]" ..
            "background[0,0;0,0;" .. get_rewarded_bg() .. ";true]" ..
            "image_button_exit[7.65,-0.31;0.65,0.65;close.png;exit;;true;false]" ..
            "image_button_exit[2.5,3.2;3,1;" .. get_watch_btn_bg() .. ";show_rewarded;;true;false]"
    else
        formspec =
            "size[8,4]" ..
            "background[0,0;0,0;" .. get_error_bg() .. ";true]" ..
            "image_button_exit[2.5,3.35;3,1;" .. get_exit_btn_bg() .. ";exit;;true;false]"
    end
    
    minetest.show_formspec(name, "bonusbox:box", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "bonusbox:box" then
        if fields.show_rewarded then
            show_rewarded_ads()
            return
        end
    end
end)

function item_spawn(player)
	local item1 = items_food[random(#items_food)]
	item1 = item1[1] .. " " .. random(item1[2], item1[3])
	local item2 = items_ore[random(#items_ore)]
	item2 = item2[1] .. " " .. random(item2[2], item2[3])
	local item3 = items_material[random(#items_material)]
	item3 = item3[1] .. " " .. random(item3[2], item3[3])
    local item4 = items_jewel[random(#items_jewel)]
    item4 = item4[1] .. " " .. random(item4[2], item4[3])
    
	minetest.add_item(player:get_pos(), item1)
	minetest.add_item(player:get_pos(), item2)
	minetest.add_item(player:get_pos(), item3)
    minetest.add_item(player:get_pos(), item4)
end

minetest.register_alias("bonusbox:chest", "air")
minetest.register_alias("bonusbox:chest_open", "air")
minetest.register_alias("bonusbox:chest_cap", "air")
