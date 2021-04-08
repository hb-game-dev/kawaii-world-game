
laptop.register_app("launcher", {
	app_name = "Main launcher",
	app_info = "Desktop Enviroment",
	fullscreen = true,
	os_min_version = '5.00',
	formspec_func = function(launcher_app, mtos)
		local c_row_count = 4

		local i = 0
		local out = "size[15,10]"
		if mtos.theme.desktop_background then
			out = out..'background[15,10;0,0;'..mtos.theme.desktop_background..';true]'
		end
		local appslist_sorted = {}
		for name, def in pairs(laptop.apps) do
			if def.app_name and not def.view and def.name ~= launcher_app.name and mtos:is_app_compatible(name)then
				table.insert(appslist_sorted, {name = name, def = def})
			end
		end
		table.sort(appslist_sorted, function(a,b) return a.name < b.name end)
		for i, e in ipairs(appslist_sorted) do
			local x = math.floor((i-1) / c_row_count)*2 + 1
			local y = ((i-1) % c_row_count)*2 + 1
			out = out .. mtos.theme:get_image_button(x..','..y..';1,1', 'desktop_icon', e.name, mtos.theme:get_texture(e.def.app_icon or 'logo.png'), "", (e.def.app_info or e.name))..
			mtos.theme:get_button((x-0.75)..','..(y+1.08)..';2.5,.5', 'desktop_icon_label', e.name, e.def.app_name)
		end
		out = out..mtos.theme:get_button(mtos.theme.taskbar_clock_position_and_size, "major", "os_clock", os.date("%c"))
		out = out..mtos.theme:get_button('14.2,-0.31;1.09,0.8', 'exit', 'close_window', mtos.theme.exit_character, 'Power Off')
		return out
	end,
	appwindow_formspec_func = function(launcher_app, app, mtos)
		local formspec = 'size[15,10]'
		if mtos.theme.app_background then
			formspec = formspec..'background[0,0;15,10;'..mtos.theme.app_background..';true]'
		end
		if #mtos.sysram.stack > 0 then
			formspec = formspec..mtos.theme:get_button('-0.29,-0.31;1.09,0.61', 'back', 'os_back', '<', 'Return to previous screen')
		end
		if app.app_info then
			if #mtos.sysram.stack > 0 then
				formspec = formspec..mtos.theme:get_label("0.8,-0.29", app.app_info, "titlebar")
			else
				formspec = formspec..mtos.theme:get_label("-0.1,-0.29", app.app_info, "titlebar")
			end
		end
		formspec = formspec..mtos.theme:get_button('14.2,-0.31;1.09,0.61', 'exit', 'os_exit', mtos.theme.exit_character, 'Exit app')
		return formspec
	end,
	receive_fields_func = function(launcher_app, mtos, sender, fields)
		for name, descr in pairs(fields) do
			if laptop.apps[name] then
				mtos:set_app(name)
				break
			end
		end
	end,
})

