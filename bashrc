#!/bin/sh
#
#	Spin up & slow down fans with Asetek CLC..Gentoo
#	requires app-misc/liquidctl sys-apps/lm-sensors
#	slightly specific use case...mine fuckers!
#	/etc/portage/bashrc
#

#	Min / Max FAN speed variables
fanspeed_MIN="40"
fanspeed_MAX="100"

#	Min / Max PUMP speed variables
pumpspeed_MIN="100"
pumpspeed_MAX="100"

#	Sleep time
sleep_time="9"

#	Spin fans UP to fanspeed_MAX & pumpspeed_MAX @ setup phase of emerge
if [ "${EBUILD_PHASE}" == "setup" ]
then
	sensors | grep -i package | sed 's/+//g' | echo CPU Temp  `awk '{print $4}'`
	free -t  --giga | grep -i mem | echo `awk '{print $6}'`GiB Free
	liquidctl --match Asetek set fan speed $fanspeed_MAX
	liquidctl --match Asetek set pump speed $pumpspeed_MAX
	echo "Spinning up FANS 🌬️💨🌫 🥶 $fanspeed_MAX%"
	sleep $sleep_time
	sensors | grep -i package | sed 's/+//g' | echo CPU Temp  `awk '{print $4}'`
fi

#	Spin fans DOWN to fanspeed_MIN & pumpspeed_MIN @ end of emerge phase
if [ "${EBUILD_PHASE}" == "postinst" ]
then
	sensors | grep -i package | sed 's/+//g' | echo CPU Temp  `awk '{print $4}'`
	echo "Waiting $sleep_time seconds to slow fans..."
	sleep $sleep_time
	echo "Spinning down FANS 🤫️ 🔇 $fanspeed_MIN%"
	sleep $sleep_time
	sensors | grep -i package | sed 's/+//g' | echo CPU Temp  `awk '{print $4}'`
	liquidctl --match Asetek set fan speed $fanspeed_MIN
	liquidctl --match Asetek set pump speed $pumpspeed_MIN
fi
