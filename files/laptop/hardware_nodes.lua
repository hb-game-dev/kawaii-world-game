local rc = laptop.recipe_compat -- Recipe items from other mods

laptop.register_hardware("laptop:core", {
	description = "CP Core",
	infotext = 'CP Core',
	sequence = { "closed", "open", "open_on" },
	custom_theme = "Red",
	hw_capabilities = { 'hdd', 'usb', 'net' },
	node_defs = {
		["open"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_lap_car_open_top.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_bottom.png",
				"laptop_lap_car_open_right.png",
				"laptop_lap_car_open_left.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_open_back.png",
				"laptop_lap_car_open_front.png^laptop_lap_car_sc_open_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				}
			}
		},
		["open_on"] = {
			hw_state = "resume",
			light_source = 4,
			tiles = {
				"laptop_lap_car_open_on_top.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_bottom.png",
				"laptop_lap_car_open_right.png",
				"laptop_lap_car_open_left.png",
				"laptop_lap_car_sc_open_bottom.png^laptop_lap_car_open_back.png",
				"laptop_lap_car_open_front.png^laptop_lap_car_sc_open_on_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				  }
			       }
			    },
		["closed"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_lap_car_closed_top.png",
				"laptop_lap_car_bottom.png",
				"laptop_lap_car_closed_right.png",
				"laptop_lap_car_closed_left.png",
				"laptop_lap_car_closed_back.png",
				"laptop_lap_car_closed_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.375}, -- base_closed
				}
			}
		}
	}
})

minetest.register_craft({
	output = 'laptop:core_closed',
	recipe = {
	{'dye:red', rc.glass, 'dye:red', },
	{rc.tin, rc.ic, rc.copper, },
	{rc.plastic, rc.energy_crystal_simple, rc.plastic, },
	}
})

laptop.register_hardware("laptop:cube", {
	description = "CUBE PC",
	infotext = "CUBE PC",
	os_version = '5.02',
	sequence = { "off", "on"},
	hw_capabilities = { "hdd", "floppy", "net", "liveboot" },
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"laptop_cube_monitor_top.png^laptop_cube_tower_top.png",
				"laptop_cube_monitor_bottom.png^laptop_cube_tower_bottom.png",
				"laptop_cube_monitor_right.png^laptop_cube_tower_right.png",
				"laptop_cube_monitor_left.png^laptop_cube_tower_left.png",
				"laptop_cube_monitor_back.png^laptop_cube_tower_back.png",
				"laptop_cube_monitor_front_on.png^laptop_cube_tower_front_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
					type = "fixed",
					fixed = {
					{-0.5, -0.5, -0.1875, 0.5, -0.1875, 0.5}, -- cube tower
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- cube keyboard
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- cube mouse
					{-0.3125, -0.5, -0.125, 0.3125, 0.5, 0.4375}, -- cube monitor
				}
			},
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_cube_monitor_top.png^laptop_cube_tower_top.png",
				"laptop_cube_monitor_bottom.png^laptop_cube_tower_bottom.png",
				"laptop_cube_monitor_right.png^laptop_cube_tower_right.png",
				"laptop_cube_monitor_left.png^laptop_cube_tower_left.png",
				"laptop_cube_monitor_back.png^laptop_cube_tower_back.png",
				"laptop_cube_monitor_front.png^laptop_cube_tower_front.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
					type = "fixed",
					fixed = {
					{-0.5, -0.5, -0.1875, 0.5, -0.1875, 0.5}, -- cube tower
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- cube keyboard
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- cube mouse
					{-0.3125, -0.5, -0.125, 0.3125, 0.5, 0.4375}, -- cube monitor
				}
			}
		}
	}
})

minetest.register_craft({
	output = 'laptop:cube_off',
	recipe = {
	{rc.steel, rc.silicon, rc.steel, },
	{rc.glass, rc.ic, '', },
	{rc.plastic, rc.energy_crystal_simple, rc.plastic, },
	}
})

laptop.register_hardware("laptop:fruit_zero", {
	description = "Fruit Zero",
	infotext = "Fruit Zero",
	sequence = { "off", "on"},
	custom_theme = "Magma",
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"laptop_fruit_stand_top.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_lcd_back.png",
				"laptop_lcd_fruit_on.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.125, 0.5, -0.4375, 0.375}, -- NodeBox1
					{-0.0625, -0.4375, 0.125, 0.0625, 0.0625, 0.25}, -- NodeBox2
					{-0.5, -0.1875, 0, 0.5, 0.5, 0.125}, -- NodeBox3
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- NodeBox4
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- NodeBox5
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_fruit_stand_top.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_base.png",
				"laptop_fruit_lcd_back.png",
				"laptop_lcd_fruit.png"
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5, -0.5, -0.125, 0.5, -0.4375, 0.375}, -- NodeBox1
					{-0.0625, -0.4375, 0.125, 0.0625, 0.0625, 0.25}, -- NodeBox2
					{-0.5, -0.1875, 0, 0.5, 0.5, 0.125}, -- NodeBox3
					{-0.5, -0.5, -0.5, 0.1875, -0.4375, -0.25}, -- NodeBox4
					{0.25, -0.5, -0.5, 0.4375, -0.4375, -0.25}, -- NodeBox5
				}
			}
		}
	}
})

minetest.register_craft({
	output = 'laptop:fruit_zero_off',
	recipe = {
	{'dye:white', rc.plastic, 'dye:white', },
	{rc.silicon, rc.ic, rc.glass, },
	{rc.copper, rc.energy_crystal_simple, rc.steel, },
	}
})

laptop.register_hardware("laptop:bell_crossover", {
	description = "Bell CrossOver",
	infotext = "Bell CrossOver",
	os_version = "6.33",
	sequence = { "off", "on"},
	node_defs = {
		["on"] = {
			hw_state = "power_on",
			light_source = 4,
			tiles = {
				"laptop_opti_pc_top.png^laptop_opti_kb_top.png^laptop_opti_ms_top.png^laptop_opti_lcb_top.png^laptop_opti_lcp_top.png^laptop_opti_lcd_top.png",
				"laptop_opti_pc_bottom.png^laptop_opti_kb_bottom.png^laptop_opti_ms_bottom.png^laptop_opti_lcd_bottom.png",
				"laptop_opti_pc_right.png^laptop_opti_kb_right.png^laptop_opti_ms_right.png^laptop_opti_lcb_right.png^laptop_opti_lcp_right.png^laptop_opti_lcd_right.png",
				"laptop_opti_pc_left.png^laptop_opti_kb_left.png^laptop_opti_ms_left.png^laptop_opti_lcb_left.png^laptop_opti_lcp_left.png^laptop_opti_lcd_left.png",
				"laptop_opti_pc_back.png^laptop_opti_kb_back.png^laptop_opti_ms_back.png^laptop_opti_lcb_back.png^laptop_opti_lcp_back.png^laptop_opti_lcd_back.png",
				"laptop_opti_pc_on_front.png^laptop_opti_kb_front.png^laptop_opti_ms_front.png^laptop_opti_lcb_front.png^laptop_opti_lcp_front.png^laptop_opti_lcd_on_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.0625, 0.375, -0.3125, 0.4375}, -- tower
					{-0.4375, -0.5, -0.4375, 0.25, -0.4375, -0.1875}, -- keboard
					{0.3125, -0.5, -0.375, 0.4375, -0.4375, -0.1875}, -- mouse
					{-0.25, -0.3125, 0.0625, 0.25, -0.25, 0.3125}, -- lcd_base
					{-0.0625, -0.25, 0.1875, 0.0625, 0.0625, 0.25}, -- lcd_pedestal
					{-0.4375, -0.125, 0.125, 0.4375, 0.4375, 0.1875}, -- lcd_main
				}
			}
		},
		["off"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_opti_pc_top.png^laptop_opti_kb_top.png^laptop_opti_ms_top.png^laptop_opti_lcb_top.png^laptop_opti_lcp_top.png^laptop_opti_lcd_top.png",
				"laptop_opti_pc_bottom.png^laptop_opti_kb_bottom.png^laptop_opti_ms_bottom.png^laptop_opti_lcd_bottom.png",
				"laptop_opti_pc_right.png^laptop_opti_kb_right.png^laptop_opti_ms_right.png^laptop_opti_lcb_right.png^laptop_opti_lcp_right.png^laptop_opti_lcd_right.png",
				"laptop_opti_pc_left.png^laptop_opti_kb_left.png^laptop_opti_ms_left.png^laptop_opti_lcb_left.png^laptop_opti_lcp_left.png^laptop_opti_lcd_left.png",
				"laptop_opti_pc_back.png^laptop_opti_kb_back.png^laptop_opti_ms_back.png^laptop_opti_lcb_back.png^laptop_opti_lcp_back.png^laptop_opti_lcd_back.png",
				"laptop_opti_pc_front.png^laptop_opti_kb_front.png^laptop_opti_ms_front.png^laptop_opti_lcb_front.png^laptop_opti_lcp_front.png^laptop_opti_lcd_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.375, -0.5, -0.0625, 0.375, -0.3125, 0.4375}, -- tower
					{-0.4375, -0.5, -0.4375, 0.25, -0.4375, -0.1875}, -- keboard
					{0.3125, -0.5, -0.375, 0.4375, -0.4375, -0.1875}, -- mouse
					{-0.25, -0.3125, 0.0625, 0.25, -0.25, 0.3125}, -- lcd_base
					{-0.0625, -0.25, 0.1875, 0.0625, 0.0625, 0.25}, -- lcd_pedestal
					{-0.4375, -0.125, 0.125, 0.4375, 0.4375, 0.1875}, -- lcd_main
				}
			}
		}
	}
})

minetest.register_craft({
	output = 'laptop:bell_crossover_off',
	recipe = {
	{'dye:dark_grey', rc.glass, rc.tin, },
	{rc.gold, rc.ic, rc.diamond, },
	{rc.plastic, rc.energy_crystal_simple, rc.silicon, },
	}
})

-- Portable Workstation
laptop.register_hardware("laptop:portable_workstation_2", {
	description = "Portable Workstation 2",
	infotext = "Portable Workstation 2",
	os_version = "5.02",
	custom_theme = "Freedom",
	sequence = { "closed", "open", "open_on"},
	node_defs = {
		["closed"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_lap_base_closed_top.png",
				"laptop_lap_base_closed_bottom.png",
				"laptop_lap_base_closed_right.png",
				"laptop_lap_base_closed_left.png",
				"laptop_lap_base_closed_back.png",
				"laptop_lap_base_closed_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.375, 0.375}, -- base_closed
				}
			}
		},
		["open"] = {
			hw_state = "power_off",
			tiles = {
				"laptop_lap_base_open_top.png",
				"laptop_lap_base_open_bottom.png^laptop_lap_sc_open_bottom.png",
				"laptop_lap_base_open_right.png",
				"laptop_lap_base_open_left.png",
				"laptop_lap_base_open_back.png^laptop_lap_sc_open_back.png",
				"laptop_lap_base_open_front.png^laptop_lap_sc_open_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				}
			}
		},
		["open_on"] = {
			hw_state = "resume",
			light_source = 4,
			tiles = {
				"laptop_lap_base_open_on_top.png",
				"laptop_lap_base_open_bottom.png^laptop_lap_sc_open_bottom.png",
				"laptop_lap_base_open_right.png",
				"laptop_lap_base_open_left.png",
				"laptop_lap_base_open_back.png^laptop_lap_sc_open_back.png",
				"laptop_lap_base_open_front.png^laptop_lap_sc_open_on_front.png",
			},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.375}, -- base_open
					{-0.4375, -0.4375, 0.375, 0.4375, 0.3125, 0.4375}, -- sc_open
				}
			}
		}
	}
})

minetest.register_craft({
	output = 'laptop:portable_workstation_2_closed',
	recipe = {
	{'dye:dark_grey', rc.glass, 'dye:dark_grey', },
	{rc.plastic, rc.ic, rc.silicon, },
	{rc.energy_crystal_simple, rc.steel, 'dye:dark_grey', },
	}
})

-- Conversion from older laptop version, before 2018-03
minetest.register_alias("laptop:monitor2_off", "laptop:fruit_zero_off")
minetest.register_alias("laptop:monitor2_on", "laptop:fruit_zero_on")

minetest.register_alias("laptop:monitor4_off", "laptop:bell_crossover_off")
minetest.register_alias("laptop:monitor4_on", "laptop:bell_crossover_on")

minetest.register_alias("laptop:laptop_closed", "laptop:portable_workstation_2_closed")
minetest.register_alias("laptop:laptop_open", "laptop:portable_workstation_2_open")
minetest.register_alias("laptop:laptop_open_on", "laptop:portable_workstation_2_open_on")
