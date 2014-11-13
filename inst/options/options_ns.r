options <- list(
	ns = libr::asPackage(".")$package,
	is_internal = FALSE,
	global_dir = file.path(Sys.getenv("HOME"), "rapp/ns", libr::asPackage(".")$package),
	github_name = NA_character_,
	option_1 = "your option value here (can be any R object)",
	option_2 = "your option value here (can be any R object)",
	option_3 = "your option value here (can be any R object)"
)
