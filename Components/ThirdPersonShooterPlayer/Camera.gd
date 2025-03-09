class_name TpsCamera
extends Node3D

@onready var pivotHeight:Marker3D = $PivotHeight
@onready var pivotRot:Marker3D = $PivotHeight/PivotRot
@onready var raycast:RayCast3D = $PivotHeight/PivotRot/RayCast3D
@onready var camera:Camera3D = $PivotHeight/PivotRot/Camera3D

var cameraSide:int = 1


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
	handleCameraCollision()
	handleCameraSide(_delta)
	return


func handleCameraCollision()->void:
	if(raycast.is_colliding()):
		var vecToCollPoint = raycast.get_collision_point() - raycast.global_position
		camera.global_position = raycast.get_collision_point() - vecToCollPoint.normalized()*0.1
	else:
		camera.global_position = raycast.global_position + raycast.global_transform.basis.z * raycast.target_position.z
		pass
	pass


func handleCameraSide(_delta:float)->void:
	raycast.rotation_degrees.y = lerp(raycast.rotation_degrees.y, 15.0*cameraSide, 8*_delta)
	if(Input.is_action_just_pressed("ToggleCameraSide")): cameraSide *= -1
	pass
