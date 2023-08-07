extends Node

var score_file = "user://best. score"
var enable_sound = true
var enable_music = false
var circles_per_level = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var music_icons = {
      true :  preload("res://assets/images/buttons/musicOn.png"),
      false : preload("res://assets/images/buttons/musicOff.png")
   }

var audio_icons = {
     true : preload("res://assets/images/buttons/audioOn.png"),
     false : preload("res://assets/images/buttons/audioOff.png")
   }
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func  rand_weighted(weigths) :
     var sum = 0
     for w in weigths :
        sum += w
     var num =  rand_range(0, sum)
     for i in weigths.size():
        if num < weigths[i] :
            return i
        num -= weigths[i]

func load_best() : 
    var ret = 1
    var f = File.new()
    if f.file_exists(score_file) :
        f.open(score_file, File.READ)
        ret = f.get_var()
        f.close()
    return ret
    
func save_best(value) : 
    var f = File.new()
    f.open(score_file, File.WRITE)
    f.store_var(value)
    f.close()
