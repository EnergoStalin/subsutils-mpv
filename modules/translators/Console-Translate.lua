local mp = require 'mp'

local function escape(str)
	local s, _ = string.gsub(str, '\'', '\'\'')
	return s
end

---@param from string
---@param to string
return function (from, to)
	local m = {}

	---@param value string
	---@return string | nil
	function m.translate(value)
		local result = mp.command_native({
			name = 'subprocess',
			args = {
				'pwsh',
				'-NoProfile',
				'-NonInteractive',
				'-Command',
				string.format(
					'Import-Module Console-Translate; Get-Translate -Text \'%s\' -LanguageSource %s -LanguageTarget %s',
					escape(string.gsub(value, '[\r\n]', '\\n')),
					from,
					to
				),
			},
			capture_stdout = true,
		})

		local s, _ = string.gsub(result.stdout, '\\n', '\n')
		s, _ = string.gsub(s, '&quot;', '"')
		s, _ = string.gsub(s, '&amp;', '&')
		s, _ = string.gsub(s, '&#39;', '\'')
		s, _ = string.gsub(s, '\\%s', '\\')

		return s
	end

	function m.get_error(err)
		return err
	end

	return m
end
