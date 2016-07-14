require 'gosu'

class WhackAFabe < Gosu::Window
  def initialize
    super(900, 700)
    self.caption = 'Whack the Fabe!'
    @image = Gosu::Image.new('Fabe.png')
    @x = 200
    @y = 200
    @width  = 80
    @height = 126
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0
    @hammer_image = Gosu::Image.new('smaller_hammer.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true
    @start_time = 0
  end

  def draw
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    @hammer_image.draw(mouse_x - 50, mouse_y - 44.5, 1)
    if @hit == 0
      c = Gosu::Color.argb(0xff_96C2DB)
    elsif @hit == 1
      c = Gosu::Color.argb(0xff_67F089)
    elsif @hit == -1
      c = Gosu::Color.argb(0xff_FE3C3C)
    end
    draw_quad(0, 0, c, 900, 0, c, 900, 700, c, 0, 700, c)
    @hit = 0
    @font.draw(@score.to_s, 700, 20, 2)
    @font.draw(@time_left.to_s, 20, 20, 2)

    unless @playing
      @font.draw('GAME OVER', 350, 350, 3)
      @font.draw('Press the Space Bar to Play Again', 240, 450, 3)
      @visible = 20
    end
  end

  def update
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= -1 if @x + @width / 2 > 900 || @x - @width / 2 < 0
    @velocity_y *= -1 if @y + @height / 2 > 700 || @y - @height / 2 < 0
    @visible -= 1
    @visible = 30 if @visible < -10 && rand < 0.01
    @time_left = (100 - ((Gosu.milliseconds - @start_time) / 1000))
    @playing = false if @time_left < 0
  end

  def button_down(id)
    if @playing
      if id == Gosu::MsLeft
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1
          @score += 5
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      if id == Gosu::KbSpace
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end
end

window = WhackAFabe.new
window.show
