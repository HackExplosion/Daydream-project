extends CharacterBody2D

@export_category("Movement var")
@export var move_speed = 120.0
@export var decelaction = 0.1
@export var gravity = 500.0
var movement = Vector2()

@export_category("jump var")
@export var jump_speed=190.0
@export var accelration = 290.0
@export var jump_ammount = 2

@onready var end = $"../end"

@export_category("wall jump var")
@export var wall_slide = 10
@onready var left_ray: RayCast2D = $raycast/left_ray
@onready var right_ray: RayCast2D = $raycast/right_ray
@export var wall_x_force = 200.0
@export var wall_y_force = -220.0
var is_wall_jumping = false

@export_category("Thick sword variable")
@export var is_attacking: bool = false






func _ready() -> void: 
	$Sword/sword_collider .disabled = true

func _physics_process(delta: float) -> void:
	velocity.y += gravity*delta
	
	horizontalMovement()
	jump_logic()
	wall_logic()
	set_animations()
	flip()
	
	move_and_slide()

func horizontalMovement():
	if is_wall_jumping == false:
		movement = Input.get_axis("ui_left","ui_right")
		if movement:
			velocity.x = movement*move_speed
		else:
			velocity.x = move_toward(velocity.x,0,move_speed*decelaction)

func set_animations():
	if not is_attacking:
		
		if velocity.x!=0:
			$anim.play("Move")
		if velocity.x == 0:
			$anim.play("idli")
		if velocity.y < 0:
			$anim.play("Jump")
		if velocity.y > 10:
			$anim.play("Fuck")
		if is_on_wall_only():
			$anim.play("Fuck")
	if is_attacking:
		$anim.play("big sword")

func flip():
	if velocity.x > 0.0:
		scale.x = scale.y * 1
		wall_x_force = 200.0
	if velocity.x < 0.0:
		scale.x = scale.y* -1
		wall_y_force = -200.0



func jump_logic():
	if is_on_floor():
		jump_ammount =2
		if Input.is_action_just_pressed("ui_accept"):
			jump_ammount -=1
			velocity.y -= lerp(jump_speed,accelration,0.1)
	if not is_on_floor():
		if jump_ammount > 0:
			if Input.is_action_just_pressed("ui_accept"):
				jump_ammount -= 1
				velocity.y -=lerp(jump_speed, accelration,1)
			
			if Input.is_action_just_released("ui_accept"):
				velocity.y = lerp(velocity.y,	gravity,0.2)
				velocity.y *= 0.3
	else:
		return
		

func wall_logic():
	if is_on_wall_only():
		velocity.y = 10
		if Input.is_action_just_pressed("ui_accept"):
			#if left_ray.is_colliding():
				#velocity = Vector2(-wall_x_force, wall_y_force)
				#wall_jumping()
			if right_ray.is_colliding():
				jump_ammount = 2
				velocity = Vector2(wall_x_force,wall_y_force)
				wall_jumping()

			
func wall_jumping():
	is_wall_jumping=true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false 

func reset_states():
	is_attacking = false
	
	

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
	print("works")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().paused = true
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().paused == true:
		end.visible = true
	else:
		end.visible = false
