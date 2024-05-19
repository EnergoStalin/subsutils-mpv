local mp = require 'mp'
local utils = require 'mp.utils'
local tablelib = require 'tablelib'

local debug = mp.get_opt('sub-translator-debug') ~= nil

return function (register, unregister, options)
	return function ()
		if debug then
			register()
			return
		end

		local tracks = mp.get_property_native('track-list', {})
		mp.msg.trace('[autoEnable] tracks', utils.format_json(tracks))
		local subs = tablelib.filter(tracks, function (track)
			return track.type == 'sub'
		end)
		if #tablelib.filter(subs, function (track)
				return (track.lang ~= nil and track.lang:find(options.toLang)) or track.external
			end) == 0 and #subs ~= 0 then
			register()
		else
			unregister()
		end
	end
end
