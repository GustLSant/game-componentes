class_name TpsPlayer
extends CharacterBody3D

@onready var body:Node3D = $Body
@onready var camera:TpsCamera = $Camera

#region Movement
var vecMovement:Vector3 = Vector3.ZERO
var walkingSpeed:float = 5.0
var yMovement:float = 0.0
var jumpStrength:float = 10.0
var isMoving:int = 0
var isStandingStill:int = 0
#endregion

#region Sprint
var stamina:float = 100.0
var isSprinting:bool = false
const SPRINT_STAMINA_COST:float = 20.0
const STAMINA_RECOVER_FACTOR:float = 5.0
const SPRINT_SPEED_MULTIPLIER:float = 2.0
#endregion


func _physics_process(_delta:float)->void:
	handleMovement(_delta)
	pass


func handleMovement(_delta:float)->void:
	# movimentacao horizontal pelo jogador
	vecMovement = (Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")) * body.global_transform.basis.x
	vecMovement += (Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")) * body.global_transform.basis.z
	vecMovement = vecMovement.normalized()
	vecMovement.y = 0.0
	
	# rotacao do corpo na direcao da camera
	isMoving = int( vecMovement.x != 0 or vecMovement.z != 0 )
	isStandingStill = int( vecMovement.x == 0 and vecMovement.z == 0 )
	var targetBodyRotation:float = camera.pivotRot.rotation.y*isMoving + body.rotation.y*isStandingStill
	body.rotation.y = lerp_angle(body.rotation.y, targetBodyRotation, 12*_delta)
	
	# sprint activation
	if(Input.is_action_just_pressed("Sprint") and stamina > SPRINT_STAMINA_COST): isSprinting = !isSprinting
	isSprinting = isSprinting and isMoving and (stamina > 0.0)
	
	# sprint usage
	vecMovement = vecMovement*SPRINT_SPEED_MULTIPLIER*int(isSprinting) + vecMovement*int(not isSprinting)
	stamina += -SPRINT_STAMINA_COST*_delta*int(isSprinting) + STAMINA_RECOVER_FACTOR*_delta*int(not isSprinting)
	stamina = clamp(stamina, 0.0, 100.0)
	$Label.text = str(stamina)
	$Label2.text = 'isSprinting: ' + str(isSprinting)
	
	# gravidade e pulo
	if(self.is_on_floor()):
		if(Input.is_action_just_pressed("Jump")):
			yMovement += jumpStrength
	else:
		yMovement -= 20*_delta
		pass
	
	self.velocity = vecMovement * walkingSpeed
	self.velocity.y = yMovement
	self.move_and_slide()
	pass
