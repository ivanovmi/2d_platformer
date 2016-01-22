$: << File.dirname(__FILE__)
require 'gosu'
require 'game/player'
require 'game/scene_map'
require 'pp'
include Gosu


class Block
  def initialize
  end
end

module ZOrder
  Background, Player, Block, UI = *0..3
end


class GameWindow < Window

  def initialize
    $window = self
    super(640,480)#,false)
    self.caption = 'Fuzed'
    $scene = SceneMap.new
  end

  def update
    $scene.update
  end

  def draw

    $scene.draw
  end

  def button_down(id)
    $scene.button_down(id)
    if id == KbLeftControl or id == KbRightControl
      fullscreen = !$window.fullscreen?
    end
  end

  def button_up(id)
    $scene.button_up(id)
  end

end


#class Platformer < Gosu::Window
#  def initialize
#    @screen_x = 640
#    @screen_y = 480
#    super @screen_x, @screen_y, false
#    self.caption = 'Platformer'
#    @background_image = Gosu::Image.new('background.jpg', :tileable => true)
#  end
#
#  def update
#    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
#    end
#    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
#    end
#    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0 then
#      if Gosu::button_down? Gosu::KbLeftControl then
#      else
#      end
#    end
#  end
#
#  def draw
#    fx = @screen_x/@background_image.width.to_f
#    fy = @screen_y/@background_image.height.to_f
#    @background_image.draw(0, 0, ZOrder::Background, fx, fy)
#  end
#
#  def button_down(id)
#    if id == Gosu::KbEscape
#      close
#    end
#  end
#end

window = GameWindow.new
window.show
