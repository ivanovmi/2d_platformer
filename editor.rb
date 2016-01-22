$: << File.dirname(__FILE__)

require 'gosu'
require 'rubygems'
include Gosu

require 'editor/editor_window'
require 'editor/scene_editor'

$window = EditorWindow.new
$window.show