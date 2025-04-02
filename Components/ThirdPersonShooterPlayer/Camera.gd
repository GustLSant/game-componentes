class_name TpsCamera
extends Node3D

@onready var player:TpsPlayer = self.get_parent()

#region NodePaths
@export var pathPivotHeight:NodePath
@export var pathPivotRot:NodePath
@export var pathPivotBob:NodePath
@export var pathPivotShake:NodePath
@export var pathSpringArm:NodePath
@export var pathCamera:NodePath
@onready var pivotHeight:Marker3D = get_node(pathPivotHeight)
@onready var pivotRot:Marker3D = get_node(pathPivotRot)
@onready var pivotBob:Marker3D = get_node(pathPivotBob)
@onready var pivotShake:Marker3D = get_node(pathPivotShake)
@onready var springArm:SpringArm3D = get_node(pathSpringArm)
@onready var camera:Camera3D = get_node(pathCamera)
#endregion

var cameraSide:int = 1

#region Head Bobbing
const WALK_BOB_FREQUENCY:float = 0.007
const RUN_BOB_FREQUENCY_MULTIPLIER:float = 3.0
const MAX_BOB_AMPLITUDE:float = 0.035
var currentBobAmplitude:float = 0.0
#endregion


func _ready()->void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _input(_event:InputEvent)->void:
	if(_event is InputEventMouseMotion):
		const MOUSE_SENSI:float = 0.3
		pivotRot.rotation_degrees.y -= _event.relative.x * MOUSE_SENSI
		pivotRot.rotation_degrees.x -= _event.relative.y * MOUSE_SENSI
		pivotRot.rotation_degrees.x = clamp(pivotRot.rotation_degrees.x, -85.0, 70.0)
	pass


func _process(_delta:float)->void:
	handleCameraSide(_delta)
	handleCameraBobbing(_delta)
	return


func handleCameraSide(_delta:float)->void:
	springArm.rotation_degrees.y = lerp(springArm.rotation_degrees.y, 15.0*cameraSide, 8*_delta)
	camera.rotation_degrees.y = lerp(camera.rotation_degrees.y, -15.0*cameraSide, 8*_delta)
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, -4.0*cameraSide, 8*_delta)
	if(Input.is_action_just_pressed("ToggleCameraSide")): cameraSide *= -1
	pass


func handleCameraBobbing(_delta:float)->void:
	currentBobAmplitude = lerp(currentBobAmplitude, MAX_BOB_AMPLITUDE * player.isMoving, 10*_delta)
	var sprintFrequencyMultiplier:float = (1.0*int(not player.isSprinting) + int(player.isSprinting) * 1.5)
	var sprintAmplitudeMultiplier:float = (1.0*int(not player.isSprinting) + int(player.isSprinting) * 2.0)
	#pivotBob.position.x =  0.75*cos(Time.get_ticks_msec() * WALK_BOB_FREQUENCY*sprintFrequencyMultiplier) * currentBobAmplitude * sprintAmplitudeMultiplier
	pivotBob.position.y =  sin(2*Time.get_ticks_msec() * WALK_BOB_FREQUENCY*sprintFrequencyMultiplier) * currentBobAmplitude * sprintAmplitudeMultiplier
	pass
