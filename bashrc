function j {
	cd `jaunte-jump $1`
}
function jd {
	cd $1 && jaunte-append
}
alias cd=jd