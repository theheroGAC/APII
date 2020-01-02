--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function write_config()
	ini.write(__PATH_INI,"UPDATE","update",__UPDATE)
	ini.write(__PATH_INI,"LANGUAGE","lang",__LANG)
end

function draw.offsetgradrect(x,y,sx,sy,c1,c2,c3,c4,offset)
	local sizey = sy/2
		draw.gradrect(x,y,sx,sizey + offset,c1,c2,c3,c4)
			draw.gradrect(x,y + sizey - offset,sx,sizey + offset,c3,c4,c1,c2)
end

function message_wait(message)
	local mge = (message or LANGUAGE["STRING_PLEASE_WAIT"])
	local titlew = string.format(mge)
	local w,h = screen.textwidth(titlew,1) + 30,70
	local x,y = 480 - (w/2), 272 - (h/2)

	draw.fillrect(x,y,w,h, color.shine)
	draw.rect(x,y,w,h,color.white)
		screen.print(480,y+15, titlew,1,color.white,color.black,__ACENTER)
	screen.flip()
end

function check_online()
	local file = http.get("https://raw.githubusercontent.com/theheroGAC/Autoplugin/master/version")

	if file then return true else return false end
end

--Variables Universales
path_plugins = "resources/plugins/"
__UX0, __UR0, loc = 1,2,1
locations = { "ux0:", "ur0:" }
folder_tai, path_tai = false, locations[loc].."tai/"
version = tostring(os.swversion())

--Buttons Assign
__TRIANGLE,__SQUARE = 2,3
saccept,scancel = 1,0
if buttons.assign()==0 then
	saccept,scancel = 0,1
end

PMounts = {}
function check_mounts ()
	local partitions = { "ux0:", "ur0:", "uma0:", "imc0:", "xmc0:" }

	for i=1,#partitions do
		if files.exists(partitions[i]) then
			local device_info = os.devinfo(partitions[i])
			if device_info then
				table.insert(PMounts,partitions[i])
			end
		end
	end
end
check_mounts ()
