local cli = require "octo.backend.gh.cli"
local commands = require "octo.backend.gh.commands"

local M = {}

M.functions = {
  ["setup"] = cli.setup,
  ["load"] = commands.load,
  ["reactions_popup"] = commands.reactions_popup,
  ["user_popup"] = commands.user_popup,
  ["link_popup"] = commands.link_popup,
}

return M
