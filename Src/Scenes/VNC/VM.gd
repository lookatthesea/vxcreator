extends Node

var vms = []
func add_vm(code):
	var f = preload("res://Scenes/VNC/Filesystem.gd").new().init()
	f.view.rect_position = Vector2(3, 30)
	f.view.rect_size = Vector2(463, 373)
	vms.append({'code': code,
				'ip': 0,
				'r': [],
				'files': f})

var t = 0
var to_remove = []
func _process(delta):
	t += delta
	if t <= 0.1:
		return
	t -= 0.1
	to_remove = []
	var i = 0
	while i < vms.size():
		vms[i]['code'][vms[i]['ip']].call_func(i)
		vms[i]['ip'] += 1
		if vms[i]['ip'] >= vms[i]['code'].size():
			vms[i]['ip'] = 0
	for i in to_remove:
		vms.remove(i)

### VM Operations ###

func bye(i):
	to_remove.append(i)
var BYE = funcref(self, "bye")

func nop(i):
	pass
var NOP = funcref(self, "nop")
