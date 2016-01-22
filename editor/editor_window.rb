class EditorWindow < Gosu::Window

  def initialize
    super(1024,768,false)
    self.caption = 'Fuzed: Map Editor'
    $window = self
    $scene = SceneEditor.new
  end

  def update
    $scene.update
  end

  def draw
    $scene.draw
  end

  def button_down(id)
    $scene.button_down(id)
    if id == KbEscape
      $window.close
    end
  end

  def button_up(id)
    $scene.button_up(id)
  end

  def needs_cursor?
    return true
  end

end