extends TextureRect

@onready var audio_stream_player = $AudioStreamPlayer
@onready var margin_container = $MarginContainer
@onready var margin_container_2 = $MarginContainer2
@onready var margin_container_3 = $MarginContainer3

@export var music_transition_duration = 1

# ------ Handle StartButton Pressed ------ #
func _on_start_game_button_pressed():
	margin_container.visible = false
	margin_container_2.visible = false
	margin_container_3.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -80, 3)
	tween.connect("finished", tweenFinished)

# ------ Handle QuitGameButton Pressed ------ #
func _on_quit_game_button_pressed():
	get_tree().quit()

# ------ Handle OptionsButton Pressed ------ #
func _on_options_button_pressed():
	# TODO: Options Menu!
	pass # Replace with function body.

# ------ Tween Finished Function ------ #
func tweenFinished():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
