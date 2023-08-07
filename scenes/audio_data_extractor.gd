extends Node2D
# add this script to autoload 
# use "audio_texture" anywhere you need
# see playground scene for usage in shaders and particles

const NOTES_AMOUNT = 108
const FREQ_MIN = 20.0 
# FREQ_MAX is not used directly but 
# 108 notes starting from 20 Hz gives about 10.2k Hz highest frequency
const FREQ_MAX = 10000.0 
const FREQ_RANGE = FREQ_MAX - FREQ_MIN

const MIN_DB = 100

var notes = get_notes(FREQ_MIN)

var bands_data = []
var energy_volume = 0
var prev_energy = []
var prev_small_radius = 0

var smoothing = true
var smoothing_value = 0.5;

var spectrumAnalyzer

# texture for shader
var img : Image = Image.new()
var audio_texture : ImageTexture = ImageTexture.new()
var size = NOTES_AMOUNT
# idk what to do with it but numbers like 2-3-4 produce blank pixels between values
var tex_band_spacing = 1

var limit = 1

var data = []
var data_updated = false

var node_to_send = null

func process_audio():
    
    #warning-ignore:integer_division
    
    var magnitude_full_db = spectrumAnalyzer.get_magnitude_for_frequency_range(FREQ_MIN, FREQ_MAX, 0).length()
    energy_volume = clamp((MIN_DB + linear2db(magnitude_full_db)) / MIN_DB, 0, 1)
    
    for i in range(NOTES_AMOUNT):

        prev_energy[i] = bands_data[i]

        var hz = notes[i];
        var hz_from = hz * 0.98
        var hz_to = hz * 1.02
        var magnitude: float = spectrumAnalyzer.get_magnitude_for_frequency_range(hz_from, hz_to, 1).length()
        var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
        
#		interpolation if smooth movement needed
        if smoothing:
            energy = lerp(prev_energy[i], energy, smoothing_value)
        
        bands_data[i] = energy
    
#	octaves cleanup needed?
    
    
    update_texture()
        
func update_texture():
    
    img.lock()
    
    for i in size:
        var current = bands_data[i]
        var previous = prev_energy[i]
        var total_energy = energy_volume
#		writing data to RGB channels
        img.set_pixel(i * tex_band_spacing, 0, Color(current, previous, total_energy, 1))
            
    img.unlock()
    VisualServer.texture_set_data_partial(audio_texture.get_rid(), img, 0, 0, size * tex_band_spacing, 1, 0, 0, 0, 0)


func _process(_delta):
    process_audio()

func init_analyzer (): 

    var effectsCount = AudioServer.get_bus_effect_count(0);
    var effect = AudioEffectSpectrumAnalyzer.new()

    AudioServer.add_bus_effect(0, effect, effectsCount)
        
    spectrumAnalyzer = AudioServer.get_bus_effect_instance(0, effectsCount)

func _ready():
    
    randomize()
    
    prev_energy.resize(NOTES_AMOUNT)
    bands_data.resize(NOTES_AMOUNT)
    for i in range(prev_energy.size()):
        prev_energy[i] = 0
        bands_data[i] = 0
        
    init_analyzer()
        
    img.create(size * tex_band_spacing, 2, false, Image.FORMAT_RGBA8)
    audio_texture.create_from_image(img)
    audio_texture.set_storage(ImageTexture.STORAGE_RAW)
    
    
func get_notes(lowestNoteHz = 20):
    
    var frequencies = []
    
    var k = 1.05946
    
    var hz = lowestNoteHz
    
    for i in NOTES_AMOUNT: # NOTES_AMOUNT = 108
        hz *= k
        frequencies.append(hz)
        
    return frequencies
