extends Node

export(ImageTexture) var blank_icon
export(ImageTexture) var blank_infected_icon
export(ImageTexture) var blank_corrupted_icon
export(ImageTexture) var blank_activated_icon
func _ready():
	randomize()
	add_vm([V_SORT_FILES, V_JUMP0, 7, V_NEXT_FILE, V_INFECT, V_JUMP, 1, V_QUIT])
	get_node('../VirusTimer').connect('timeout', self, 'do_virii')
	get_node('../VirusTimer').start()
	get_node('../DisplayTimer').connect('timeout', self, 'show_vm')
	get_node('../DisplayTimer').start()

var vms = []
func file(name):
	return {'name': name, 'type': 'document', 'icon': blank_icon}
var id = 0
func virus():
	id += 1
	return {'id': id, 'pc': 0, 'file': -1, 'fs': [], 'flag': -1}
func add_vm(code):
	var f = [file('calendar.dat'), file('accounts.txt'), file('PICZ.zip')]
	f[2]['type'] = 'infected'
	f[2]['icon'] = blank_infected_icon
	var virii = [virus()]
	vms.append({'files': f, 'virii': virii, 'code': code})

var viewing = 0
func show_vm():
	var view = get_node('../BG/FolderBox/FileView')
	view.clear()
	for f in vms[viewing]['files']:
		view.add_item(f['name'], f['icon'], false)
	for i in range(view.get_item_count()):
		view.set_item_tooltip_enabled(i, false)

func do_virii():
	for vm in vms:
		for v in vm['virii']:
			var op = vm['code'][v['pc']]
			v['pc'] = (v['pc'] + 1) % vm['code'].size()
			op.call_func(vm, v)

### Virus Opertaions ###
func test(vm, v):
	print(vm['virii'])
var V_TEST = funcref(self, 'test')

func random_file(vm, v):
	if vm['files'].size() <= 0:
		v['file'] = -1
		return
	v['file'] = randi() % vm['files'].size()
var V_RANDOM_FILE = funcref(self, 'random_file')

func sorter(a, b):
	return a['name'] < b['name']
func sort_files(vm, v):
	var sorted = vm['files'].duplicate()
	sorted.sort_custom(self, 'sorter')
	v['fs'].clear()
	for s in sorted:
		v['fs'].append(vm['files'].find(s))
var V_SORT_FILES = funcref(self, 'sort_files')

func next_file(vm, v):
	if v['fs'].size() <= 0:
		v['flag'] = 0
		v['file'] = -1
		return
	v['file'] = v['fs'].pop_front()
var V_NEXT_FILE = funcref(self, 'next_file')

func infect(vm, v):
	if v['file'] < 0:
		return
	vm['files'][v['file']]['icon'] = blank_infected_icon
	vm['files'][v['file']]['type'] = 'infected'
var V_INFECT = funcref(self, 'infect')

func execute(vm, v):
	if v['file'] < 0:
		return
	if vm['files'][v['file']]['type'] != 'infected':
		return
	vm['virii'].append(virus())
var V_EXECUTE = funcref(self, 'execute')

func jump(vm, v):
	v['pc'] = vm['code'][v['pc']] % vm['code'].size()
var V_JUMP = funcref(self, 'jump')

func jump0(vm, v):
	if v['flag'] == 0:
		jump(vm, v)
		return
	v['pc'] = (v['pc'] + 1) % vm['code'].size()
var V_JUMP0 = funcref(self, 'jump0')

func quit(vm, v):
	vm['virii'].erase(v)
var V_QUIT = funcref(self, 'quit')
