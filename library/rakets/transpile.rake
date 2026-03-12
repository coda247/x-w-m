
require_relative '../engine/transpiler'

namespace :transpile do
  desc 'Render configuration and compose files and keys'
  task :config do
    transpiler = Engine::Transpiler.new
    transpiler.transpile_keys
    transpiler.transpile
  end
end
