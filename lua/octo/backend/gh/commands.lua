local utils = require "octo.utils"
local cli = require "octo.backend.gh.cli"
local graphql = require "octo.backend.gh.graphql"
-- local constants = require "octo.constants"
local window = require "octo.ui.window"
local writers = require "octo.ui.writers"

local _, Job = pcall(require, "plenary.job")

local M = {}

---@param repo string
---@param kind string
---@param number integer
---@param cb function
function M.load(repo, kind, number, cb)
  local owner, name = utils.split_repo(repo)
  local query, key

  if kind == "pull" then
    query = graphql("pull_request_query", owner, name, number, _G.octo_pv2_fragment)
    key = "pullRequest"
  elseif kind == "issue" then
    query = graphql("issue_query", owner, name, number, _G.octo_pv2_fragment)
    key = "issue"
  elseif kind == "repo" then
    query = graphql("repository_query", owner, name)
    key = "repo"
  end

  cli.run {
    args = { "api", "graphql", "--paginate", "--jq", ".", "-f", string.format("query=%s", query) },
    cb = function(output, stderr)
      if stderr and not utils.is_blank(stderr) then
        vim.api.nvim_err_writeln(stderr)
      elseif output then
        if kind == "pull" or kind == "issue" then
          local resp = utils.aggregate_pages(output, string.format("data.repository.%s.timelineItems.nodes", key))
          local obj = resp.data.repository[key]
          cb(obj)
        elseif kind == "repo" then
          local resp = vim.fn.json_decode(output)
          local obj = resp.data.repository
          cb(obj)
        end
      end
    end,
  }
end

---@param id string
function M.reactions_popup(id)
  local query = graphql("reactions_for_object_query", id)

  cli.run {
    args = { "api", "graphql", "-f", string.format("query=%s", query) },
    cb = function(output, stderr)
      if stderr and not utils.is_blank(stderr) then
        vim.api.nvim_err_writeln(stderr)
      elseif output then
        local resp = vim.fn.json_decode(output)
        local reactions = {}
        local reactionGroups = resp.data.node.reactionGroups
        for _, reactionGroup in ipairs(reactionGroups) do
          local users = reactionGroup.users.nodes
          local logins = {}
          for _, user in ipairs(users) do
            table.insert(logins, user.login)
          end
          if #logins > 0 then
            reactions[reactionGroup.content] = logins
          end
        end
        local popup_bufnr = vim.api.nvim_create_buf(false, true)
        local lines_count, max_length = writers.write_reactions_summary(popup_bufnr, reactions)
        window.create_popup {
          bufnr = popup_bufnr,
          width = 4 + max_length,
          height = 2 + lines_count,
        }
      end
    end,
  }
end

---@param login string
function M.user_popup(login)
  local query = graphql("user_profile_query", login)

  cli.run {
    args = { "api", "graphql", "-f", string.format("query=%s", query) },
    cb = function(output, stderr)
      if stderr and not utils.is_blank(stderr) then
        vim.api.nvim_err_writeln(stderr)
      elseif output then
        local resp = vim.fn.json_decode(output)
        local user = resp.data.user
        local popup_bufnr = vim.api.nvim_create_buf(false, true)
        local lines, max_length = writers.write_user_profile(popup_bufnr, user)
        window.create_popup {
          bufnr = popup_bufnr,
          width = 4 + max_length,
          height = 2 + lines,
        }
      end
    end,
  }
end

---@param repo string
---@param number integer
function M.link_popup(repo, number)
  local owner, name = utils.split_repo(repo)
  local query = graphql("issue_summary_query", owner, name, number)

  cli.run {
    args = { "api", "graphql", "-f", string.format("query=%s", query) },
    cb = function(output, stderr)
      if stderr and not utils.is_blank(stderr) then
        vim.api.nvim_err_writeln(stderr)
      elseif output then
        local resp = vim.fn.json_decode(output)
        local issue = resp.data.repository.issueOrPullRequest
        local popup_bufnr = vim.api.nvim_create_buf(false, true)
        local max_length = 80
        local lines = writers.write_issue_summary(popup_bufnr, issue, { max_length = max_length })
        window.create_popup {
          bufnr = popup_bufnr,
          width = max_length,
          height = 2 + lines,
        }
      end
    end,
  }
end










return M
