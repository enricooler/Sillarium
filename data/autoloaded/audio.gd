""" ESTE SINGLETON SE ENCARGA DE MANEJAR TODO LO REFERENTE AL AUDIO! 
   ACORDATE DE QUE SIEMPRE DEBE ESTAR CARGADO Y ACTIVADO YA QUE ESTE REPRODUCTOR SE USA GLOBALMENTE """

extends Node

signal pump

const COMPENSATE_FRAMES = 2
const COMPENSATE_HZ = 60.0

# lee desde el archivo de configuración si el juego deberia reproducir musica.
onready var mute = Settings.getSetting("audio", "mute_audio")

# esta variable guarda el reproductor de audio que se este usando, ojo, no es para guardar el archivo actual que se este reproduciendo
var currentMusic
var beat setget setBeat, getBeat
var time

func musicSetup(bgmID):
	mute = Settings.getSetting("audio", "mute_audio")
	# ! significa "NO", o sea que si mute esta desactivado, todo este pedazo de codigo se va a ejecutar.
	if !mute:
		# si bgmID tiene algun numero dentro...
		if (bgmID != null):
			# se va a cargar el archivo de musica desde el JSON, según su ID.
			var musicToLoad = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
			
			# si no existe un reproductor de audio, creemos uno y que reproduzca la musica que le pasamos arriba.
			if currentMusic == null:
				currentMusic = AudioStreamPlayer.new()
				currentMusic.stream = musicToLoad
				currentMusic.play()
				add_child(currentMusic)
				
			# si el reproductor existe, pero queremos cambiar de musica, paramos la musica anterior y empezamos a reproducir la nueva.
			if currentMusic.stream != musicToLoad:
				currentMusic.stop()
				currentMusic.stream = load(Globals.LoadJSON("res://data/json/music.json", str(bgmID))["file"])
				currentMusic.play()
			
	else:
		if currentMusic != null:
			currentMusic.queue_free()
	
func _process(_delta):
	if !currentMusic or !currentMusic.playing:
		return
	
	time = currentMusic.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() + (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
	self.beat = int(time * getMusicBPM(Objects.currentWorld.musicID) / 60.0) % 4
	
func setBeat(value):
	var oldBeat = beat
	
	if value == oldBeat:
		return
	else:
		beat = value
		emit_signal("pump")
	
func getBeat():
	return beat
	
func getMusicBPM(bgmID):
	# el tempo de la musica es un valor que se lee desde el JSON. necesitamos pasarle el ID del tema el cual queremos conseguir su tempo.
	var tempo = Globals.LoadJSON("res://data/json/music.json", str(bgmID))["tempo"]
	
	return float(tempo)
	
func getMusicPeakVolume():
	# el volumen de cada lado del parlante del servidor de audio, se lo pasamos con un Vector2 para manipularlo más fácil.
	var left = AudioServer.get_bus_peak_volume_left_db(0, 0)
	var right = AudioServer.get_bus_peak_volume_right_db(0, 0)
	
	return Vector2(left, right)
