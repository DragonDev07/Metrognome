extends Node2D

@onready var world = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.SKY_BLUE)
