mobs:register_mob("mobs_water:shark", {
    type = "monster",
    hp_min = 30,
    hp_max = 40,
    armor = 100,
    damage = 3,
    collisionbox = {-0.5, -0.3, -0.5, 0.5, 0.3, 0.5},
    visual = "mesh",
    mesh = "mobs_water_shark.b3d",
    textures = {"mobs_water_shark.png"},
    drops = {
        {name = "default:diamond", chance = 2},
        {name = "mobs:meat_raw", chance = 1},
    },
    stepheight = 0,
    walk_velocity = 2,
    run_velocity = 4,
    fly = true,
    fly_in = mobs_water.nodes,
    fall_speed = -5,
    view_range = 10,
    fear_height = 5,
    water_damage = 0,
    lava_damage = 10,
    animation = {
        speed_normal = 20,
        speed_run = 40,
        stand_start = 1,
        stand_end = 59,
        walk_start = 1,
        walk_end = 59,
        run_start = 1,
        run_end = 59,
        punch_start = 1,
        punch_end = 1,
    }
})

mobs:spawn({
    name = "mobs_water:shark",
    nodes = mobs_water.source_nodes,
    neighbors = mobs_water.source_nodes,
    chance = 20000,
    max_height = -8,
})

mobs:register_egg("mobs_water:shark", mobs_water.S"Shark Egg", "mobs_water_shark_egg.png")
