-- ========================================================================== --
-- MINIMAL PER-PROJECT TIME TRACKER (no API key, no external service)
-- ========================================================================== --
-- Heartbeats accumulate active seconds per project into a local JSON file.
-- Gaps longer than IDLE_SECONDS (away from the keyboard) are not counted.

local M = {}

local IDLE_SECONDS = 120
local DATA_FILE = vim.fn.stdpath("data") .. "/timetracker.json"

local data = {}
local last_time
local last_project

local function load()
	local f = io.open(DATA_FILE, "r")
	if not f then
		return
	end
	local ok, decoded = pcall(vim.json.decode, f:read("*a"))
	f:close()
	if ok and type(decoded) == "table" then
		data = decoded
	end
end

local function save()
	local f = io.open(DATA_FILE, "w")
	if not f then
		return
	end
	f:write(vim.json.encode(data))
	f:close()
end

local function project()
	local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
	return vim.fs.basename(root)
end

local function heartbeat()
	local now = os.time()
	local proj = project()
	if last_time and last_project == proj and (now - last_time) < IDLE_SECONDS then
		data[proj] = (data[proj] or 0) + (now - last_time)
	end
	last_time = now
	last_project = proj
end

local function format(seconds)
	return string.format("%dh %dm", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60))
end

function M.setup()
	load()

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertEnter", "BufEnter", "FocusGained" }, {
		desc = "Time tracker heartbeat",
		group = vim.api.nvim_create_augroup("timetracker-heartbeat", { clear = true }),
		callback = heartbeat,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		desc = "Time tracker save",
		group = vim.api.nvim_create_augroup("timetracker-save", { clear = true }),
		callback = function()
			heartbeat()
			save()
		end,
	})

	vim.api.nvim_create_user_command("TimeTracker", function()
		local lines = { "Time tracked per project:" }
		local projects = vim.tbl_keys(data)
		table.sort(projects, function(a, b)
			return data[a] > data[b]
		end)
		for _, proj in ipairs(projects) do
			table.insert(lines, string.format("  %-30s %s", proj, format(data[proj])))
		end
		vim.notify(table.concat(lines, "\n"))
	end, { desc = "Show time tracked per project" })
end

return M
