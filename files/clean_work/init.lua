local old_nodes = {}
local old_entities = {
"mobs_horse:horse_brown", 
"mobs_horse:horse_black", 
"mobs_horse:horse_white", 
"mobs_horse:horse", 
"mobs_horse:deer",
"mobs_animal:bear",
"mobs_animals:bear",
"mobs_animals:bear_brown",
"mobs_animals:bear_polar",
"mobs_animals:parrot",
"mobs_animal:parrot",
"mobs_animals:turtle",
"mobs_animals:tutrle",
"mobs_animals:turtle_egg",
"mobs_npc:npc_man",
"mobs_npc:npc_woman",
"mobs_npc:trader",
"mobs_water:fish_small",
"mobs_water:fish_medium",
"mobs_water:seafury",
"mobs_water:squid"
}

for _,node_name in ipairs(old_nodes) do
    minetest.register_node(":"..node_name, {
        groups = {old=1},
    })
end

minetest.register_abm({
    nodenames = {"group:old"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        minetest.env:remove_node(pos)
    end,
})

for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end