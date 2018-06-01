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
func add_vm(code):
	var f = [file('calendar.dat'), file('accounts.txt'), file('PICZ.zip')]
	f[2]['type'] = 'infected'
	var virii = [{'pc': 0}]
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
		pass
