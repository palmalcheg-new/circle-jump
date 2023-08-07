extends CanvasLayer

func _ready():
    $ColorRect.material.set_shader_param("iChannel0", AudioDataExtractor.audio_texture)
