extends Area2D
class_name Jumper

export (float , 1, 1000)  var jump_speed = 1000
export (float , 1, 1000) var freq =  1000
export (float, 1000) var amp = 1000

var velocity : Vector2 = Vector2(100,0)
var target : CircleArea = null
var time = 0

signal captured
signal died

onready var trail = $Trail/Points
var trail_length = 30

func _unhandled_input(event):
    if target and event is InputEventScreenTouch and event.is_pressed():
        jump()
    
func jump():
    target.implode()
    target = null
    velocity = transform.x * jump_speed
    if Settings.enable_sound:
        $Jump.play()


func _on_Jumper_area_entered(area: CircleArea):
    target = area
    velocity = Vector2.ZERO
    emit_signal("captured" , area)
    if Settings.enable_sound:
        $Capture.play()
    

func _physics_process(delta):
    if trail.points.size() > trail_length :
        trail.remove_point(0)
    
    trail.add_point(position)
        
    if target:
        transform = target.orbital_position.global_transform
    else:
        time += delta
        #velocity.y  = cos(time*freq) * amp
        position += velocity * delta

func die() :
    target = null
    queue_free()


func _on_VisibilityNotifier2D_screen_exited():
    if !target:
        emit_signal("died")
        die() # Replace with function body.
