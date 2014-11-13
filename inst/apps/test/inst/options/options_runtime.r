options <- list(
	global_dir = if (!internal) {
	    file.path(Sys.getenv("HOME"), "rapp")
	} else {
	    file.path(Sys.getenv("HOME"), "rapp", basename(getwd()))
	},
	wd = getwd(),
	runtime_mode = "dev",
	lib = .libPaths()[1]
)
