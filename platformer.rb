require 'gosu'
include Gosu


class Star
  attr_reader :x, :y

  def initialize(animation, screen_x, screen_y)
    @animation = animation
    @color = Gosu::Color.new(0xff_ffffff)
    #@color.red = rand(256 - 40) + 40
    #@color.green = rand(256 - 40) + 40
    #@color.blue = rand(256 - 40) + 40
    @x = rand * screen_x
    @y = rand * screen_y
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
             ZOrder::Stars, 1, 1, @color, :add)
  end
end

class Player
  def initialize(screen_x, screen_y)
    @screen_x = screen_x
    @screen_y = screen_y
    @image = Gosu::Image.new("starfighter.bmp")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def moar_speed
    @vel_x += Gosu::offset_x(@angle, 10)
    @vel_y += Gosu::offset_y(@angle, 10)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= @screen_x
    @y %= @screen_y

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def score
    @score
  end

  def collect_stars(stars)
    if stars.reject! {|star| Gosu::distance(@x, @y, star.x, star.y) < 35 } then
      @score += 1
    end
  end
end

module ZOrder
  Background, Player, Block, UI = *0..3
end

class Block
  def initialize(screen_x, screen_y)
    @img = Gosu::Image.new('brick.png')

    lvl = File.open('scheme_lvl')
    @content = lvl.readlines
    @content.each { |line| line.chomp("\n")}

    lvl_x = @content[0].length - 1
    lvl_y = @content.length

    @size_x = (screen_x/lvl_x.to_f).round
    @size_y = (screen_y/lvl_y.to_f).round

  end

  def get_coordinates
    coordinates = Array.new
    pos_x = 0
    pos_y = 0

    for line in @content
      for symbol in line.split('')
        if symbol == '-'
          coordinates.push([pos_x, pos_y])
        end
        pos_x += @size_x
        pos_y += @size_y
      end

    end

    puts coordinates
    return coordinates
  end

  def draw

    @img.draw(0, 0, ZOrder::Block, (@img.width/@size_x).round/10.0, (@img.height/@size_y).round/10.0)
    #for i in @lvl
    #  for j in i
    #    puts j
    #    if j == '-'
    #      @img.draw(0, 0, ZOrder::Block, (@img.width/@size_x).round/10.0, (@img.height/@size_y).round/10.0)
    #    end
    #  end
    #  pos_x += @size_x
    #  pos_y += @size_y
    #end
  end
end

class Platformer < Gosu::Window
  def initialize
    @screen_x = 640
    @screen_y = 480
    super @screen_x, @screen_y, false
    self.caption = 'Platformer'
    @background_image = Gosu::Image.new('background.jpg', :tileable => true)
    @player = Player.new(@screen_x, @screen_y)
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles('star.png', 25, 25)
    @stars = Array.new

    @font = Gosu::Font.new(20)
    @brick = Block.new(@screen_x, @screen_y)
    @bricks = Array.new
  end

  def update
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
      @player.turn_right
    end
    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0 then
      if Gosu::button_down? Gosu::KbLeftControl then
        @player.moar_speed
      else
        @player.accelerate
      end
    end
    @player.move
    @player.collect_stars(@stars)

    #if rand(1) < 4 and @stars.size < 700 then
    #  @stars.push(Star.new(@star_anim, @screen_x, @screen_y))
    #end

    if @player.score == 50 then
      puts 'You win!!!'
      #close
    end

  end

  def draw
    fx = @screen_x/@background_image.width.to_f
    fy = @screen_y/@background_image.height.to_f
    #puts 'image width: '+@background_image.width.to_s+', image height: '+@background_image.height.to_s
    #puts 'fx: ' + fx.to_s + ', fy: ' + fy.to_s
    @background_image.draw(0, 0, ZOrder::Background, fx, fy)
    # @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @brick.get_coordinates
    #@stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = Platformer.new
window.show
