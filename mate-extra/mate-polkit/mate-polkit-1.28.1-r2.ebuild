# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

# MATE uses an odd/even numbering system for release and dev builds
MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="A MATE specific DBUS service that is used to bring up authentication dialogs"
HOMEPAGE="https://github.com/mate-desktop/mate-polkit"

SRC_URI="
	https://github.com/mate-desktop/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${PN}-${PV}"

LICENSE="LGPL-2"
SLOT="0"

IUSE="accountsservice appindicator"

COMMON_DEPEND="x11-libs/gdk-pixbuf:2
	virtual/libintl:0
	>=x11-libs/gtk+-3.22.0:3
	appindicator? ( dev-libs/libayatana-appindicator )"

RDEPEND="${COMMON_DEPEND}
	>=dev-libs/glib-2.50:2
	>=sys-auth/polkit-0.102[daemon(+)]
	accountsservice? ( sys-apps/accountsservice )"

BDEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	>=dev-util/intltool-0.35
	sys-devel/gettext
	>=dev-build/libtool-2.2.6
	virtual/pkgconfig"

PATCHES=(
		"${FILESDIR}"/${PN}-1.28.1-appindicator.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use accountsservice)
		$(meson_use appindicator)
	)
	meson_src_configure
}
