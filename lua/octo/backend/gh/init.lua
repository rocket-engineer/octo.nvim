local cli = require "octo.backend.gh.cli"
local commands = require "octo.backend.gh.commands"

local M = {}

M.functions = {
  ["setup"] = cli.setup,
  ["load"] = commands.load,
  ["reactions_popup"] = commands.reactions_popup,
  ["user_popup"] = commands.user_popup,
  ["link_popup"] = commands.link_popup,
  ["cmds_delete_comment"] = commands.cmds_delete_comment,
  ["cmds_resolve_thread"] = commands.cmds_resolve_thread,
  ["cmds_unresolve_thread"] = commands.cmds_unresolve_thread,
  ["cmds_change_state"] = commands.cmds_change_state,
  ["cmds_save_issue"] = commands.cmds_save_issue,
  ["cmds_save_pr"] = commands.cmds_save_pr,
  ["cmds_mark_pr_ready"] = commands.cmds_mark_pr_ready,
  ["cmds_mark_pr_draft"] = commands.cmds_mark_pr_draft,
  ["cmds_pr_checks"] = commands.cmds_pr_checks,
  ["cmds_merge_pr"] = commands.cmds_merge_pr,
  ["cmds_show_pr_diff"] = commands.cmds_show_pr_diff,
  ["cmds_reaction_action"] = commands.cmds_reaction_action,
  ["cmds_add_project_card"] = commands.cmds_add_project_card,
  ["cmds_remove_project_card"] = commands.cmds_remove_project_card,
  ["cmds_move_project_card"] = commands.cmds_move_project_card,
  ["cmds_set_project_card_v2"] = commands.cmds_set_project_card_v2,
  ["cmds_remove_project_card_v2"] = commands.cmds_remove_project_card_v2,
  ["cmds_create_label"] = commands.cmds_create_label,
  ["cmds_add_label"] = commands.cmds_add_label,
  ["cmds_remove_label"] = commands.cmds_remove_label,
  ["cmds_add_user"] = commands.cmds_add_user,
  ["cmds_remove_assignee"] = commands.cmds_remove_assignee,
  ["buffer_fetch_taggable_users"] = commands.buffer_fetch_taggable_users,
  ["buffer_fetch_issues"] = commands.buffer_fetch_issues,
  ["buffer_save_title_and_body"] = commands.buffer_save_title_and_body,
  ["buffer_add_issue_comment"] = commands.buffer_add_issue_comment,
  ["buffer_add_thread_comment"] = commands.buffer_add_thread_comment,
  ["buffer_pr_add_thread"] = commands.buffer_pr_add_thread,
  ["buffer_commit_add_thread"] = commands.buffer_commit_add_thread,
  ["buffer_add_pr_comment"] = commands.buffer_add_pr_comment,
  ["buffer_update_comment"] = commands.buffer_update_comment,
}

return M
