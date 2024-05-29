local mp = require 'mp'
local auto = require 'modules.translators.encodings.auto'
local getos = require 'getos'
local tlib = require 'tablelib'

local normalize = function (data)
	return string.sub(data, 0, #data - 2)
end

local windowsInkove = function (commonArgs, value)
	-- Removing '--' due to stupid crow CLI
	-- Passing value as stdin_data not work on windows
	local escaped = value:gsub('--', '')

	table.insert(commonArgs, escaped)

	local result = mp.command_native({
		name = 'subprocess',
		args = commonArgs,
		capture_stdout = true,
	})

	return result
end

local linuxInvoke = function (commonArgs, value)
	table.insert(commonArgs, '-i')

	local result = mp.command_native({
		name = 'subprocess',
		args = commonArgs,
		capture_stdout = true,
		stdin_data = value,
	})

	return result
end

local postprocess = function (data)
	local text = normalize(data):gsub('\\ N', '\\N')
	return text
end

local invoke = windowsInkove

local os = getos():lower()
if os:lower() == 'linux' then
	normalize = function (data) return data end
	invoke = linuxInvoke
end

---@param from string
---@param to string
return function (from, to)
	local m = {}
	local codepage = auto(to)

	---@param value string
	---@return string | nil
	function m.translate(value)
		local commonArgs = {
			'crow',
			'-l', from,
			'-t', to,
			'-b'
		}

		local result = invoke(commonArgs, value)

		if result.status ~= 0 then error(result) end

		local data = codepage.to_utf8(result.stdout)

		if data == nil then
			mp.msg.warn('[crow] Got empty response ' .. tlib.join(commonArgs, ' '))
			return nil
		end

		return postprocess(data)
	end

	function m.get_error(err)
		if err.status ~= nil and err.status == -3 then
			return 'crow not reachable in path'
		else
			return utils.format_json(err)
		end
	end

	return m
end
