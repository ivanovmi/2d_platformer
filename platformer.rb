require 'gosu'
require 'pp'
include Gosu

class Player

  def initialize(x,y)
    @real_x = x
    @real_y = y
    @stand_right = Image.load_tiles($window, 'player_1_standby_right.png', 32, 32, false)
    @stand_left = Image.load_tiles($window, 'player_1_standby_left.png', 32, 32, false)
    @walk_left = Image.load_tiles($window, 'player_1_run_left.png', 32, 32, false)
    @walk_right = Image.load_tiles($window, 'player_1_run_right.png', 32, 32, false)
    @jump_left = Image.load_tiles($window, 'player_1_jump_left.png', 32, 32, false)
    @jump_right = Image.load_tiles($window, 'player_1_jump_right.png', 32, 32, false)
    @sprite = @stand_right
    @dir = :right
    @x = @real_x + (@sprite[0].width / 2)
    @y = @real_y + @sprite[0].height
    @move_x = 0
    @moving = false
    @jump = 0
  end

  def update
    @real_x = @x - (@sprite[0].width / 2)
    @real_y = @y - @sprite[0].height

    if @moving then
      if @move_x > 0 then
        @move_x -= 1
        @x += 1
      elsif @move_x < 0 then
        @move_x += 1
        @x -= 1
      elsif @move_x == 0 then
        @moving = false
      end
    else
      if @dir == :left then
        @sprite = @stand_left
      elsif @dir == :right then
        @sprite = @stand_right
      end
    end

    if @jump > 0 then
      @y -= 5
      if @dir == :left then
        @sprite = @jump_left
      elsif @dir == :right then
        @sprite = @jump_right
      end
      @jump -= 1
    end
  end

  def fall
    if @jump == 0 then
      @y += 2
      if @dir == :left then
        @sprite = @jump_left
      elsif @dir == :right then
        @sprite = @jump_right
      end
    end
  end

  def jump
    @jump = 15 if @jump == 0
  end

  def move_left
    @dir = :left
    @move_x = -3
    @sprite = @walk_left if @jump == 0
    @moving = true
  end

  def move_right
    @dir = :right
    @move_x = 3
    @sprite = @walk_right if @jump == 0
    @moving = true
  end

  def get_x
    return @x
  end

  def get_y
    return @y
  end

  def draw(z=5)
    frame = milliseconds / 150 % @sprite.size
    @sprite[frame].draw(@real_x, @real_y, z)
  end

end

class Block
  def initialize
  end
end

module ZOrder
  Background, Player, Block, UI = *0..3
end

class SceneMap

  def initialize
    @player = Player.new(128,128)
  end

  def update
    @player.update
    @player.move_left if $window.button_down?(KbLeft)
    @player.move_right if $window.button_down?(KbRight)
    @player.fall if no_ground?(@player.get_x, @player.get_y)
  end

  def no_ground?(x,y)
    return y < 480
  end

  def draw
    @player.draw
  end

  def button_down(id)
    if id == KbUp then
      if !no_ground?(@player.get_x, @player.get_y) then
        @player.jump
      end
    end
    if id == KbEscape
      $window.close
    end
  end

  def button_up(id)

  end

end

class GameWindow < Window

  def initialize
    $window = self
    super(640,480)#,false)
    self.caption = 'Fuzed'
    $scene = SceneMap.new

    p $window.fullscreen?
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
      #$window[:fullscreen] => fullscreen
      #if id == KbEnter

      #end
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
