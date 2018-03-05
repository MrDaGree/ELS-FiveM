outputLoading = false

vcf_files = {
	"POLICE.xml",
	"POLICE2.xml",
	"POLICE3.xml",
	"POLICE4.xml",
	"PRANGER.xml",
	"SHERIFF2.xml",
	"AMBULANCE.xml",
	"FBI2.xml",
	"SADLER.xml"
}

pattern_files = {
	"WIGWAG.xml",
	"WIGWAG3.xml",
	"FAST.xml",
	"COMPLEX.xml",
	"BACKFOURTH.xml",
	"BACKFOURTH2.xml",
	"T_ADVIS_RIGHT_LEFT.xml",
	"T_ADVIS_LEFT_RIGHT.xml",
	"T_ADVIS_BACKFOURTH.xml",
	"WIGWAG5.xml",
	"CHP.xml",
	"T_ADVIS_ARRW_LEFT.xml",
	"T_ADVIS_ARRW_LLEFT.xml",
	"T_ADVIS_ARRW_RIGHT.xml",
	"T_ADVIS_ARRW_RRIGHT.xml"
}

modelsWithFireSiren = {
    "FIRETRUK",
}


modelsWithAmbWarnSiren =
{   
    "AMBULANCE",
    "FIRETRUK",
    "LGUARD",
}

stagethreewithsiren = false
playButtonPressSounds = true
vehicleStageThreeAdvisor = {
    "FBI2",
    "AMBULANCE",
}


vehicleSyncDistance = 150
envirementLightBrightness = 0.2

build = "development"
panelOffsetX = 0.0
panelOffsetY = 0.0

shared = {
	horn = 86,
}

keyboard = {
	modifyKey = 132,
	stageChange = 311,
	guiKey = 243,
	takedown = 182,
	siren = {
		tone_one = 157,
		tone_two = 158,
		tone_three = 160,
		dual_toggle = 164,
		dual_one = 165,
		dual_two = 159,
		dual_three = 161,
	},
	pattern = {
		primary = 82,
		secondary = 81,
		advisor = 70,
	},
}

controller = {
	modifyKey = 73,
	stageChange = 80,
	takedown = 74,
	siren = {
		tone_one = 173,
		tone_two = 85,
		tone_three = 172,
	},
}