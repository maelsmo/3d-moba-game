extends CanvasLayer

signal directionVector
var camguideY 
var camguideX 
var joystickIndex = -1
var attackIndex = -1
var s1Index = -1
var s2Index = -1
var dodgeIndex =-1
var cameraIndex = -1
var cameraInput = Vector2.ZERO
var rotationVelocityX = 0.0
var rotationVelocityY = 0.0
var joystickCenter
var joystickVector 
var joystickVectorNormalized
var direction = Vector3.ZERO
var joystickActive = false

@onready var joystickHandle = $Control/bg/inner


func _ready():
	camguideY = get_parent().get_node("character1Cotroller/camguideY")
	camguideX = get_parent().get_node("character1Cotroller/camguideY/camguideX")
	joystickCenter = joystickHandle.global_position
	
	
func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if Input.is_action_just_pressed("joystick_action"):
				joystickIndex = event.index
				joystickActive = true
			elif Input.is_action_just_pressed("attack_action"):
				attackIndex = event.index
			elif Input.is_action_just_pressed("s1_action"):
				attackIndex = event.index
			elif Input.is_action_just_pressed("s2_action"):
				attackIndex = event.index
			elif Input.is_action_just_pressed("dodge_action"):
				attackIndex = event.index
			else:
				cameraIndex = event.index
		else:
			if Input.is_action_just_released("joystick_action"):
				joystickIndex = -1
				joystickHandle.global_position = joystickCenter
			elif Input.is_action_just_released("attack_action"):
				attackIndex = -1
			elif Input.is_action_just_released("s1_action"):
				attackIndex = -1
			elif Input.is_action_just_released("s2_action"):
				attackIndex = -1
			elif Input.is_action_just_released("dodge_action"):
				attackIndex = -1
			else:
				cameraIndex = 1  
				
	if event is InputEventScreenDrag:
		if event.index == joystickIndex:
			joystickVector = event.position - joystickCenter
			joystickVectorNormalized = joystickVector.normalized()
			joystickHandle.global_position = joystickCenter + joystickVector.limit_length(80)
		if event.index == cameraIndex:
			cameraInput = event.relative

func _process(delta):
	$Label.text = str(Engine.get_frames_per_second())
	if joystickActive:	
		direction = -(camguideY.transform.basis.z * joystickVectorNormalized.y + camguideY.transform.basis.x * joystickVectorNormalized.x)
		emit_signal("directionVector", direction)
	else:
		emit_signal("directionVector", Vector3.ZERO)
		
	rotationVelocityX = lerpf(rotationVelocityX, cameraInput.x * 0.4, delta*10)
	rotationVelocityY = lerpf(rotationVelocityY, cameraInput.y * 0.15, delta*10)
	camguideX.rotate_x(deg_to_rad(rotationVelocityY))
	camguideY.rotate_y(deg_to_rad(rotationVelocityX))
	camguideX.rotation.x = clamp(camguideX.rotation.x, -0.5, 0.5)
	cameraInput = Vector2.ZERO
	

	
