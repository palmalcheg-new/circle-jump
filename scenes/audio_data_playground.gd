extends ColorRect

func _ready():
    $ColorRect.material.set_shader_param('audio_data_tex', AudioDataExtractor.audio_texture);
    
    $ColorRect2.material.set_shader_param('audio_data_tex', AudioDataExtractor.audio_texture);
    $ColorRect2.material.set_shader_param('notes_amount', AudioDataExtractor.NOTES_AMOUNT)
    
    $TextureRect.texture = AudioDataExtractor.audio_texture;
    
    $Particles2D.process_material.set_shader_param('audio_data_tex', AudioDataExtractor.audio_texture)
    $Particles2D.process_material.set_shader_param('beat_freq', AudioDataExtractor.NOTES_AMOUNT)
    
    $Particles2D.show()

#	$ColorRect2.show()
