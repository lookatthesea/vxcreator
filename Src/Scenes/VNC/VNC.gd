extends Control

func _ready():
	var vm = preload("res://Scenes/VNC/VM.gd").new()
	vm.add_vm([vm.NOP])
	$BG/FolderBox.add_child(vm.vms[0]['files'].view)
