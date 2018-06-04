extends Node

export(ImageTexture) var blank_icon
export(ImageTexture) var blank_infected_icon
export(ImageTexture) var blank_corrupted_icon
export(ImageTexture) var blank_activated_icon
func _ready():
	get_node('../UserTimer').connect('timeout', self, 'do_users')
	get_node('../VirusTimer').connect('timeout', self, 'do_virii')
	randomize()
	add_vm([]); show_vm(0)

var vms = []
func file(name):
	return {'name': name, 'type': 'document'}
func virus():
	return {'pc': 0, 'fs': []}
func add_vm(code):
	var f = [file('calendar.dat'), file('accounts.txt'), file('PICZ.zip')]
	f[2]['type'] = 'infected'
	var virii = [virus()]
	vms.append({'files': f, 'virii': virii, 'code': code})

func show_vm(i):
	var view = get_node('../BG/FolderBox/FileView')
	view.clear()
	for f in vms[i]['files']:
		view.add_item(f['name'], blank_icon, false)
	for i in range(view.get_item_count()):
		view.set_item_tooltip_enabled(i, false)

func do_users():
	for vm in vms:
		var fi = randi() % vm['files'].size()
		var f = vm['files'][fi]
		if f['type'] == 'infected':
			vm['virii'].append({'pc': 0}) # execute infected file

func do_virii():
	for vm in vms:
		for v in vm['virii']:
			if v['pc'] >= vm['code'].size():
				virus_crashes(vm, v); continue
			var op = vm['code'][v['pc']]
			v['pc'] += 1
			if not op is FuncRef:
				virus_crashes(vm, v); continue
			op.call_func(vm, v)

func virus_crashes(vm, v):
	pass

### Virus Operations ###
func quit(vm, v):
	vm['virii'].erase(v)
var V_QUIT = funcref(self, 'quit')

func execute(vm, v):
	if v['fs'].size() <= 0:
		virus_crashes(vm, v); return
	if (v['fs'].pop())['type'] == 'infected':
		vm['virii'].append(virus())
var V_EXECUTE = funcref(self, 'execute')

func random_file(vm, v):
	if vm['files'].size() <= 0:
		virus_crashes(vm, v); return
	v['fs'].append(vm['files'][randi() % vm['files'].size()])
var V_RANDOM_FILE = funcref(self, 'random_file')

func sort_func(a, b):
	return a['name'] < b['name']
func sort_files(vm, v):
	v['fs'] = vm['files'].duplicate().custom_sort(self, 'sort_func')
var V_SORT_FILES = funcref(self, 'sort_files')
