# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

PYTHON_COMPAT=( python3_{9..12} )

inherit mate python-single-r1

if [[ "${PV}" != *9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="A set of plugins for Pluma, the MATE text editor."
LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"

IUSE="+python bracketcompletion codecomment smartspaces synctex terminal"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	bracketcompletion? ( python )
	codecomment? ( python )
	smartspaces? ( python )
	synctex? ( python )
	terminal? ( python )
"

RDEPEND="
	dev-libs/libpeas[gtk]
	app-editors/gedit

	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/gtksourceview:4

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-editors/gedit[python,${PYTHON_SINGLE_USEDEP}]
			dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pycairo[${PYTHON_USEDEP}]
			dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		')
		x11-libs/gtk+:3[introspection]
		x11-libs/gtksourceview:4[introspection]
		x11-libs/pango[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
		synctex? ( dev-python/dbus-python )
		terminal? ( x11-libs/vte:2.91[introspection] )
	)
"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_install() {
	mate_src_install
	use python && python_optimize "${ED}/usr/$(get_libdir)/gedit/plugins/"
}
