extends Node
class_name Languages

signal lang_changed()

const LANG_OPTIONS = {
	"hu": "Magyar",
	"en": "English"
	}

const LANG = {
	"en": {
		"language": "Language",
		"play": "Play",
		"character_creator": {
			"character_creator": "Character Creator",
			"hair": "Hair",
			"hair_options": "Hair Options",
			"shirt": "Shirt",
			"shirt_options": "Shirt Options",
			"pants": "Pants",
			"pants_options": "Pants Options",
			"style": "Style",
		},
		"worlds": {
			"worlds": "Worlds",
			"create_new_world": "Create New World"
		},
		"delete": "Delete",
		"back_to_menu": "Back To Menu",
		"save": "Save",
		"exit": "Exit"
	},
	"hu": {
		"language": "Nyelv",
		"play": "Játék",
		"character_creator": {
			"character_creator": "Karakter Készítő",
			"hair": "Haj",
			"hair_options": "Haj Opciók",
			"shirt": "Póló",
			"shirt_options": "Póló Opciók",
			"pants": "Nadrág",
			"pants_options": "Nadrág Opciók",
			"style": "Stílus",
		},
		"worlds": {
			"worlds": "Világok",
			"create_new_world": "Új Világ Létrehozása"
		},
		"delete": "Törlés",
		"back_to_menu": "Vissza A Menübe",
		"save": "Mentés",
		"exit": "Kilépés"
	}
}
