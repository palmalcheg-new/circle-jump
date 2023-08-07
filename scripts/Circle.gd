extends Area2D
class_name CircleArea

onready var orbital_position =  $Pivot/OrbitPosition
var radius  = 100
var rotation_speed = PI
var  coll_shape : CircleShape2D

var move_range = 100
var move_speed = 1.0

enum MODES {
    STATIC,
    LIMITED
}

signal released
signal full_orbit

var mode = MODES.STATIC
var num_orbits =  3
var current_orbits = 0
var orbit_start = null
var position_captured

func init (_position,_radius=radius, level = 1):
    var _mode = Settings.rand_weighted([10,level-1])
    set_mode(_mode)
    position = _position
    var move_chance = clamp(level - 10, 0, 9) / 10.0
    if randf() < move_chance :
        move_range = max(25, 100 * rand_range(0.75, 1.25) * move_chance)
        move_speed = max(2.5 - ceil(level/5) * 0.25, 0.75)
    
    var small_size_chance =  min(0.9, max(0, (level-10) / 20.0))
    if randf() < small_size_chance :
        radius = max(50 , radius - level * rand_range(0.75,1.25))
    else:
        radius = _radius
    coll_shape = $CollisionShape2D.shape.duplicate()
    coll_shape.radius = radius
    var img_size = $Sprite.texture.get_size().x / 2
    $Sprite.scale = Vector2(1,1) * radius / img_size
    orbital_position.position.x = radius + 20
    rotation_speed *= pow(-1, randi() % 2)
    set_tween()

func set_mode(_mode):
    mode = _mode
    match mode :
        MODES.STATIC:
            $Label.hide()
        MODES.LIMITED:
            $Label.text = str(num_orbits)
            $Label.show()
    
func _process(delta):
    $Pivot.rotation += rotation_speed * delta
    if position_captured :
        check_orbits()
        
func check_orbits():
    if abs($Pivot.rotation - orbit_start) > 2 * PI :
        emit_signal("full_orbit")
        current_orbits += 1
        $Label.text = str(num_orbits - current_orbits)
        orbit_start = $Pivot.rotation
        if Settings.enable_sound:
            $Beep.play()
            
    if  num_orbits <= current_orbits :
        emit_signal("released")
        implode()

func implode() :
    $AnimationPlayer.play("implode")
    yield($AnimationPlayer,"animation_finished")
    queue_free()

func capture(at_position: Vector2):
    position_captured = at_position
    $AnimationPlayer.play("capture")
    $Pivot.rotation = (position_captured - position).angle()
    orbit_start = $Pivot.rotation
    
func set_tween(object=null, key=null):
    if move_range == 0 :
      return
    move_range *= -1
    var tween = create_tween() \
                 .set_trans(Tween.TRANS_QUAD) \
                 .set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "position:x" ,
                                position.x + move_range, 
                                move_speed) \
                        .from(position.x)
    tween.connect("finished",self,"set_tween")
    
