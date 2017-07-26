$LOAD_PATH.unshift(File.expand_path( '..', File.dirname(__FILE__)))

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))

require 'config/boot'