LIBRARY  = File.expand_path('../lib', __dir__)

$LOAD_PATH << __dir__ unless $LOAD_PATH.include?(__dir__)
$LOAD_PATH << LIBRARY  unless $LOAD_PATH.include?(LIBRARY)

require "fileutils"

require "mcclimate"

require "helpers/repository_helper"
require "helpers/ruby_source_helper"

require "minitest/autorun"
