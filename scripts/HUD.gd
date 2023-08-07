extends CanvasLayer

var score = 0 

func _ready():
    $Message.rect_pivot_offset = $Message.rect_size / 2

func show_message(text):
    $Message.text = text
    $MessageAnimation.play("show_message")
    
func hide():
    $BonusBox.hide()
    $ScoreBox.hide()
    
func show():
    $BonusBox.show()
    $ScoreBox.show()
    
func update_score(value):
    var tween = create_tween() \
                  .set_trans(Tween.TRANS_LINEAR) \
                  .set_ease(Tween.EASE_IN)
    tween.tween_method(self, "_step_update_score", 
                       score, value, 0.25)
    $ScoreAnimation.play("score")
    yield($ScoreAnimation, "animation_finished")
    score = value
    
    
func _step_update_score(value):
    $ScoreBox/HBoxContainer/Score.text = str(value)
    
func update_bonus(value):
    $BonusBox/Bonus.text = str(value) + "x"
    if value > 1 :
        $BonusAnimation.play("bonus")
