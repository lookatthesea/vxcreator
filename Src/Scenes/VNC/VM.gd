extends Node

var vms = []
func add_vm(code):
	var f = ItemList.new()
	f.rect_pos = Vector2(3, 30)
	f.rect_size = Vector2(463, 373)
	vms.append({'code': code,
				'ip': 0,
				'r': [],
				'files': f})

var t = 0
func _process(delta):
	t += delta
	if t <= 0.1:
		return
	t -= 0.1
	var to_remove = []
	var i = 0
	while i < vms.size():
		vms[i]['code'][vms[i]['ip']].call_func(i)
	for i in to_remove:
		vms.remove(i)

### VM Operations ###

func bye(i):
	to_remove.append(i)
