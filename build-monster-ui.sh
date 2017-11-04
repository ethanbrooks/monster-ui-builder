#!/bin/bash -l

set -e


function version-for {
	local _vstr=MONSTER_APP_${app^^}_VERSION
	local version=${!_vstr}
	echo "$version"
}



log::m-info "Installing Monster-UI v$MONSTER_UI_VERSION"
git clone -b $MONSTER_UI_VERSION --single-branch --depth 1 \
    https://github.com/2600hz/monster-ui monster-ui
pushd $_
	log::m-info  "Installing monster-ui apps ..."
    pushd src/apps
        for app in ${MONSTER_APPS//,/ }; do
			log::m-info "Installing app: $app v$(version-for $app) ..."
            git clone -b $(version-for $app) --single-branch \
                --depth 1 https://github.com/2600hz/monster-ui-${app} \
                $app
        done
        popd
    npm install
    gulp build-prod

    npm uninstall
    find -mindepth 1 -maxdepth 1 -not -name dist -exec rm -rf {} \;
    mv dist/* .
    rm -rf dist

    log::m-info "Downloading pdf's from 2600hz ..."
    curl -sSL -o Editable.LOA.Form.pdf \
        http://ui.zswitch.net/Editable.LOA.Form.pdf
    curl -sSL -o Editable.Resporg.Form.pdf \
        http://ui.zswitch.net/Editable.Resporg.Form.pdf
    chmod 0777 *.pdf

	popd



log::m-info "Packaging time!"

for app in ${MONSTER_APPS//,/ }; do
	log::m-info "Packaging $app v$(version-for $app) ..."
	mkdir -p /tmp/monster-ui-app-${app}_$(version-for $app)
	pushd $_
		mkdir -p var/www/html/monster-ui/apps
		mv /build/monster-ui/apps/$app $_

		mkdir DEBIAN
		tee DEBIAN/control <<EOF
Package: monster-ui-app-$app
Version: $(version-for $app)
Architecture: amd64
Depends: monster-ui (= $MONSTER_UI_VERSION)
Maintainer: Joe Black <me@joeblack.nyc>
Description: The $app app for Monster-UI.

EOF

		tee DEBIAN/postinst <<EOF
#!/bin/sh

set -e

case "\$1" in
configure)
	! getent passwd monster-ui > /dev/null 2&>1 && adduser --system --no-create-home --gecos "MonsterUI" --group monster-ui
	chown -R monster-ui: /var/www/html/monster-ui/apps/$app
	;;
esac

exit 0
EOF
		chmod 0755 DEBIAN/postinst
		cd ..

		dpkg-deb --build monster-ui-app-${app}_$(version-for $app)
		popd
done


mkdir -p /tmp/monster-ui_$MONSTER_UI_VERSION
pushd $_
	mkdir -p var/www/html
	mv /build/monster-ui $_

	mkdir DEBIAN
	tee DEBIAN/control <<EOF
Package: monster-ui
Version: $MONSTER_UI_VERSION
Architecture: amd64
Maintainer: Joe Black <me@joeblack.nyc>
Description: The $app app for Monster-UI.
 This package installs Monster-UI to /var/www/html/monster-ui.
EOF

	tee DEBIAN/postinst <<EOF
#!/bin/sh

set -e

case "\$1" in
configure)
! getent passwd monster-ui > /dev/null 2&>1 && adduser --system --no-create-home --gecos "MonsterUI" --group monster-ui
chown -R monster-ui: /var/www/html/monster-ui
;;
esac

exit 0
EOF
	chmod 0755 DEBIAN/postinst
	cd ..

	dpkg-deb --build monster-ui_$MONSTER_UI_VERSION
	popd


log::m-info "Moving debs to /dist ..."
mv /tmp/*.deb /dist


log::m-info "Creating archive for debs ..."
cd /dist
	tar czvf monster-ui-debs-all.tar.gz *.deb
