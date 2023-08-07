extends Node

var player : Jumper
var score = 0 setget set_score
var level = 0
var best_score = 0 
var bonus  = 0 setget set_bonus
var num_circles = 0 setget set_circles

func _ready():
    $Screens/HUD.hide()
    best_score = Settings.load_best()
     
func new_game():
    self.score = 0
    self.bonus = 0
    self.num_circles = 0
    level = 1
    $Screens/HUD.update_score(score)
    $Camera2D.position = $StartPosition.position
    player = $Objects.createJumper()
    player.position = $StartPosition.position
    add_child(player)
    player.connect("captured", self, "_on_Jumper_captured")
    player.connect("died", self, "_on_Jumper_died")
    spawn_circle($StartPosition.position)
    $Screens/HUD.show()
    $Screens/HUD.show_message("Go!")
    if Settings.enable_music:
        $Music.volume_db = 0
        $Music.play()

func spawn_circle(_position=null):
    var c : CircleArea = $Objects.createCircle()
    if  !_position :
        var x = rand_range(-150,150)
        var y = rand_range(-500,-400)
        _position = player.target.position + Vector2(x,y)
    add_child(c)
    c.init(_position)
    
func _on_Jumper_captured(area: CircleArea):
    $Camera2D.position = area.position
    area.capture(player.position)
    area.connect("released", player, "die")
    area.connect("full_orbit", self, "set_bonus", [1])
    call_deferred("spawn_circle")
    self.score += 1 * bonus
    self.bonus += 1
    self.num_circles += 1
    

func set_circles(value):
    num_circles = value
    if num_circles > 0 and num_circles % Settings.circles_per_level == 0:
        level += 1
        $Screens/HUD.show_message("Level %s" % str(level))
        
func set_bonus(val):
    bonus = val
    $Screens/HUD.update_bonus(bonus)
    
    
func set_score(val):
    score = val
    $Screens/HUD.update_score(score)
    
func _on_Jumper_died() :
    get_tree().call_group("circles", "implode")
    if score > best_score:
        best_score = score
        Settings.save_best(best_score)
    $Screens.game_over(score, best_score)
    $Screens/HUD.hide()
    if Settings.enable_music:
         music_fade()
    
func music_fade() :
   var tween = create_tween() \
               .set_trans(Tween.TRANS_SINE) \
               .set_ease(Tween.EASE_IN) \
               .tween_property($Music, "volume_db", -50.0, 1.0) \
               .from(0.0)
   tween.connect("finished", $Music , "stop")
