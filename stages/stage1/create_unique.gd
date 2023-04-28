@tool

extends Node3D

@export var prepare_for_baking = false: set = toggle_prepare 

func _toggle_prepare(rootnode):
	print("Processing ",rootnode)
	if rootnode is MeshInstance3D:
		if rootnode.mesh is ArrayMesh:
			if rootnode.mesh.lightmap_size_hint.length() == 0:
				rootnode.mesh = rootnode.mesh.duplicate()
				rootnode.mesh.lightmap_unwrap(rootnode.get_global_transform(), 0.05)
				rootnode.use_in_baked_light = true
			while rootnode.mesh.lightmap_size_hint.length() > 1500:
				rootnode.mesh.lightmap_size_hint /= 2
	elif rootnode is Node3D:
			for node in rootnode.get_children():
				_toggle_prepare(node)
 
func toggle_prepare(condition):
	if condition:
		for node in get_children():
			_toggle_prepare(node)
