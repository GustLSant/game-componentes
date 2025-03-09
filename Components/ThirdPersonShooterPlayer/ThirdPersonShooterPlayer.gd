extends CharacterBody3D

@onready var body:Node3D = $Body
@onready var camera:TpsCamera = $Camera

#region Movement
var vecMovement:Vector3 = Vector3.ZERO
var walkingSpeed:float = 4.0
#endregion


func _physics_process(_delta:float)->void:
	handleMovement(_delta)
	pass


func handleMovement(_delta:float)->void:
	# movimentacao horizontal pelo jogador
	vecMovement = (Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")) * body.global_transform.basis.x
	vecMovement += (Input.get_action_strength("MoveBackwards") - Input.get_action_strength("MoveFoward")) * body.global_transform.basis.z
	vecMovement.y = 0.0
	
	# rotacao do corpo na direcao da camera
	var isPlayerMoving:int = int( vecMovement.x != 0 or vecMovement.z != 0 )
	var isPlayerStandingStill:int = int( vecMovement.x == 0 and vecMovement.z == 0 )
	var targetBodyRotation:float = camera.pivotRot.rotation.y*isPlayerMoving + body.rotation.y*isPlayerStandingStill
	body.rotation.y = lerp_angle(body.rotation.y, targetBodyRotation, 12*_delta)
	
	self.velocity = vecMovement * walkingSpeed
	self.move_and_slide()
	pass
