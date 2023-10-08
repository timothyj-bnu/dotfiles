local home = os.getenv("HOME")
if vim.fn.has("unix") == 1 then
    WORKSPACE_PATH = home .. "/jdtls-workspace/"
else
    print("Unsupported system")
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = WORKSPACE_PATH .. project_name

local lsp_server_path = "/Users/juliant/.local/share/nvim/mason/packages/jdtls" .. "/" .. "config_mac" 
local jar_path =  "/Users/juliant/.local/share/nvim/mason/packages/jdtls/plugins" .. "/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar"
local lombok_path = "/Users/juliant/.local/share/nvim/mason/packages/jdtls" .. "/lombok.jar"
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
      '/usr/local/opt/openjdk@17/bin/java', -- or '/path/to/java17_or_newer/bin/java'
      -- depends on if `java` is in your $PATH env variable and if it points to the right version.

      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xmx1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-javaagent:' .. lombok_path, -- need to set also in mason jdtls

      -- 💀
      '-jar', jar_path,
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
      -- Must point to the                                                     Change this to
      -- eclipse.jdt.ls installation                                           the actual version


      -- 💀
      '-configuration', lsp_server_path,
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
      -- Must point to the                      Change to one of `linux`, `win` or `mac`
      -- eclipse.jdt.ls installation            Depending on your system.


      -- 💀
      -- See `data directory configuration` section in the README
      '-data', workspace_dir,
  },
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
      java = {
          format = {
              enabled = true,
              settings = {
                url = '/Users/juliant/Documents/Paylater/AlipayFormatter.xml',
              }
          },
          configuration = {
              runtimes = {
                  {
                      name = "JavaSE-1.8",
                      path = "/usr/local/Cellar/openjdk@8/1.8.0-382_1/libexec/openjdk.jdk/Contents/Home",
                      default = true,
                  },
                  {
                      name = "JavaSE-17",
                      path = "/usr/local/Cellar/openjdk@17/17.0.8.1/libexec/openjdk.jdk/Contents/Home",
                  },
              },
          },
      }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
