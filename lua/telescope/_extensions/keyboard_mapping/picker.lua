local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')
local state = require('telescope.actions.state')


local apply = function (prompt_bufnr, scope)
  return function ()
    actions.close(prompt_bufnr)
    local selection = state.get_selected_entry()
    local name = vim.fn.fnamemodify(selection.value, ':t:r')
    vim.api.nvim_set_option_value('keymap', name, { scope = scope })
  end
end


return function (opts)
  opts = opts or {}

  local results = {}
  for _, fp in ipairs(vim.fn.globpath(vim.o.rtp, 'keymap/*.vim', true, true)) do
    table.insert(results, fp)
  end

  pickers.new(opts, {
    prompt_title = 'Keyboard mapping',
    finder = finders.new_table {
      results = results,
      entry_maker = function (fp)
        local name = vim.fn.fnamemodify(fp, ':t:r')
        return {
          value = fp,
          display = name,
          ordinal = name,
          path = fp,
        }
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = previewers.cat.new({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(apply(prompt_bufnr, 'local'))
      return true
    end,
  }):find()
end
