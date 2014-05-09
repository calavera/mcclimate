THIS_DIR = File.expand_path(File.dirname(__FILE__))
LIBRARY  = File.expand_path('../lib', __dir__)

$LOAD_PATH << THIS_DIR unless $LOAD_PATH.include?(THIS_DIR)
$LOAD_PATH << LIBRARY  unless $LOAD_PATH.include?(LIBRARY)

require "tmpdir"
require "fileutils"
require "mcclimate"

require "helpers/repository_helper"

require "minitest/autorun"
