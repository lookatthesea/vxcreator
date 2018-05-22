extends Node

export(ImageTexture) var blank_icon
export(ImageTexture) var blank_infected_icon
export(ImageTexture) var blank_corrupted_icon
export(ImageTexture) var blank_activated_icon
func _ready():
	randomize()
	add_vm([])
	get_node("../BG/FolderBox").add_child(get(0)["files"]["view"])
	set_process(false)

var vms = []
func add_vm(code):
	var f = {'view': ItemList.new(),
			 'data': []}
	f['view'].rect_position = Vector2(3, 30)
	f['view'].rect_size = Vector2(463, 373)
	f['view'].add_item("notes.txt", blank_icon, false)
	f['view'].add_item("calendar.dat", blank_icon, false)
	f['data'].append(null)
	f['data'].append(null)
	vms.append({'code': code,
				'ip': 0,
				's': [],
				'r': [],
				'files': f})

func get(n):
	return vms[0]

var tick = 0
func _process(delta):
	tick += delta
	if tick < 0.5:
		return
	tick -= 0.5
	for vm in vms:
		var f = vm['code'][vm['ip']]
		vm['ip'] += 1
		f.call_func()

func random_file(vm):
	var f = randi() % vm['files']['view'].get_item_count()
	vm['s'].push_front(f)
var RANDOM_FILE = funcref(self, "random_file")

func execute_file(vm):
	vm['r'].push_front(vm['code'])
	vm['r'].push_front(vm['ip'])
	vm['code'] = vm['files']['data'][vm['s'].pop_front()]
	vm['ip'] = 0
var EXECUTE_FILE = funcref(self, "random_file")

func return_file(vm):
	vm['ip'] = vm['r'].pop_front()
	vm['code'] = vm['r'].pop_front()
var RETURN_FILE = funcref(self, "return_file")
