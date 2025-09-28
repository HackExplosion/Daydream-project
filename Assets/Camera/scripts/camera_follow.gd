extends Camera2D

@onready var ground: TileMapLayer = $"../ground"
@onready var player: CharacterBody2D = $"../Player"

@export var horizontal_dead_zone = 30
@export var vertical_dead_zone = 30
@export var follow_speed = 120.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	updateCamPosition(delta)


func setupCameraLimits():
	global_position = player.global_position
	var used_rect = ground.get_used_rect()
	var used_cell = ground.tile_set.tile_size
	var map_width = used_rect.size.x * used_cell.x
	var map_height = used_rect.size.y * used_cell.y
	var limit_left = used_rect.position.x * used_cell.x
	var limit_right = limit_left + map_width
	var limit_top = used_rect.position.y * used_cell.y
	var limit_bottom = limit_top + map_height
	
	print("tile_map_limits:", limit_left,", ", limit_right,", ",limit_top,", ",limit_bottom,", ")
	print("TileMap size(px) :", map_width, "x", map_height,"y")
	
func updateCamPosition(delta):
	if not player:
		return
		
	var player_pos = player.global_position
	var cam_pos = global_position
	var viewport_size = get_viewport_rect().size / zoom
	
	var target_pos = cam_pos
	
	if abs(player_pos.x - cam_pos.x) > horizontal_dead_zone:
		target_pos.x = player_pos.x
		
	if abs(player_pos.y - cam_pos.y) > vertical_dead_zone:
		target_pos.y = player_pos.y
	elif player_pos.y > cam_pos.y+vertical_dead_zone:
		target_pos.y = player_pos.y
		
	position.x = move_toward(position.x,target_pos.x,follow_speed*delta)
	
	if player_pos.y > cam_pos.y:
		position.y = move_toward(position.y, target_pos.y, player.velocity.y*delta)
	else:
		position.y = move_toward(position.y,target_pos.y,follow_speed*delta)
		
	
	
