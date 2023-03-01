# typed: strict
# frozen_string_literal: true

require_relative "io_read"
require_relative "move_to_extend_os"
require_relative "shell_commands"

# formula audit cops
require_relative "bottle"
require_relative "caveats"
require_relative "checksum"
require_relative "class"
require_relative "components_order"
require_relative "components_redundancy"
require_relative "conflicts"
require_relative "dependency_order"
require_relative "deprecate_disable"
require_relative "desc"
require_relative "files"
require_relative "homepage"
require_relative "keg_only"
require_relative "lines"
require_relative "livecheck"
require_relative "options"
require_relative "patches"
require_relative "text"
require_relative "urls"
require_relative "uses_from_macos"
require_relative "version"

require_relative "rubocop-cask"
