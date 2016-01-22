class Player

  def get_x
    return @x
  end

  def get_y
    return @y
  end

  def initialize(x,y)
    @real_x = x
    @real_y = y
    @stand_right = Image.load_tiles($window, 'textures/player_1_jump_right.png', 128, 128, false)#textures/player_1_standby_right.png', 32, 32, false)
    @stand_left = Image.load_tiles($window, 'textures/player_1_standby_left.png', 32, 32, false)
    @walk_left = Image.load_tiles($window, 'textures/player_1_run_left.png', 32, 32, false)
    @walk_right = Image.load_tiles($window, 'textures/player_1_run_right.png', 32, 32, false)
    @jump_left = Image.load_tiles($window, 'textures/player_2_jump_left.png', 32, 32, false)
    @jump_right = Image.load_tiles($window, 'textures/player_1_jump_right.png', 128, 128, false)
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

  def draw(z=5)
    frame = milliseconds / 100 % @sprite.size
    @sprite[frame].draw(@real_x, @real_y, z)
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

  def is_jumping?
    return @jump > 0
  end

  def reset_jump
    @jump = 0
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

end
