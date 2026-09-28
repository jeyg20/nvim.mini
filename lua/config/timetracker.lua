-- ========================================================================== --
-- MINIMAL PER-PROJECT TIME TRACKER (no API key, no external service)
-- ========================================================================== --
-- Heartbeats accumulate active seconds per project into a local JSON file.
-- Gaps longer than IDLE_SECONDS (away from the keyboard) are not counted.
--
-- Durability: this instance only ever tracks its own *unflushed* delta and
-- adds it to whatever is on disk at flush time. That keeps two concurrent
-- nvim instances from overwriting each other's hours, and the periodic flush
-- means a crash or a WSL shutdown costs at most FLUSH_SECONDS of tracking.

local M = {}

local IDLE_SECONDS = 120
local FLUSH_SECONDS = 60
local DATA_FILE = vim.fn.stdpath("data") .. "/timetracker.json"

-- Seconds accrued in this instance but not yet written to disk.
local pending = {}
local last_time
local last_project
local timer

local function read_file()
	local f = io.open(DATA_FILE, "r")
	if not f then
		return {}
	end
	local content = f:read("*a")
	f:close()
	local ok, decoded = pcall(vim.json.decode, content)
	if ok and type(decoded) == "table" then
		return decoded
	end
	return {}
end

local function flush()
	if vim.tbl_isempty(pending) then
		return
	end
	local disk = read_file()
	for proj, secs in pairs(pending) do
		disk[proj] = (disk[proj] or 0) + secs
	end
	local f = io.open(DATA_FILE, "w")
	if not f then
		-- Keep `pending` so the next flush retries instead of dropping the time.
		return
	end
	f:write(vim.json.encode(disk))
	f:close()
	pending = {}
end

local function project()
	local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
	return vim.fs.basename(root)
end

local function heartbeat()
	local now = os.time()
	local proj = project()
	if last_time and last_project == proj and (now - last_time) < IDLE_SECONDS then
		pending[proj] = (pending[proj] or 0) + (now - last_time)
	end
	last_time = now
	last_project = proj
end

local function format(seconds)
	return string.format("%dh %dm", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60))
end

function M.setup()
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertEnter", "BufEnter", "FocusGained" }, {
		desc = "Time tracker heartbeat",
		group = vim.api.nvim_create_augroup("timetracker-heartbeat", { clear = true }),
		callback = heartbeat,
	})

	timer = (vim.uv or vim.loop).new_timer()
	timer:start(
		FLUSH_SECONDS * 1000,
		FLUSH_SECONDS * 1000,
		vim.schedule_wrap(function()
			heartbeat()
			flush()
		end)
	)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		desc = "Time tracker save",
		group = vim.api.nvim_create_augroup("timetracker-save", { clear = true }),
		callback = function()
			if timer then
				timer:stop()
			end
			heartbeat()
			flush()
		end,
	})

	vim.api.nvim_create_user_command("TimeTracker", function()
		-- On-disk totals plus whatever this instance has not flushed yet.
		local totals = read_file()
		for proj, secs in pairs(pending) do
			totals[proj] = (totals[proj] or 0) + secs
		end

		local lines = { "Time tracked per project:" }
		local projects = vim.tbl_keys(totals)
		table.sort(projects, function(a, b)
			return totals[a] > totals[b]
		end)
		for _, proj in ipairs(projects) do
			table.insert(lines, string.format("  %-30s %s", proj, format(totals[proj])))
		end
		vim.notify(table.concat(lines, "\n"))
	end, { desc = "Show time tracked per project" })
end

return M
