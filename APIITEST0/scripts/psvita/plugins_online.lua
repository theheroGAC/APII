--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function update_database2(database,tb)

	buttons.homepopup(0)
	local file = io.open(database, "w+")

    file:write("plugins = {\n")

	for s,t in pairs(tb) do
		file:write("{ ")
			if type(t) == "table" then
				for k,v in pairs(t) do
					if k != "install" and k != "new" and k != "inst" then
						file:write(string.format(' %s = "%s",', tostring(k), tostring(v)))
					end
				end
		file:write("},\n")
			end
	end

	file:write("}\n")
	file:close()

	local cont = {}
	for line in io.lines(database) do
		if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
		table.insert(cont,line)
	end

	dofile("plugins/plugins.lua")--Official
	for i=1,#plugins do
		for j=2, #cont do
			if string.find(cont[j], plugins[i].KEY, 1, true) then
				cont[j] = cont[j]:gsub('desc = "(.-)",', 'desc = LANGUAGE["'..plugins[i].KEY..'"],')
			end
		end
	end
	local file = io.open("plugins/plugins.lua", "w+")
	for s,t in pairs(cont) do
		file:write(string.format('%s\n', tostring(t)))
	end
	file:close()
	dofile("plugins/plugins.lua")--Official
	if #plugins > 0 then table.sort(plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
	buttons.homepopup(1)
end

function plugins_online2()

	local tmpss = {}

	if http.getfile(string.format("https://raw.githubusercontent.com/%s/%s/Plugins/plugins.lua", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/plugins/plugins.lua") then
		dofile("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"])
		return
	end

	local __flag = false
	if #Online_Plugins > 0 then

		for i=1,#plugins do

			plugins[i].install = true

			for j=1,#Online_Plugins do
				if string.upper(plugins[i].KEY) == string.upper(Online_Plugins[j].KEY) then

					if tonumber(plugins[i].version) < tonumber(Online_Plugins[j].version) then

						--if os.message("bajar si o no ?\n"..Online_Plugins[j].name,1) == 1 then
						if (http.getfile(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/%s", APP_REPO, APP_PROJECT, Online_Plugins[j].path), path_plugins)) then
							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_Plugins[j].name)
							os.delay(750)

							plugins[i] = Online_Plugins[j]
							table.insert(tmpss,plugins[i])
							__flag = true
						end

					end
				end
			end

		end
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"])
		return

	end--Online_Plugins>0

	local tmps = {}
	for i=1,#Online_Plugins do
		local _find = false
		for j=1,#plugins do
			if string.upper(Online_Plugins[i].KEY) == string.upper(plugins[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then
			--if os.message("bajar si o no ?\n"..Online_Plugins[i].name,1) == 1 then
			if (http.getfile(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/%s", APP_REPO, APP_PROJECT, Online_Plugins[i].path), path_plugins)) then
				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_Plugins[i].name)
				os.delay(750)
				table.insert(tmps, { line = i })
				__flag = true
			end
		end

	end

	for i=1,#tmps do
		table.insert( plugins, Online_Plugins[tmps[i].line] )
		plugins[#plugins].new = true
		plugins[#plugins].install = true
		table.insert(tmpss,plugins[#plugins])
	end

	if __flag then
		if #plugins > 1 then table.sort(plugins ,function (a,b) return string.lower(a.section)<string.lower(b.section) end) end
		update_database2("plugins/plugins.lua",plugins)
	end

	local maxim,y1 = 10,85
	local scroll = newScroll(tmpss,maxim)
	table.sort(tmpss ,function (a,b) return string.lower(a.name)<string.lower(b.name) end)

	while true do
		buttons.read()

		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_TITLE_PLUGINS_ONLINE"],1.2,color.white,0x0,__ACENTER)

		if scroll.maxim > 0 then

			local y = y1
			for i=scroll.ini,scroll.lim do

				if i == scroll.sel then draw.offsetgradrect(17,y-12,938,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

				screen.print(30,y, tmpss[i].name, 1.0, color.white,0x0)
				if tmpss[i].new then
					screen.print(945,y,LANGUAGE["LANG_FILE_NEW"],1.0,color.green,0x0,__ARIGHT)
				else
					screen.print(945,y,LANGUAGE["LANG_FILE_UPDATE"],1.0,color.green,0x0,__ARIGHT)
				end

				y+= 40

			end--for

			--Bar Scroll
			local ybar, h = y1-8, (maxim*40)-3
			if scroll.maxim >= maxim then -- Draw Scroll Bar
				draw.fillrect(3, ybar-3, 8, h, color.shine)
				local pos_height = math.max(h/scroll.maxim, maxim)
				draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
			end

		else
			screen.print(480,230, LANGUAGE["PLUGINS_NO_ONLINE"], 1, color.white, color.red, __ACENTER)
		end

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--Exit
		if buttons.start then
			if change then
				os.message(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(250)
				buttons.homepopup(1)
				power.restart()
			end
			os.exit()
		end

		--Ctrls
		if scroll.maxim > 0 then

			if buttons.up or buttons.analogly < -60 then scroll:up() end
			if buttons.down or buttons.analogly > 60 then scroll:down()	end

		end

		if buttons.cancel then break end
	
	end--while

	
end
