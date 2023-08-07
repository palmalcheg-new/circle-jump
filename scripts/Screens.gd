extends Node

signal new_game
var current_screen

# Called when the node enters the scene tree for the first time.
func _ready():
    register_buttons()
    change_screen($Title)

func register_buttons():
    var buttons  = get_tree().get_nodes_in_group("buttons")
    for btn in buttons:
        btn.connect("pressed", self, "_on_btn_pressed", [btn] )
        match btn.name:
            "Sound":
                btn.texture_normal = Settings.audio_icons[Settings.enable_sound]
            "Music":
                btn.texture_normal = Settings.music_icons[Settings.enable_music]

func _on_btn_pressed(button : TextureButton):
    if Settings.enable_sound:
        $Click.play()
    match button.name:
        "Home" :
            change_screen($Title)
        "Play", "Return" :
            change_screen(null)
            emit_signal("new_game")
        "Settings" :
            change_screen($Settings)
        "Sound" :
            Settings.enable_sound = !Settings.enable_sound
            var sound_texture = Settings.audio_icons[Settings.enable_sound]
            button.texture_normal = sound_texture
        "Music" :
            Settings.enable_music = !Settings.enable_music
            var music_texture = Settings.music_icons[Settings.enable_music]
            button.texture_normal = music_texture
    

func change_screen(screen):
    if current_screen:
        current_screen.disappear()
    current_screen = screen
    if current_screen:
        current_screen.appear()

func game_over(score, best_score):
    var score_box =  $GameOver/MarginContainer/VBoxContainer/Scores
    score_box.get_node("Score").text = "Score : %s" % score
    score_box.get_node("Best").text = "Best : %s" % best_score
    change_screen($GameOver)
