local telescope = require('telescope')

local picker = require('telescope._extensions.keyboard_mapping.picker')

return telescope.register_extension({
  exports = {
    keyboard_mapping = picker,
  },
})
