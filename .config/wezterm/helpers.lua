local DEFAULT_BRIGHTNESS = 0.002

local M = {}

-- macbook's colors are too bright man
M.get_background_brightness = function()
	local cmd = io.popen("uname")
	if cmd == nil then
		return DEFAULT_BRIGHTNESS
	end
	local result = cmd:read("*a")

	if string.lower(result) == "darwin" then
		return 0.02
	end

	return DEFAULT_BRIGHTNESS
end

return M
