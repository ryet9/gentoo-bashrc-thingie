#!/bin/sh
#
#	Spin up & slow down fans with Corsair Hydro..Gentoo
#	requires app-misc/liquidctl
#	slightly specific use case...
#	/etc/portage/bashrc
#

#	Min / Max fan speed variables
fanspeed_MIN="40"
fanspeed_MAX="100"

#	Spin fans UP to fanspeed_MAX @ setup phase of emerge
if [ "${EBUILD_PHASE}" == "setup" ]
then
	liquidctl --match hydro set fan speed $fanspeed_MAX
	liquidctl --match hydro set pump speed 100
	echo "Spinning up FANS 🌬️💨🌫 🥶"
fi

#	Spin fans DOWN to fanspeed_MIN @ end of emerge phase
if [ "${EBUILD_PHASE}" == "postinst" ]
then
	liquidctl --match hydro set fan speed $fanspeed_MIN
	echo "Spinning down FANS 🤫️ 🔇"
fi
