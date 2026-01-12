local jdtls = require 'jdtls'

-- Get the project name from current working directory
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- Set up a dedicated workspace directory
local workspace_dir = vim.fn.expand '~/.local/share/nvim/jdtls-workspace/' .. project_name

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=WARN',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '-jar',
    vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
    '-configuration',
    vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/config_mac',
    '-data',
    workspace_dir,
  },

  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      format = {
        enabled = true,
      },
    },
  },

  init_options = {
    bundles = {},
  },

  capabilities = require('blink.cmp').get_lsp_capabilities(),
}

jdtls.start_or_attach(config)

-- Key mappings for Java-specific features
local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set('n', '<A-o>', jdtls.organize_imports, { desc = 'Organize Imports' })
vim.keymap.set('n', 'crv', jdtls.extract_variable, opts)
vim.keymap.set('x', 'crv', function()
  jdtls.extract_variable(true)
end, opts)
vim.keymap.set('n', 'crc', jdtls.extract_constant, opts)
vim.keymap.set('x', 'crc', function()
  jdtls.extract_constant(true)
end, opts)
vim.keymap.set('x', 'crm', function()
  jdtls.extract_method(true)
end, opts)
