mobs_animals = {}

local translator = minetest.get_translator
mobs_animals.S = translator and translator("mobs_animals") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		mobs_animals.S = intllib.make_gettext_pair()
	end
end

local path = minetest.get_modpath("mobs_animals")
local list = {
	"chicken", "cow",
	"fox", "panda"
}

for _, name in pairs(list) do
	dofile(path .. "/" .. name .. ".lua")
end
