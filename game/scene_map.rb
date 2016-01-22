class SceneMap

  def initialize
    @player = Player.new(96,16)
    @tileset = Image.load_tiles($window, 'textures/area02_level_tiles.png', 16, 16, true)
    @level = []
    @level[0] = [14,14,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,0,0,0,0,0,0,0,0]
    @level[1] = [14,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @level[2] = [10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @level[3] = [10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @level[4] = [14,2,2,2,2,2,2,5,0,0,0,0,0,1,2,2,2,2,2,2,2,2,2,2,2]
    @level[5] = [14,14,14,14,23,0,0,0,0,0,0,0,0,0,21,22,22,22,22,14,14,14,14,14,14]
    @level[6] = [14,23,0,0,0,0,0,0,0,0,0,25,2,5,0,0,0,0,0,0,0,0,21,14,14]
    @level[7] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,14]
    @level[8] = [14,0,0,0,0,25,2,2,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
    @level[9] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
    @level[10] = [14,0,0,0,0,0,0,0,0,0,25,2,5,0,0,0,0,0,0,0,0,0,0,0,14]
    @level[11] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
    @level[12] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,25,2,2,2,2,5,0,0,0,0,14]
    @level[13] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
    @level[14] = [14,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,14]
  end

  def update
    @player.update

    if $window.button_down?(KbLeft) and !wall?(@player.get_x, @player.get_y, :left) then
      @player.move_left
    end

    if $window.button_down?(KbRight) and !wall?(@player.get_x, @player.get_y, :right) then
      @player.move_right
    end

    @player.fall if no_ground?(@player.get_x, @player.get_y)

    if @player.is_jumping? then

      if solid_overhead?(@player.get_x, @player.get_y) then
        @player.reset_jump
      end

    end

  end

  def solid_overhead?(x,y)
    tile_x = (x/16).to_i
    tile_y = (y/16).to_i
    return @level[tile_y-2][tile_x] != 0
  end

  def wall?(x,y,direction)
    tile_x = (x/16).to_i
    tile_y = (y/16).to_i
    if direction == :left then
      return @level[tile_y-1][tile_x-1] != 0
    elsif direction == :right then
      return @level[tile_y-1][tile_x+1] != 0
    end
  end

  def no_ground?(x,y)
    tile_x = (x/16).to_i
    tile_y = (y/16).to_i
    return @level[tile_y][tile_x] == 0
  end

  def draw
    @player.draw
    for y in 0...@level.size
      for x in 0...@level[y].size
        @tileset[@level[y][x]].draw(x*16,y*16,1)
      end
    end
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
    if id == KbUp then
      @player.reset_jump if @player.is_jumping?
    end
  end

end
