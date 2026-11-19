extends Node2D

@onready var spawn: Marker2D = $spawn
@onready var player: Player = $player
@onready var camera_2d: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.get_node("RemoteTransform2D").remote_path = camera_2d.get_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.global_position.y>2000:
		player.global_position=spawn.global_position



	
