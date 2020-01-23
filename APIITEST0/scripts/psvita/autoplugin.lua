--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function plugins_installation(sel)

	if plugins[sel].path == "reF00D.skprx" and loc == __UX0 then os.message(LANGUAGE["INSTALLP_WARNING_REFOOD"])
	elseif plugins[sel].path == "custom_warning.suprx" and ( version == "3.67" or version == "3.68") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	else

		if files.exists(tai[loc].path) then

			local install = true

			--Checking plugin Batt (only 1 of them)
			if plugins[sel].path == "shellbat.suprx" then
				local idx = tai.find(loc, "main", "shellsecbat.suprx")
				if idx then
					if os.message(LANGUAGE["INSTALLP_QUESTION_SHELLSECBAT"],1) == 1 then
						tai.del(loc, "main", "shellsecbat.suprx")
					else
						install = false
					end
				end
			elseif plugins[sel].path == "shellsecbat.suprx" then
				local idx = tai.find(loc, "main", "shellbat.suprx")
				if idx then
					if os.message(LANGUAGE["INSTALLP_QUESTION_SHELLBAT"],1) == 1 then
						tai.del(loc, "main", "shellbat.suprx")
					else
						install = false
					end
				end
			elseif plugins[sel].path == "vitastick.skprx" and not game.exists("VITASTICK") then
				game.install("resources/plugins/vitastick.vpk")
			elseif plugins[sel].path == "ModalVol.suprx" and not game.exists("MODALVOLM") then
				game.install("resources/plugins/VolumeControl.vpk")
			end

			if install then

				--Install plugin to tai folder
				files.copy(path_plugins..plugins[sel].path, path_tai)

				--Install Extra Plugin
				if plugins[sel].path2 then files.copy(path_plugins..plugins[sel].path2, path_tai) end

				--Install Especial Config for the plugin
				if plugins[sel].config then
					if plugins[sel].config == "custom_warning.txt" then
					
						if not files.exists(locations[loc].."tai/"..plugins[sel].config) then
							local text = osk.init(LANGUAGE["INSTALLP_OSK_TITLE"], LANGUAGE["INSTALLP_OSK_TEXT"])
							if not text or (string.len(text)<=0) then text = "" end--os.nick() end

							local fp = io.open(locations[loc].."tai/"..plugins[sel].config, "wb")
							if fp then
								fp:write(string.char(0xFF)..string.char(0xFE))
								fp:write(os.toucs2(text))
								fp:close()
							end
						end
					else
						if plugins[sel].configpath then
							files.copy(path_plugins..plugins[sel].config, plugins[sel].configpath)
						else
							files.copy(path_plugins..plugins[sel].config, locations[loc].."tai/")
						end
					end
				end

				--Insert plugin to Config
				local pathline_in_config = path_tai..plugins[sel].path

				if plugins[sel].path == "adrenaline_kernel.skprx" then pathline_in_config = "ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx" end

				local idx = nil

				if plugins[sel].section2 then
					idx = tai.find(loc, plugins[sel].section2, path_tai..plugins[sel].path2)
					if idx then tai.del(loc, plugins[sel].section2, path_tai..plugins[sel].path2) end
					tai.put(loc, plugins[sel].section2, path_tai..plugins[sel].path2)
				end

				idx = tai.find(loc, plugins[sel].section, pathline_in_config)
				if idx then tai.del(loc, plugins[sel].section,  pathline_in_config) end

				tai.put(loc, plugins[sel].section,  pathline_in_config)

				--Write
				tai.sync(loc)

				--Extra
				if plugins[sel].path == "vsh.suprx" then files.delete("ur0:/data:/vsh/")
				elseif plugins[sel].path == "custom_boot_splash.skprx" and not files.exists("ur0:tai/boot_splash.bin") then--Custom Boot Splash
					local henkaku = image.load("resources/boot_splash.png")
					if henkaku then img2splashbin(henkaku,false) end
				elseif plugins[sel].path == "vitacheat.skprx" or plugins[sel].path == "vitacheat360.skprx" then--Vitacheat
					if not files.exists("ux0:vitacheat/db/") then files.extract("resources/plugins/vitacheat.zip","ux0:") end
				elseif plugins[sel].path == "AutoBoot.suprx" and not files.exists("ux0:data/AutoBoot/") then--AutoBoot
					files.extract("resources/plugins/AutoBoot.zip","ux0:")
			    elseif plugins[sel].path == "ps4linkcontrols.suprx" and not files.exists("ux0:ps4linkcontrols.txt") then--ps4linkcontrols
					files.extract("resources/plugins/ps4linkcontrols.zip","ux0:")
				end

				if back2 then back2:blit(0,0) end
					message_wait(plugins[sel].name.."\n\n"..LANGUAGE["STRING_INSTALLED"])
				os.delay(1500)

				change = true
				buttons.homepopup(0)

			end

		else
			os.message(LANGUAGE["STRING_MISSING_CONFIG"])
		end
	end

end


function autoplugin()

	--os.message(tostring(#tai[partition].gameid[ section[sel_section] ].prx))
	--tai[mount].gameid[ obj1 ].prx[idx].path
	--Init load configs
	tai.load()
	local partition = 0
	if tai[__UX0].exist then partition = __UX0
	elseif tai[__UR0].exist then partition = __UR0
	end


	local limit = 10
	local scr = newScroll(plugins,limit)
	local xscr1,toinstall = 10,0
	scr.ini,scr.lim,scr.sel = 1,limit,1

	--Init load configs
	loc = 1
	tai.load()
	if tai[__UR0].exist then loc = 2 end
	path_tai = locations[loc].."tai/"

	while true do
		buttons.read()
		if back2 then back2:blit(0,0) end

		screen.print(10,15,LANGUAGE["LIST_PLUGINS"].."  "..toinstall.."/"..#plugins,1,color.white)

		--Partitions
		local xRoot = 750
		local w = (960-xRoot)/#locations
		for i=1, #locations do
			if loc == i then
				draw.fillrect(xRoot,0,w,47, color.green:a(90))
			end
			screen.print(xRoot+(w/2), 12, locations[i], 1, color.white, color.blue, __ACENTER)
			xRoot += w
		end

		--List of Plugins
		local y = 64
		for i=scr.ini,scr.lim do

			if i == scr.sel then draw.offsetgradrect(3,y-5,944,27,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			local idx = tai.find(partition,plugins[i].section,plugins[i].path)
			if idx != nil then
				draw.fillrect(920,y-5,28,27,color.shine:a(75))
				if files.exists(tai[partition].gameid[ plugins[i].section ].prx[idx].path) then
					draw.fillrect(924,y-2,21,21,color.green:a(175))
				else
					draw.fillrect(924,y-2,21,21,color.yellow:a(175))
				end
			end
			screen.print(40,y, plugins[i].name, 1.0,color.white,color.blue,__ALEFT)

			if plugins[i].inst then
				screen.print(5,y," >> ",1,color.white,color.green)
			end

			y+=32
		end

		---- Draw Scroll Bar
		local ybar,hbar = 60, (limit*32)
		draw.fillrect(950,ybar-2,8,hbar,color.shine)
		--if scr.maxim >= limit then
			local pos_height = math.max(hbar/scr.maxim, limit)
			--Bar Scroll
			draw.fillrect(950, ybar-2 + ((hbar-pos_height)/(scr.maxim-1))*(scr.sel-1), 8, pos_height, color.new(0,255,0))
		--end

		if screen.textwidth(plugins[scr.sel].desc) > 925 then
			xscr1 = screen.print(xscr1, 405, plugins[scr.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 405, plugins[scr.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		if tai[__UX0].exist and tai[__UR0].exist then
			if buttonskey2 then buttonskey2:blitsprite(900,448,2) end
			if buttonskey2 then buttonskey2:blitsprite(930,448,3) end
			screen.print(895,450,LANGUAGE["LR_SWAP"],1,color.white,color.black,__ARIGHT)
		end

		if buttonskey then buttonskey:blitsprite(10,448,__SQUARE) end
		screen.print(45,450,LANGUAGE["MARK_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(5,472,0) end
		screen.print(45,475,LANGUAGE["CLEAN_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,498,__TRIANGLE) end
		screen.print(45,500,LANGUAGE["PLUGINS_CUSTOM_PATH"]..": "..path_tai,1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.released.cancel then
			--Clean
			for i=1,scr.maxim do
				plugins[i].inst = false
				toinstall = 0
			end
			os.delay(100)
			return
		end

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

		if scr.maxim > 0 then

			if buttons.up or buttons.analogly < -60 then
				if scr:up() then xscr1 = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scr:down() then xscr1 = 10 end
			end

			if buttons.released.l or buttons.released.r then
				if tai[__UX0].exist and tai[__UR0].exist then
					if loc == __UX0 then loc = __UR0 else loc = __UX0 end
				end
			end

			--Install selected plugins
			if buttons.accept then

				if back2 then back2:blit(0,0) end
				message_wait()
				os.delay(1000)

				if toinstall <= 1 then
					plugins_installation(scr.sel)
				else
					for i=1, scr.maxim do
						if plugins[i].inst then
							plugins_installation(i)
						end
					end
					os.delay(50)
				end

				for i=1,scr.maxim do
					plugins[i].inst = false
					toinstall = 0
				end

			end

			--Mark/Unmark
			if buttons.square then
				plugins[scr.sel].inst = not plugins[scr.sel].inst
				if plugins[scr.sel].inst then toinstall+=1 else toinstall-=1 end
			end

			--Clean selected
			if buttons.select then
				for i=1,scr.maxim do
					plugins[i].inst = false
					toinstall = 0
				end
			end

			--Customize install path for plugins
			if buttons.triangle then
				if folder_tai then
					folder_tai = false
					path_tai = locations[loc].."tai/"
				else
					folder_tai = true
					path_tai = locations[loc].."tai/plugins/"
				end
			end
		end
	end

end
