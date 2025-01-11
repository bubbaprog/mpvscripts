#!/bin/zsh

epochtime=`date +%Y-%m-%d_%H-%M-%S`
channel="1009"
channel="$1"
tuner=1
tuner="$2"

screenx=1
locationx=1
screenx="$3"
locationx="$4"
screeny=(
"DP-0"
"DP-3"
"HDMI-0"
"DP-5"
)

if [ $screenx = "3" ]; then
	locationy=(
	"0%:0%"
	"50%:0%"
	"100%:0%"
	"0%:50%"
	"50%:50%"
	"100%:50%"
	"0%:100%"
	"50%:100%"
	"100%:100%"
	);
	afit="640x360"
else
	locationy=(
	"0%:0%"
	"100%:0%"
	"0%:100%"
	"100%:100%"
	);
	afit="50%"
fi

if [[ "$tuner" == 1 ]]; then
        hdhr="131d3b35"
elif [[ "$tuner" == 2 ]]; then
        hdhr="13183573"
elif [[ "$tuner" == 3 ]]; then
        hdhr="13179e3e"
elif [[ "$tuner" == 4 ]]; then
        hdhr="10a0dcec"
fi
streamlink httpstream://http://hdhr-$hdhr\:5004/auto/v$1 -r $epochtime\_$1.ts -a "--quiet --border=no --hwdec=nvdec --mute=yes  --screen-name=${screeny[$screenx]} --geometry=${locationy[$locationx]} --autofit=$afit"
