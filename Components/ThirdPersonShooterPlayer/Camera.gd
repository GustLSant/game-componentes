class_name TpsCamera
extends Node3D

@onready var pivotHeight:Marker3D = $PivotHeight
@onready var pivotRot:Marker3D = $PivotHeight/PivotRot
@onready var raycast:RayCast3D = $PivotHeight/PivotRot/RayCast3D
@onready var camera:Camera3D = $PivotHeight/PivotRot/Camera3D


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


func _process(delta:float)->void:
	if(raycast.is_colliding()):
		var vecToCollPoint = raycast.get_collision_point() - raycast.global_position
		camera.global_position = raycast.get_collision_point() - vecToCollPoint.normalized()*0.1
	else:
		camera.global_position = raycast.global_position + raycast.global_transform.basis.z * raycast.target_position.z
		pass
	
	return
