local api = vim.api
local fn = vim.fn

-- get relative path to current file calculated from the git root directory
local function get_path()
    -- systemlist will give `nil` if directory is at the top level
    local dir = fn.systemlist('git rev-parse --show-prefix')[1] or ''
    local filename = fn.getreg('%')
    return dir..filename
end

-- caveat: mode must be 'v' or 'n'
local function get_lines(mode)
    if mode == 'v' then
        local start_line  = api.nvim_buf_get_mark(0, '<')[1]
        local end_line    = api.nvim_buf_get_mark(0, '>')[1]
        return start_line, end_line
    elseif mode == 'n' then
        local line = api.nvim_win_get_cursor(0)[1]
        return line, line
    end
end

--[[
some examples of a remote repository url

github (primary support)
https://github.com/pacokwon/plink.nvim.git
git@github.com:pacokwon/plink.nvim.git

https://github.com/pacokwon/plink.nvim.git/blob/master/.eslintignore#L1-L1

gitlab (currently unsupported)
https://gitlab.redox-os.org/redox-os/redox.git
--]]
local function parse_url(remote_url)

    if remote_url:find('github.com') == nil then
        return nil
    end

    -- currently github.com only supported
    local domain = 'github.com'
    local is_https = remote_url:find('^https://')

    local prefix
    if is_https then
        prefix = 'https://'..domain..'/'
    else
        prefix = 'git@'..domain..':'
    end

    local remote_url_len = string.len(remote_url)
    local prefix_len = string.len(prefix)
    local suffix_len = string.len('.git') -- ".git" must be excluded from url

    local repository = string.sub(remote_url, prefix_len + 1, remote_url_len - suffix_len)

    return {
        domain = domain,
        repository = repository,
    }
end

local function copy(mode)
    if mode ~= 'v' and mode ~= 'n' then
        return
    end

    local remote_url = fn.systemlist('git config --get remote.origin.url')[1]
    if vim.v.shell_error > 0 or remote_url == '' then
        return
    end

    local commit = fn.systemlist('git rev-parse HEAD')[1]
    local git = parse_url(remote_url)

    local start_line, end_line
    start_line, end_line = get_lines(mode)

    -- e.g. #L1-L15 for multiple lines, #L10 for single line
    local line_str
    if start_line == end_line then
        line_str = '#L'..start_line
    else
        line_str = '#L'..start_line..'-L'..end_line
    end

    local path = get_path()
    local url = 'https://'..git.domain..'/'..git.repository..'/blob/'..commit..'/'..path..line_str

    fn.setreg('+', url)
    print('Permalink URL copied to clipboard!')
end

return {
    ncopy = function () copy('n') end,
    vcopy = function () copy('v') end,
}
