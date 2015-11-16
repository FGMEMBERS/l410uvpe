#
# L410 - global nasal file
#
# Javky <javky@email.cz>
#

# Initialization

setprop("/instrumentation/nav[1]/nav-freq-displ",getprop("/instrumentation/nav[1]/frequencies/selected-mhz"));
setprop("/instrumentation/nav[1]/nav-wpt-freq[0]",getprop("/instrumentation/nav[1]/frequencies/selected-mhz"));

srand();

# Functions

deg_to_rad = 0.0174533;

modulo = func {
	r = arg[0] / arg[1];
	i = int (r);
	r = r - i;
	r = r * arg[1];
	return r;
}

check_diff = func {
	base=arg[0]; goal=arg[1]; max=arg[2]; min=arg[3];
    if (goal == nil) { goal = 0; }
    if (base == nil) { base = 0; }
	diff=goal-base;

	if (diff > 180 ) { diff=diff-360; }
	if (-180 > diff ) { diff=diff+360; }
	if (diff > max) {diff=max};
	if (min > diff) {diff=min};

	diff=diff/4.0;
	base = base+diff;
	if (base > 360 ) { base=base-360; }
	if (0 > base ) { base=base+360; }

	return base;
}

check_norm_diff = func {
	base=arg[0]; goal=arg[1]; max=arg[2]; min=arg[3];
    if (goal == nil) { goal = 0; }
    if (base == nil) { base = 0; }
	diff=goal-base;

	if (diff > max) {diff=max};
	if (min > diff) {diff=min};

	diff=diff/4.0;
	base = base+diff;

	if (base<0) { base=0; }

	return base;
}

check_basic_diff = func {
	base=arg[0]; goal=arg[1]; max=arg[2]; min=arg[3];
    if (goal == nil) { goal = 0; }
    if (base == nil) { base = 0; }
	diff=goal-base;

	if (diff > max) {diff=max};
	if (min > diff) {diff=min};

	diff=diff/4.0;
	base = base+diff;

	return base;
}


update_central_warning_display = func {
    
# Part electro

    if (getprop("/controls/switches/battery1-sw") != 1 or
        getprop("/systems/health/battery1-ok") != 1 or
        getprop("/controls/switches/battery2-sw") != 1 or
        getprop("/systems/health/battery2-ok") != 1 ) {
             setprop ("/instrumentation/warn-disp/wd-battery",1);
    } else { setprop ("/instrumentation/warn-disp/wd-battery",0); }

    if (getprop("/systems/electrical/outputs/bus28v1") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-generator1",1);
    } else { setprop ("/instrumentation/warn-disp/wd-generator1",0); }
    if (getprop("/systems/electrical/outputs/bus28v2") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-generator2",1);
    } else { setprop ("/instrumentation/warn-disp/wd-generator2",0); }

    if (getprop("/systems/electrical/outputs/bus-alt115v1") < 90 ) {
             setprop ("/instrumentation/warn-disp/wd-alternator1",1);
    } else { setprop ("/instrumentation/warn-disp/wd-alternator1",0); }
    if (getprop("/systems/electrical/outputs/bus-alt115v2") < 90 ) {
             setprop ("/instrumentation/warn-disp/wd-alternator2",1);
    } else { setprop ("/instrumentation/warn-disp/wd-alternator2",0); }

    if (getprop("/systems/electrical/outputs/bus36v1") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-lun2450-1",1);
    } else { setprop ("/instrumentation/warn-disp/wd-lun2450-1",0); }
    if (getprop("/systems/electrical/outputs/bus36v2") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-lun2450-2",1);
    } else { setprop ("/instrumentation/warn-disp/wd-lun2450-2",0); }

    if (getprop("/systems/electrical/outputs/bus115v1") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-pc250-1",1);
    } else { setprop ("/instrumentation/warn-disp/wd-pc250-1",0); }
    if (getprop("/systems/electrical/outputs/bus115v2") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-pc250-2",1);
    } else { setprop ("/instrumentation/warn-disp/wd-pc250-2",0); }

    if (getprop("/systems/electrical/outputs/attitude-indicator-gyro[0]") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-horizon-lh",1);
    } else { setprop ("/instrumentation/warn-disp/wd-horizon-lh",0); }
    if (getprop("/systems/electrical/outputs/attitude-indicator-gyro[1]") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-horizon-rh",1);
    } else { setprop ("/instrumentation/warn-disp/wd-horizon-rh",0); }
    if (getprop("/systems/electrical/outputs/attitude-indicator-gyro[2]") < 20 ) {
             setprop ("/instrumentation/warn-disp/wd-horizon-stby",1);
    } else { setprop ("/instrumentation/warn-disp/wd-horizon-stby",0); }

    if (getprop("/systems/electrical/outputs/deicing-stall") < 20 or
        getprop("/systems/electrical/outputs/deicing-static1") < 20 or
        getprop("/systems/electrical/outputs/deicing-static2") < 20 or
        getprop("/systems/electrical/outputs/deicing-pitot1") < 20 or
        getprop("/systems/electrical/outputs/deicing-pitot2") < 20)
    {
        setprop ("/instrumentation/warn-disp/wd-pitot-heat",1);
    } else {
        setprop ("/instrumentation/warn-disp/wd-pitot-heat",0);
    }

# Part airframe

    if (getprop("/surface-positions/spoilers-pos-norm") > 0 ) {
             setprop ("/instrumentation/warn-disp/wd-spoiler",1);
    } else { setprop ("/instrumentation/warn-disp/wd-spoiler",0); }

    if ((getprop("/gear/gear[0]/position-norm") < 1 and
         getprop("/gear/gear[1]/position-norm") < 1 and 
         getprop("/gear/gear[2]/position-norm") < 1) and
       ((getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") < 111 and
         getprop("/controls/engines/engine[0]/throttle") < 0.1 and
         getprop("/controls/engines/engine[1]/throttle") < 0.1) or
        (getprop("/surface-positions/flap-pos-norm") == 1)
       )
    ) {
             setprop ("/instrumentation/warn-disp/wd-extendgear",1);
    } else { setprop ("/instrumentation/warn-disp/wd-extendgear",0); }

    if (
         ( getprop("/gear/gear[0]/position-norm") == 1 or 
           getprop("/gear/gear[1]/position-norm") == 1 or 
           getprop("/gear/gear[2]/position-norm") == 1 ) and
         getprop("/surface-positions/flap-pos-norm") < 0.45 and
       (
        ( getprop("/controls/engines/engine[0]/throttle") < 0.75 and
          getprop("/controls/engines/engine[1]/throttle") < 0.75 and
          getprop("/position/altitude-agl-ft") > 10 )
        or
        ( getprop("/environment/temperature-degc") > 27 and
          getprop("/position/altitude-agl-ft") < 15 and
          ( getprop("/engines/engine[0]/running") == 1 or
            getprop("/engines/engine[1]/running") == 1 )
        )
      )
      ) {
             setprop ("/instrumentation/warn-disp/wd-flaps15",1);
    } else { setprop ("/instrumentation/warn-disp/wd-flaps15",0); }
        
    if (getprop ("/instrumentation/lights/search1-on") == 2 or
        getprop ("/instrumentation/lights/search2-on") >= 1
    ) {
             setprop ("/instrumentation/warn-disp/wd-searchlgh",1);
    } else { setprop ("/instrumentation/warn-disp/wd-searchlgh",0); }

    if (getprop("/controls/switches/full-steering-sw") == 0 ) {
             setprop ("/instrumentation/warn-disp/wd-pedalsteering",1);
    } else { setprop ("/instrumentation/warn-disp/wd-pedalsteering",0); }
    if (getprop("/controls/switches/full-steering-sw") == 2 ) {
             setprop ("/instrumentation/warn-disp/wd-manualsteering",1);
    } else { setprop ("/instrumentation/warn-disp/wd-manualsteering",0); }

    if (getprop("systems/electrical/outputs/abc") > 1 and
        getprop("/engines/abc-timer") >= 5.7 ) {
       setprop("/instrumentation/warn-disp/wd-autbank-g",1);
    } else { setprop ("/instrumentation/warn-disp/wd-autbank-g",0); }
    if (getprop("/controls/engines/aileron-abc-norm") > 0.001 or 
        getprop("/controls/engines/aileron-abc-norm") < -0.001) {
       setprop("/instrumentation/warn-disp/wd-autbank-y",1);
    } else { setprop ("/instrumentation/warn-disp/wd-autbank-y",0); }

    if (getprop("/surface-positions/door-rear-pos-norm") > 0.001) {
       setprop("/instrumentation/warn-disp/wd-door",1);
    } else { setprop ("/instrumentation/warn-disp/wd-door",0); }

    #if (getprop("/environment/icing/watter-will-froze")==1 and getprop("/environment/icing/watteramount")>0) {
    #   setprop("/instrumentation/warn-disp/wd-icing",1);
    #} else { setprop ("/instrumentation/warn-disp/wd-icing",0); }

# Part Engines (both)

    if (getprop("/instrumentation/pressure/indicated-fuel1-kp_cm2") < 3.5 ) {
       setprop("/instrumentation/warn-disp/wde1-fuelpress",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-fuelpress",0); }
    if (getprop("/instrumentation/pressure/indicated-fuel2-kp_cm2") < 3.5 ) {
       setprop("/instrumentation/warn-disp/wde2-fuelpress",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-fuelpress",0); }

    if (getprop("/instrumentation/pressure/indicated-oil1-kp_cm2") < 1.3 ) {
       setprop("/instrumentation/warn-disp/wde1-oilpress",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-oilpress",0); }
    if (getprop("/instrumentation/pressure/indicated-oil2-kp_cm2") < 1.3 ) {
       setprop("/instrumentation/warn-disp/wde2-oilpress",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-oilpress",0); }

    if (getprop("/controls/switches/isolvalve2-sw") == 2 or
        (getprop("/engines/autofeather-ielublock-lh")== 0 and 
         getprop("/engines/autofeather-block-lh") ==0  and 
         getprop("/engines/autofeather-block-rh") ==0 )) {
       setprop("/instrumentation/warn-disp/wde2-isolval",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-isolval",0); }
    if (getprop("/controls/switches/isolvalve1-sw") == 2 or
        (getprop("/engines/autofeather-ielublock-rh")== 0 and
         getprop("/engines/autofeather-block-lh") ==0  and 
         getprop("/engines/autofeather-block-rh") ==0 )) {
       setprop("/instrumentation/warn-disp/wde1-isolval",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-isolval",0); }

	if (getprop("controls/switches/fuelcross-sw") and
		getprop("systems/electrical/outputs/bus28v") > 0 ) {
       setprop("/instrumentation/warn-disp/wd-fuelcross",1);
    } else { setprop ("/instrumentation/warn-disp/wd-fuelcross",0); }

    if (getprop("/instrumentation/engine/indicated-fuel1-kg") < 80 ) {
       setprop("/instrumentation/warn-disp/wde1-minfuel",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-minfuel",0); }
    if (getprop("/instrumentation/engine/indicated-fuel2-kg") < 80 ) {
       setprop("/instrumentation/warn-disp/wde2-minfuel",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-minfuel",0); }

    if (getprop("/engines/engine[0]/starting") == 1 ) {
       setprop("/instrumentation/warn-disp/wde1-start",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-start",0); }
    if (getprop("/engines/engine[1]/starting") == 1 ) {
       setprop("/instrumentation/warn-disp/wde2-start",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-start",0); }

    if (getprop("/engines/engine[0]/ielu-intervent") == 1 ) {
       setprop("/instrumentation/warn-disp/wde1-ieluint",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-ieluint",0); }
    if (getprop("/engines/engine[1]/ielu-intervent") == 1 ) {
       setprop("/instrumentation/warn-disp/wde2-ieluint",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-ieluint",0); }

    if (getprop("/engines/engine[0]/feather-pump-running") == 1 ) {
       setprop("/instrumentation/warn-disp/wde1-featpump",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-featpump",0); }
    if (getprop("/engines/engine[1]/feather-pump-running") == 1 ) {
       setprop("/instrumentation/warn-disp/wde2-featpump",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-featpump",0); }

    if (getprop("systems/electrical/outputs/feather-pump-lh") > 1 and
        getprop("/engines/autofeather-timer") >= 6 ) {
       setprop("/instrumentation/warn-disp/wde1-autofeat",1);
    } else { setprop ("/instrumentation/warn-disp/wde1-autofeat",0); }
    if (getprop("systems/electrical/outputs/feather-pump-rh") > 1 and
        getprop("/engines/autofeather-timer") >= 6 ) {
       setprop("/instrumentation/warn-disp/wde2-autofeat",1);
    } else { setprop ("/instrumentation/warn-disp/wde2-autofeat",0); }

    # Other
    if (getprop("/orientation/roll-deg") > 45 ) {
       setprop("/instrumentation/warn-disp/wd-bank-r",1);
    } else { setprop ("/instrumentation/warn-disp/wd-bank-r",0); }
    if (getprop("/orientation/roll-deg") < -45 ) {
       setprop("/instrumentation/warn-disp/wd-bank-l",1);
    } else { setprop ("/instrumentation/warn-disp/wd-bank-l",0); }

}

update_itt = func {
    base = getprop("/engines/engine[0]/itt_degC");
    goal = (getprop("/engines/engine[0]/itt_degf")-32)/1.8;
	setprop("/engines/engine[0]/itt_degC",check_norm_diff(base,goal,100,-100));
    base = getprop("/engines/engine[1]/itt_degC");
    goal = (getprop("/engines/engine[1]/itt_degf")-32)/1.8;
	setprop("/engines/engine[1]/itt_degC",check_norm_diff(base,goal,100,-100));
    
}

update_fuel_pressure = func {
    base = getprop("/instrumentation/pressure/indicated-fuel1-kp_cm2");
    if (getprop("/systems/electrical/outputs/fuelpump-lh") > 1) {
        goal = 9;
    } else {
        alt = getprop("/position/altitude-ft");
        goal = 5 * (7500 - alt) / 7500;
        if (goal < 0) { goal = 0; }
    }
    if (getprop("/controls/engines/engine[0]/cutoff-cmd") == 1 or 
        getprop("/controls/engines/engine[0]/cutoff-emerg-cmd") == 1 ) { goal = 0; }
	setprop("/instrumentation/pressure/indicated-fuel1-kp_cm2",check_norm_diff(base,goal,100,-100));

    base = getprop("/instrumentation/pressure/indicated-fuel2-kp_cm2");
    if (getprop("/systems/electrical/outputs/fuelpump-rh") > 1) {
        goal = 9;
    } else {
        alt = getprop("/position/altitude-ft");
        goal = 5 * (7500 - alt) / 7500;
        if (goal < 0) { goal = 0; }
    }
    if (getprop("/controls/engines/engine[1]/cutoff-cmd") == 1 or
        getprop("/controls/engines/engine[1]/cutoff-emerg-cmd") == 1) { goal = 0; }
	setprop("/instrumentation/pressure/indicated-fuel2-kp_cm2",check_norm_diff(base,goal,100,-100));
}

update_oil_pressure = func {
    base = getprop("/instrumentation/pressure/indicated-oil1-kp_cm2");
    goal = getprop("/engines/engine[0]/oil-pressure-psi") * 0.07692 ;
	setprop("/instrumentation/pressure/indicated-oil1-kp_cm2",check_norm_diff(base,goal,100,-100));

    base = getprop("/instrumentation/pressure/indicated-oil2-kp_cm2");
    goal = getprop("/engines/engine[1]/oil-pressure-psi") * 0.07692 ;
	setprop("/instrumentation/pressure/indicated-oil2-kp_cm2",check_norm_diff(base,goal,100,-100));

}


update_radio_alt = func {
    base = getprop("/instrumentation/altimeter-rad/indicated-rad-alt");
    if (getprop("/systems/electrical/outputs/radioaltimeter") > 1 ) {
        if (getprop("/instrumentation/altimeter-rad/test-sw") == 0 ) {
            goal = getprop("/position/altitude-agl-ft");
        } else {
            goal = 150;
        }
        if (base < getprop("/instrumentation/altimeter-rad/lowest-ft")) {
            setprop("/instrumentation/altimeter-rad/signal-on",1);
        } else {
            setprop("/instrumentation/altimeter-rad/signal-on",0);
        }
    } else { 
        goal = 0; 
        setprop("/instrumentation/altimeter-rad/signal-on",0);
    }
    if (goal > 4000) { goal = 4000; }
	setprop("/instrumentation/altimeter-rad/indicated-rad-alt",check_norm_diff(base,goal,1000,-1000));
}

update_brakes = func {
    pressure_coef = getprop("/systems/hydraulic/brakes-pressure-MPa") / 4.5;
    if (pressure_coef > 1) { pressure_coef = 1.0; }
    
    setprop("/controls/gear/wheel[0]/brake-cmd-cond",getprop("/controls/gear/wheel[0]/brake-cmd")*pressure_coef);
    setprop("/controls/gear/wheel[1]/brake-cmd-cond",getprop("/controls/gear/wheel[1]/brake-cmd")*pressure_coef);
    setprop("/controls/gear/wheel[2]/brake-cmd-cond",getprop("/controls/gear/wheel[2]/brake-cmd")*pressure_coef);
}

update_trims = func {
    if (getprop("/systems/electrical/outputs/trim-tabs")>20) {
        setprop("/controls/flight/aileron-trim-servo",getprop("/controls/flight/aileron-trim"));
        setprop("/controls/flight/rudder-trim-servo",getprop("/controls/flight/rudder-trim"));
    } else {
        setprop("/controls/flight/aileron-trim",getprop("/controls/flight/aileron-trim-servo"));
        setprop("/controls/flight/rudder-trim",getprop("/controls/flight/rudder-trim-servo"));
    }   
}

update_instruments_calculated_values = func {
    setprop("/instrumentation/nav[0]/heading-magnetic",getprop("/instrumentation/nav[0]/heading-deg")-getprop("/environment/magnetic-variation-deg"));
    setprop("/instrumentation/nav[1]/heading-magnetic",getprop("/instrumentation/nav[1]/heading-deg")-getprop("/environment/magnetic-variation-deg"));
}

#
# 10ms update
#
update10ms = func {

    update_itt();
    update_fuel_pressure();
    update_oil_pressure();
    
    update_radio_alt();
    
    update_brakes();
    
    update_trims();
    
    update_instruments_calculated_values();
	settimer ( update10ms , 0.01 );
};
setprop("/engines/engine[0]/itt_degf",50);
setprop("/engines/engine[0]/ITT_degC",15);
setprop("/engines/engine[1]/itt_degf",50);
setprop("/engines/engine[1]/ITT_degC",15);

setprop("/instrumentation/nav[0]/heading-deg",0);
setprop("/instrumentation/nav[1]/heading-deg",0);
settimer ( update10ms , 10 );


update_nav2_is_ils_freq = func {
    frq=getprop("/instrumentation/nav[1]/nav-freq-displ");
    frq = frq - int(frq);
    
    if (getprop("/instrumentation/nav[1]/nav-freq-displ") < 112.00 and
        ((frq >= 0.09 and frq <= 0.11) or (frq >= 0.14 and frq <= 0.16) or
         (frq >= 0.29 and frq <= 0.31) or (frq >= 0.34 and frq <= 0.36) or
         (frq >= 0.49 and frq <= 0.51) or (frq >= 0.54 and frq <= 0.56) or
         (frq >= 0.69 and frq <= 0.71) or (frq >= 0.74 and frq <= 0.76) or
         (frq >= 0.89 and frq <= 0.91) or (frq >= 0.94 and frq <= 0.96))) {
        setprop("/instrumentation/nav[1]/nav-freq-is-ils-freq",1);
    } else {
        setprop("/instrumentation/nav[1]/nav-freq-is-ils-freq",0);
    }
    #    setprop("/instrumentation/nav[1]/nav-freq-is-ils-freq",frq);
}

nav2_radio_was_check = 0;
nav2_radio_tmp_rad = 5;
nav2_radio_tmp_dst = 4;
update_nav2_radio_check = func {
    if (getprop("/instrumentation/nav[1]/nav-chck-btn") == 1 and nav2_radio_was_check == 0) {
        nav2_radio_was_check = 1;
        nav2_radio_tmp_rad = getprop("/instrumentation/nav[1]/nav-rad-displ");
        nav2_radio_tmp_dst = getprop("/instrumentation/nav[1]/nav-dist-displ");
    }
    if (getprop("/instrumentation/nav[1]/nav-chck-btn") == 0 and nav2_radio_was_check == 1) {
        nav2_radio_was_check = 0;
        setprop("/instrumentation/nav[1]/nav-rad-displ",nav2_radio_tmp_rad);
        setprop("/instrumentation/nav[1]/nav-dist-displ",nav2_radio_tmp_dst);
    }
    if (getprop("/instrumentation/nav[1]/nav-chck-btn") == 1) {
        if (getprop("/instrumentation/nav[1]/in-range") == 1) {
            if (getprop("/instrumentation/nav[1]/heading-magnetic") < 180) {
                setprop("/instrumentation/nav[1]/nav-rad-displ",getprop("/instrumentation/nav[1]/heading-magnetic")+180.0);
            } else {
                setprop("/instrumentation/nav[1]/nav-rad-displ",getprop("/instrumentation/nav[1]/heading-magnetic")-180.0);
            }
        } else {
            setprop("/instrumentation/nav[1]/nav-rad-displ",-1);
        }
        if (getprop("/instrumentation/dme[1]/in-range") == 1) {
            setprop("/instrumentation/nav[1]/nav-dist-displ",getprop("/instrumentation/dme[1]/indicated-distance-nm"));
        } else {
            setprop("/instrumentation/nav[1]/nav-dist-displ",-1);
        }
    }
}

update_nav_goals = func {
	
	max_needle_speed = 30;
	
	#
	# NAV 1 (only 1 mode)
	#
	goal=getprop("/instrumentation/nav[0]/heading-needle-deflection");
	base=getprop("/instrumentation/nav[0]/indicated-heading-deflection");
	setprop("/instrumentation/nav[0]/indicated-heading-deflection",check_basic_diff(base,goal,max_needle_speed,-max_needle_speed));
	setprop("/instrumentation/nav[0]/indicated-heading-deflection-goal",goal);

	goal=getprop("/instrumentation/nav[0]/gs-needle-deflection");
	if (goal>2) {goal=2;}
	if (goal<-2) {goal=-2;}
	base=getprop("/instrumentation/nav[0]/indicated-gs-deflection");
    if (!(base > -91 and base < 91)) { base = 0; }
	setprop("/instrumentation/nav[0]/indicated-gs-deflection",check_basic_diff(base,goal,max_needle_speed/4,-max_needle_speed/4));
	
	setprop("/instrumentation/nav[0]/indicated-in-range",getprop("/instrumentation/nav[0]/in-range"));

    #
	# NAV 2 (4 modes)
	#
	
	# VOR mode [max 10 deg, min -10 deg]
	if (getprop("/instrumentation/nav[1]/nav-mode") == 0) {
		goal=getprop("/instrumentation/nav[1]/heading-needle-deflection");
		setprop("/instrumentation/nav[1]/indicated-in-range",getprop("/instrumentation/nav[1]/in-range"));
		setprop("/instrumentation/nav[1]/indicated-to-flag",getprop("/instrumentation/nav[1]/to-flag"));
		setprop("/instrumentation/nav[1]/indicated-from-flag",getprop("/instrumentation/nav[1]/from-flag"));
	}
	
	# VOR-PAR mode [max 10 = 5 NM, min -10 = 5NM]
	if (getprop("/instrumentation/nav[1]/nav-mode") == 1) {
		goal=getprop("/instrumentation/nav[1]/crosstrack-error-m") * 0.00107527;
		setprop("/instrumentation/nav[1]/indicated-in-range",getprop("/instrumentation/nav[1]/in-range"));
		setprop("/instrumentation/nav[1]/indicated-to-flag",getprop("/instrumentation/nav[1]/to-flag"));
		setprop("/instrumentation/nav[1]/indicated-from-flag",getprop("/instrumentation/nav[1]/from-flag"));
	}
	
	# RNAV mode (+RNAV-APR mode) [max 10 = 5 NM, min -10 = 5NM]
	if (getprop("/instrumentation/nav[1]/nav-mode") >= 2) {
	
		if (getprop("/instrumentation/nav[1]/in-range")==0 or getprop("/instrumentation/dme[1]/in-range")==0 or getprop("/instrumentation/dme[1]/switch-position")==2) {
			setprop("/instrumentation/nav[1]/indicated-in-range",0);
			goal=0;
			setprop("/instrumentation/nav[1]/indicated-to-flag",0);
			setprop("/instrumentation/nav[1]/indicated-from-flag",0);
		} else {
			setprop("/instrumentation/nav[1]/indicated-in-range",1);
			l_dist = getprop("/instrumentation/nav[1]/nav-wpt-dist["~getprop("/instrumentation/nav[1]/nav-wpt-active")~"]");
			l_dme = getprop("/instrumentation/dme[1]/indicated-distance-nm");
			r_fantom = getprop("/instrumentation/nav[1]/nav-wpt-rad["~getprop("/instrumentation/nav[1]/nav-wpt-active")~"]");
			r_let = getprop("/instrumentation/nav[1]/heading-magnetic");
			r_sel = getprop("/instrumentation/nav[1]/radials/selected-deg");

			delta = 180 - (r_fantom - r_let);
			l_wp = math.sqrt (l_dist*l_dist + l_dme*l_dme - 2 * l_dist * l_dme * math.cos(delta*deg_to_rad));
			
			xtrack_err = getprop("/instrumentation/nav[1]/crosstrack-error-m");
			goal = (xtrack_err + math.sin( (r_fantom-r_sel) * deg_to_rad) * (l_dist*1860)) * 0.00107527;

			x = (l_dme*l_dme + l_wp*l_wp - l_dist*l_dist)/(2*l_dme*l_wp);
			if (x>-1 and x<1) {
				alfa_t = math.atan2(1,x/math.sqrt(1-x*x));
			} else {
				if (x==1) {
					alfa_t=0;
				} else {
					alfa_t=3.14159266;
				}
			}
			alfa_t = alfa_t / deg_to_rad;
			
			if (r_fantom>=180) {
				if ((r_let<r_fantom) and (r_let>(r_fantom-180))) {
					true_r_wp = r_let + alfa_t;
				} else {
					true_r_wp = r_let - alfa_t;
				}
			} else {
				if ((r_let<r_fantom) or (r_let>(180+r_fantom))) {
					true_r_wp = r_let + alfa_t;
				} else {
					true_r_wp = r_let - alfa_t;
				}
			}
			
			if (true_r_wp >= 360) { true_r_wp = true_r_wp - 360; }
			if (true_r_wp < 0) { true_r_wp = true_r_wp + 360; }

			setprop("/instrumentation/nav[1]/wpt-dist-nm",l_wp);
			setprop("/instrumentation/nav[1]/wpt-radto-deg",true_r_wp);
			
			delta_wpt_rad=r_sel-true_r_wp;
			if (delta_wpt_rad > 180) {delta_wpt_rad = delta_wpt_rad - 360;}
			if (delta_wpt_rad < -180) {delta_wpt_rad = delta_wpt_rad + 360;}
			if (delta_wpt_rad > -90 and delta_wpt_rad < 90) {
				setprop("/instrumentation/nav[1]/indicated-to-flag",1);
				setprop("/instrumentation/nav[1]/indicated-from-flag",0);
			} else {
				setprop("/instrumentation/nav[1]/indicated-to-flag",0);
				setprop("/instrumentation/nav[1]/indicated-from-flag",1);
			}
		}
	}
	
	#RNAV-APR mode (4 * more precision RNAV)
	if (getprop("/instrumentation/nav[1]/nav-mode") == 3) {
		goal = goal * 4;
	}

	#ILS mode
	if (getprop("/instrumentation/nav[1]/nav-loc")==1) {
		goal=getprop("/instrumentation/nav[1]/heading-needle-deflection");
		setprop("/instrumentation/nav[1]/indicated-in-range",getprop("/instrumentation/nav[1]/in-range"));
		setprop("/instrumentation/nav[1]/indicated-to-flag",getprop("/instrumentation/nav[1]/to-flag"));
		setprop("/instrumentation/nav[1]/indicated-from-flag",getprop("/instrumentation/nav[1]/from-flag"));
	}
	
	#OFF
	if (getprop("/instrumentation/nav[1]/indicated-in-range")==0) {
		goal=0;
		setprop("/instrumentation/nav[1]/indicated-to-flag",0);
		setprop("/instrumentation/nav[1]/indicated-from-flag",0);
	}
	
	
	
	#if not in-range display 0 deflection
	if (getprop("/instrumentation/nav[1]/in-range")==0) { 
		goal = 0; 
	}

	setprop("/instrumentation/nav[1]/indicated-heading-deflection-goal",goal);
	if (goal>10) {goal=10;}
	if (goal<-10) {goal=-10;}
	base=getprop("/instrumentation/nav[1]/indicated-heading-deflection");
	setprop("/instrumentation/nav[1]/indicated-heading-deflection",check_basic_diff(base,goal,max_needle_speed,-max_needle_speed));

	goal=getprop("/instrumentation/nav[1]/gs-needle-deflection");
	if (goal>2) {goal=2;}
	if (goal<-2) {goal=-2;}
	base=getprop("/instrumentation/nav[1]/indicated-gs-deflection");
    if (!(base > -91 and base < 91)) { base = 0; }
	setprop("/instrumentation/nav[1]/indicated-gs-deflection",check_basic_diff(base,goal,max_needle_speed/4,-max_needle_speed/4));

}

update_slow_nav_goals = func {
	# RNAV mode (+RNAV-APR mode) [max 10 = 5 NM, min -10 = 5NM]
	if (getprop("/instrumentation/nav[1]/nav-mode") >= 2 and getprop("/instrumentation/nav[1]/nav-loc")!=1) {
		l_dist = getprop("/instrumentation/nav[1]/nav-wpt-dist["~getprop("/instrumentation/nav[1]/nav-wpt-active")~"]");
		l_dme = getprop("/instrumentation/dme[1]/indicated-distance-nm");
		r_fantom = getprop("/instrumentation/nav[1]/nav-wpt-rad["~getprop("/instrumentation/nav[1]/nav-wpt-active")~"]");
		r_let = getprop("/instrumentation/nav[1]/heading-magnetic");

		delta = 180 - (r_fantom - r_let);
		l_wp = math.sqrt (l_dist*l_dist + l_dme*l_dme - 2 * l_dist * l_dme * math.cos(delta*deg_to_rad));
		
		if (l_wp == rnav_prev_dist) {
			time_to_go = 99999;
			speed = 0;
		} else {
			time_to_go = l_wp / ((l_wp - rnav_prev_dist )) / 60;
			speed = (l_wp - rnav_prev_dist ) * 3600;
		}
		
		if (time_to_go < 0) { time_to_go = -time_to_go; }
		if (time_to_go > 99) { time_to_go = 99; }
		if (speed < 0) { speed = -speed; }
		setprop("/instrumentation/nav[1]/wpt-timetogo-min",time_to_go);
		setprop("/instrumentation/nav[1]/wpt-speed-kt",speed);
		rnav_prev_dist = l_wp;
	}
}

#Updates position of indicated values for HSI[0,1] and RMI[0,1] instruments:
update_nav_vor_adf_needles = func {
	
	# max real speed is 0.25 * max = 10 deg/0.05s
	max_needle_speed = 40;

    #
	# RMI[0] (l410-kni582.xml)
	#
	base1=getprop("instrumentation/rmi[0]/indicated-deflection1");
	base2=getprop("instrumentation/rmi[0]/indicated-deflection2");
	
	if (getprop("/instrumentation/rmi[0]/nav-adf-sw1")==0) {
		goal1=getprop("/instrumentation/adf[0]/indicated-bearing-deg");
        if (getprop("/instrumentation/adf[0]/mode-sw") >= 3) { goal1 = 90.0 }
        if (getprop("/systems/electrical/outputs/adf[0]") < 20) { goal1 = base1; }
	} else {
        if (getprop("/instrumentation/nav[0]/indicated-in-range")==1 and getprop("/instrumentation/nav[0]/nav-loc")!=1) {
		    goal1=getprop("/instrumentation/nav[0]/heading-magnetic") - getprop("/orientation/heading-magnetic-deg");
        } else {
            goal1=90;
        }
        if (getprop("/systems/electrical/outputs/nav[0]") < 20) { goal1 = base1; }
	}
	if (getprop("/instrumentation/rmi[0]/nav-adf-sw2")==0) {
		goal2=getprop("/instrumentation/adf[1]/indicated-bearing-deg");
        if (getprop("/instrumentation/adf[1]/mode-sw") >= 3) { goal2 = 90.0 }
        if (getprop("/systems/electrical/outputs/adf[1]") < 20) { goal2 = base2; }
	} else {
		if (getprop("/instrumentation/nav[1]/nav-mode") >= 2 and getprop("/instrumentation/nav[1]/nav-loc")!=1) {
			if (getprop("/instrumentation/nav[1]/indicated-in-range")==1) {
				goal2=getprop("/instrumentation/nav[1]/wpt-radto-deg")-getprop("/orientation/heading-magnetic-deg");
			} else {
				goal2=90;
			}
		} else {
            if (getprop("/instrumentation/nav[1]/nav-loc")!=1) {
			    if (getprop("/instrumentation/nav[1]/indicated-in-range")==1) {
			        goal2=getprop("/instrumentation/nav[1]/heading-magnetic") - getprop("/orientation/heading-magnetic-deg");
                } else {
                    goal2=90;
                }
			} else {
				goal2=90;
			}
		}
        if (getprop("/systems/electrical/outputs/nav[1]") < 20) { goal2 = base2; }
	}

	setprop("instrumentation/rmi[0]/indicated-deflection1",check_diff(base1,goal1,max_needle_speed,-max_needle_speed));
	setprop("instrumentation/rmi[0]/indicated-deflection2",check_diff(base2,goal2,max_needle_speed,-max_needle_speed));

	#
	# RMI[1] (l410-kni582.xml)
	#
	base1=getprop("instrumentation/rmi[1]/indicated-deflection1");
	base2=getprop("instrumentation/rmi[1]/indicated-deflection2");
	
	if (getprop("/instrumentation/rmi[1]/nav-adf-sw1")==0) {
		goal1=getprop("/instrumentation/adf[0]/indicated-bearing-deg");
        if (getprop("/instrumentation/adf[0]/mode-sw") >= 3) { goal1 = 90.0 }
        if (getprop("/systems/electrical/outputs/adf[0]") < 20) { goal1 = base1; }
	} else {
        if (getprop("/instrumentation/nav[0]/indicated-in-range")==1 and getprop("/instrumentation/nav[0]/nav-loc")!=1) {
		    goal1=getprop("/instrumentation/nav[0]/heading-magnetic") - getprop("/orientation/heading-magnetic-deg");
        } else {
            goal1=90;
        }
        if (getprop("/systems/electrical/outputs/nav[0]") < 20) { goal1 = base1; }
	}
	if (getprop("/instrumentation/rmi[1]/nav-adf-sw2")==0) {
		goal2=getprop("/instrumentation/adf[1]/indicated-bearing-deg");
        if (getprop("/instrumentation/adf[1]/mode-sw") >= 3) { goal2 = 90.0 }
        if (getprop("/systems/electrical/outputs/adf[1]") < 20) { goal2 = base2; }
	} else {
		if (getprop("/instrumentation/nav[1]/nav-mode") >= 2 and getprop("/instrumentation/nav[1]/nav-loc")!=1) {
			if (getprop("/instrumentation/nav[1]/indicated-in-range")==1) {
				goal2=getprop("/instrumentation/nav[1]/wpt-radto-deg")-getprop("/orientation/heading-magnetic-deg");
			} else {
				goal2=90;
			}
		} else {
            if (getprop("/instrumentation/nav[1]/nav-loc")!=1) {
			    if (getprop("/instrumentation/nav[1]/indicated-in-range")==1) {
			        goal2=getprop("/instrumentation/nav[1]/heading-magnetic") - getprop("/orientation/heading-magnetic-deg");
                } else {
				    goal2=90;
                }
			} else {
				goal2=90;
			}
		}
        if (getprop("/systems/electrical/outputs/nav[1]") < 20) { goal2 = base2; }
	}

	setprop("instrumentation/rmi[1]/indicated-deflection1",check_diff(base1,goal1,max_needle_speed,-max_needle_speed));
	setprop("instrumentation/rmi[1]/indicated-deflection2",check_diff(base2,goal2,max_needle_speed,-max_needle_speed));

	#
	# NAV[0] (l410-kpi553.xml) HSI
	#
	
	base=getprop("instrumentation/hsi[0]/indicated-adf-deflection");
	if (getprop("/instrumentation/hsi[0]/nav-adf-sw")==0) {
		goal1=getprop("/instrumentation/adf[0]/indicated-bearing-deg");
        if (getprop("/instrumentation/adf[0]/mode-sw") >= 3) { goal1 = 90.0 }
        if (getprop("/systems/electrical/outputs/adf[0]") < 20) { goal1 = base; }
	} else {
        if (getprop("/instrumentation/nav[0]/indicated-in-range")==1 and getprop("/instrumentation/nav[0]/nav-loc")!=1) {
		    goal1=getprop("/instrumentation/nav[0]/heading-magnetic") - getprop("/orientation/heading-magnetic-deg");
        } else {
            goal1=90;
        }
        if (getprop("/systems/electrical/outputs/nav[0]") < 20) { goal1 = base; }
	}
	setprop("instrumentation/hsi[0]/indicated-adf-deflection",check_diff(base,goal1,max_needle_speed,-max_needle_speed));

	#
	# NAV[1] (l410-kpi553.xml) HSI
	#
	
	base=getprop("instrumentation/hsi[1]/indicated-adf-deflection");
	if (getprop("/instrumentation/hsi[1]/nav-adf-sw")==0) {
		goal1=getprop("/instrumentation/adf[1]/indicated-bearing-deg");
        if (getprop("/instrumentation/adf[1]/mode-sw") >= 3) { goal1 = 90.0 }
        if (getprop("/systems/electrical/outputs/adf[1]") < 20) { goal1 = base; }
	} else {
		if (getprop("/instrumentation/nav[1]/nav-mode") >= 2 and getprop("/instrumentation/nav[1]/nav-loc")!=1) {
			if (getprop("/instrumentation/nav[1]/indicated-in-range")==1) {
				goal1=getprop("/instrumentation/nav[1]/wpt-radto-deg")-getprop("/orientation/heading-magnetic-deg");
			} else {
				goal1=90;
			}
		} else {
            if (getprop("/instrumentation/nav[1]/indicated-in-range")==1 and getprop("/instrumentation/nav[1]/nav-loc")!=1) {
			    goal1=getprop("/instrumentation/nav[1]/heading-magnetic") - getprop("/orientation/heading-magnetic-deg");
			} else {
				goal1=90;
			}
		}
        if (getprop("/systems/electrical/outputs/nav[1]") < 20) { goal1 = base; }
	}
	setprop("instrumentation/hsi[1]/indicated-adf-deflection",check_diff(base,goal1,max_needle_speed,-max_needle_speed));
	
	#
	# DME 1
	#
	
#	setprop("/radios/dme[0]/indicated-in-range",getprop("/radios/dme[0]/in-range"));
	
	#
	# DME 2 - selecting displayed values depending on NAV2 mode
	#
	
	if (getprop("/instrumentation/nav[1]/nav-mode") >= 2 and getprop("/instrumentation/nav[1]/nav-loc")!=1) {
		setprop("/instrumentation/dme[1]/l410-indicated-in-range",getprop("/instrumentation/nav[1]/indicated-in-range"));
		setprop("/instrumentation/dme[1]/l410-indicated-distance-nm",getprop("/instrumentation/nav[1]/wpt-dist-nm"));
		if (getprop("/instrumentation/nav[1]/nav-rad-btn")==0) {
			setprop("/instrumentation/dme[1]/l410-indicated-speed-kt",getprop("/instrumentation/nav[1]/wpt-speed-kt"));
			setprop("/instrumentation/dme[1]/l410-indicated-time-min",getprop("/instrumentation/nav[1]/wpt-timetogo-min"));
			setprop("/instrumentation/dme[1]/rnav-rad-flag",0);
		} else {
			rad_from = getprop("/instrumentation/nav[1]/wpt-radto-deg") - 180;
			if (rad_from<0.0) { rad_from=rad_from+360; }
			setprop("/instrumentation/dme[1]/l410-indicated-speed-kt",rad_from);
			setprop("/instrumentation/dme[1]/rnav-rad-flag",1);
		}
	} else {
		setprop("/instrumentation/dme[1]/l410-indicated-distance-nm",getprop("/instrumentation/dme[1]/indicated-distance-nm"));
		setprop("/instrumentation/dme[1]/l410-indicated-in-range",getprop("/instrumentation/dme[1]/in-range"));
		if (getprop("/instrumentation/nav[1]/nav-rad-btn")==0) {
			setprop("/instrumentation/dme[1]/l410-indicated-speed-kt",getprop("/instrumentation/dme[1]/indicated-ground-speed-kt"));
			setprop("/instrumentation/dme[1]/l410-indicated-time-min",getprop("/instrumentation/dme[1]/indicated-time-min"));
			setprop("/instrumentation/dme[1]/rnav-rad-flag",0);
		} else {
			rad_from = getprop("/instrumentation/nav[1]/heading-magnetic") - 180;
			if (rad_from<0.0) { rad_from=rad_from+360; }
			setprop("/instrumentation/dme[1]/l410-indicated-speed-kt",rad_from);
			setprop("/instrumentation/dme[1]/rnav-rad-flag",1);
		}
	}
	
}

update_encoding_altimeter = func {
	#
	# ENCODING ALTIMETER
	#
	
	vyska=getprop("/instrumentation/altimeter/indicated-altitude-ft");
	setprop("instrumentation/encoding-alt/text-alt-upper",int(vyska/1000.0));
	
	vyska = vyska + 50;
	first=int(modulo(vyska,1000)/100.0)*100.0;
	center=(first-modulo(vyska,1000))/10.0;
	
	if (first<100) {
		setprop("instrumentation/encoding-alt/text-alt1",900);
	} else {
		setprop("instrumentation/encoding-alt/text-alt1",first-100);
	}
	setprop("instrumentation/encoding-alt/text-alt2",first);
	if (first>=900) {
		setprop("instrumentation/encoding-alt/text-alt3",0);
	} else {
		setprop("instrumentation/encoding-alt/text-alt3",first+100);
	}

	setprop("instrumentation/encoding-alt/text-alt-offset1",center-5);
	setprop("instrumentation/encoding-alt/text-alt-offset2",center+5);
	setprop("instrumentation/encoding-alt/text-alt-offset3",center+15);
	
}

update_magnetic_gyro_diff = func {
#	diff=getprop("/instrumentation/magnetic-compass/indicated-heading-deg")-getprop("/instrumentation/heading-indicator/indicated-heading-deg");
	
    #GYRO1
    diff=getprop("/orientation/heading-magnetic-deg")-getprop("/instrumentation/heading-indicator[0]/indicated-heading-deg");
	if (diff > 180) {
		diff = diff - 360;
	}
	if (diff < -180) {
		diff = diff + 360;
	}
	setprop("/instrumentation/heading-indicator[0]/indicated-diff",diff);
	
	if (getprop("/systems/electrical/outputs/heading-indicator-selsyn") < 20 or getprop("/systems/health/heading-indicator1-ok")==0) {
		setprop("/instrumentation/heading-indicator[0]/serviceable",0);
	} else {
		setprop("/instrumentation/heading-indicator[0]/serviceable",1);
	}
    
    #GYRO2
    diff=getprop("/orientation/heading-magnetic-deg")-getprop("/instrumentation/heading-indicator[1]/indicated-heading-deg");
	if (diff > 180) {
		diff = diff - 360;
	}
	if (diff < -180) {
		diff = diff + 360;
	}
	setprop("/instrumentation/heading-indicator[1]/indicated-diff",diff);
	
	if (getprop("/systems/electrical/outputs/heading-indicator-selsyn") < 20 or getprop("/systems/health/heading-indicator2-ok")==0) {
		setprop("/instrumentation/heading-indicator[1]/serviceable",0);
	} else {
		setprop("/instrumentation/heading-indicator[1]/serviceable",1);
	}
    
    #COPY VALUES FROM SELECTED GYRO
    goal=getprop("/instrumentation/heading-indicator-selected/indicated-heading-deg");
    base=getprop("/instrumentation/heading-indicator-selected/indicated-heading-deg");
    if (getprop("/systems/electrical/outputs/heading-indicator-selsyn") >= 20) {
        if (getprop("/instrumentation/heading-indicator-selected/selected")==0 and 
	    getprop("/systems/health/gyro-correction-ok")==1) {
    	    goal=getprop("/instrumentation/heading-indicator[0]/indicated-heading-deg");
            setprop("/instrumentation/heading-indicator-selected/spin",getprop("/instrumentation/heading-indicator[0]/spin"));
	    }
        if (getprop("/instrumentation/heading-indicator-selected/selected")==1 and getprop("/systems/health/gyro-correction-ok")==1) {
	        goal=getprop("/instrumentation/heading-indicator[1]/indicated-heading-deg");
	        setprop("/instrumentation/heading-indicator-selected/spin",getprop("/instrumentation/heading-indicator[1]/spin"));
	    }
    } else {
        if (getprop("/instrumentation/heading-indicator-selected/selected")==0) {
            setprop("/instrumentation/heading-indicator-selected/spin",getprop("/instrumentation/heading-indicator[0]/spin"));
        } else {
	        setprop("/instrumentation/heading-indicator-selected/spin",getprop("/instrumentation/heading-indicator[1]/spin"));
        }
    }
    base=getprop("/instrumentation/heading-indicator-selected/indicated-heading-deg");
    setprop("/instrumentation/heading-indicator-selected/indicated-heading-deg",check_diff(base,goal,40,-40));

}

update_engine_power = func {
	#test electiricity for starter
		electr_lh=1;
		electr_rh=1;
		
		#test connection to electrical bus
		if (getprop("/systems/electrical/outputs/starter-lh")>20) {
			setprop("/controls/electric/engine[0]/generator",1);
		} else {
			setprop("/controls/electric/engine[0]/generator",0);
		}

		if (getprop("/systems/electrical/outputs/starter-rh")>20) {
			setprop("/controls/electric/engine[1]/generator",1);
		} else {
			setprop("/controls/electric/engine[1]/generator",0);
		}
	
	#test for cutoff
		cutoff_lh=0;
		cutoff_rh=0;
		
		#test user command cutoff
		if (getprop("/controls/engines/engine[0]/cutoff-cmd")) { cutoff_lh=1; }
		if (getprop("/controls/engines/engine[1]/cutoff-cmd")) { cutoff_rh=1; }
		
		#test fuel-pump failure
        if (getprop("/instrumentation/pressure/indicated-fuel1-kp_cm2") < 2) { cutoff_lh=1; }
        if (getprop("/instrumentation/pressure/indicated-fuel2-kp_cm2") < 2) { cutoff_rh=1; }

		#test engine failure
        if (getprop("/systems/health/engine-lh-ok") == 0) { cutoff_lh=1; }
        if (getprop("/systems/health/engine-rh-ok") == 0) { cutoff_rh=1; }
        
        #ignition failure
        if (getprop("/systems/health/ignition-lh-ok")==0 and getprop("/engines/engine[0]/starting")==1) { cutoff_lh=1; }
        if (getprop("/systems/health/ignition-rh-ok")==0 and getprop("/engines/engine[1]/starting")==1) { cutoff_rh=1; }

		setprop("/controls/engines/engine[0]/cutoff",cutoff_lh);
		setprop("/controls/engines/engine[1]/cutoff",cutoff_rh);
	
	#test ielu on
		if (getprop("/systems/electrical/outputs/ielu-lh") < 20) {
			if (getprop("/controls/engines/engine[0]/condition") == 0) { 
				setprop("/controls/engines/engine[0]/condition",1);
			}
		    setprop("/instrumentation/warn-disp/wde1-ielu",1);
			setprop("/instrumentation/warn-disp/ww-ielu-operative-lh",0);
		} else {
			if (getprop("/controls/engines/engine[0]/condition") == 1) { 
				setprop("/controls/engines/engine[0]/condition",0); 
				setprop("/instrumentation/warn-disp/wde1-ielu",0);
				setprop("/instrumentation/warn-disp/ww-ielu-operative-lh",1);
			}
		}

		if (getprop("/systems/electrical/outputs/ielu-rh") < 20) {
			if (getprop("/controls/engines/engine[1]/condition") == 0) { 
				setprop("/controls/engines/engine[1]/condition",1); 
			}
			setprop("/instrumentation/warn-disp/wde2-ielu",1);
			setprop("/instrumentation/warn-disp/ww-ielu-operative-rh",0);
		} else {
			if (getprop("/controls/engines/engine[1]/condition") == 1) {
				setprop("/controls/engines/engine[1]/condition",0);
				setprop("/instrumentation/warn-disp/wde2-ielu",0);
				setprop("/instrumentation/warn-disp/ww-ielu-operative-rh",1);
			}
		}
        
    #ignition sound
        if ((getprop("/engines/engine[0]/starting")==1 or getprop("/controls/switches/ignition-test-lh-sw")>0)
            and getprop("/systems/electrical/outputs/starter-lh")>20) {
                setprop("/engines/engine[0]/ignition-on",1);
        } else { setprop("/engines/engine[0]/ignition-on",0); }

        if ((getprop("/engines/engine[1]/starting")==1  or getprop("/controls/switches/ignition-test-rh-sw")>0)
            and getprop("/systems/electrical/outputs/starter-rh")>20) {
                setprop("/engines/engine[1]/ignition-on",1);
        } else { setprop("/engines/engine[1]/ignition-on",0); }
}

update_engine_fire = func {
	if (getprop("/systems/electrical/outputs/firesgn-englh")>20
	and (
	   (getprop("/systems/health/firesgn-englh1-ok") and (getprop("/systems/fire/fire-englh1") or getprop("/controls/switches/firesgn-eng1-sw")))
	or (getprop("/systems/health/firesgn-englh2-ok") and (getprop("/systems/fire/fire-englh2") or getprop("/controls/switches/firesgn-eng2-sw")))
	or (getprop("/systems/health/firesgn-englh3-ok") and (getprop("/systems/fire/fire-englh3") or getprop("/controls/switches/firesgn-eng3-sw")))
	)
	) {
		setprop("/instrumentation/fire-det/fire-englh",1);
		setprop("/instrumentation/warn-disp/wde1-fire",1);
	} else {
		setprop("/instrumentation/fire-det/fire-englh",0);
		setprop("/instrumentation/warn-disp/wde1-fire",0);
	}

	if (getprop("/systems/electrical/outputs/firesgn-engrh")>20
	and (
	   (getprop("/systems/health/firesgn-engrh1-ok") and (getprop("/systems/fire/fire-engrh1") or getprop("/controls/switches/firesgn-eng1-sw")))
	or (getprop("/systems/health/firesgn-engrh2-ok") and (getprop("/systems/fire/fire-engrh2") or getprop("/controls/switches/firesgn-eng2-sw")))
	or (getprop("/systems/health/firesgn-engrh3-ok") and (getprop("/systems/fire/fire-engrh3") or getprop("/controls/switches/firesgn-eng3-sw")))
	)
	) {
		setprop("/instrumentation/fire-det/fire-engrh",1);
		setprop("/instrumentation/warn-disp/wde2-fire",1);
	} else {
		setprop("/instrumentation/fire-det/fire-engrh",0);
		setprop("/instrumentation/warn-disp/wde2-fire",0);
	}

	if (getprop("/systems/electrical/outputs/firesgn-bag-front")>20
	and (getprop("/systems/health/firesgn-bag-front-ok") and 
    (getprop("/systems/fire/fire-bag-front") or getprop("/controls/switches/firesgn-bagcomp-sw")))
    ) {
		setprop("/instrumentation/fire-det/fire-fbc",1);
		setprop("/instrumentation/warn-disp/wd-firebag-front",1);
    } else {
		setprop("/instrumentation/fire-det/fire-fbc",0);
		setprop("/instrumentation/warn-disp/wd-firebag-front",0);
    }

	if (getprop("/systems/electrical/outputs/firesgn-bag-aft")>20
	and (getprop("/systems/health/firesgn-bag-aft-ok") and 
    (getprop("/systems/fire/fire-bag-aft") or getprop("/controls/switches/firesgn-bagcomp-sw")))
    ) {
		setprop("/instrumentation/fire-det/fire-abc",1);
		setprop("/instrumentation/warn-disp/wd-firebag-aft",1);
    } else {
		setprop("/instrumentation/fire-det/fire-abc",0);
		setprop("/instrumentation/warn-disp/wd-firebag-aft",0);
    }
}

update_propeller_pitch = func {
#this function is for propeller feathering

    pitch_lh=getprop("/controls/engines/engine[0]/propeller-pitch-cmd");
	pitch_rh=getprop("/controls/engines/engine[1]/propeller-pitch-cmd");

    feat_lh_rq = 0;
    feat_rh_rq = 0;

    # feathering by levers

    if (pitch_lh>=0) {
		interpolate("/controls/engines/engine[0]/propeller-pitch",pitch_lh,1.5);
	} else {
		interpolate("/controls/engines/engine[0]/propeller-pitch",0,1.5);
        if (getprop("/engines/engine[0]/thruster/rpm") > 200 or getprop("/engines/engine[0]/oil-pressure-psi") > 13 ) { feat_lh_rq = 1; }
	}
	if (pitch_rh>=0) {
		interpolate("/controls/engines/engine[1]/propeller-pitch",pitch_rh,1.5);
	} else {
		interpolate("/controls/engines/engine[1]/propeller-pitch",0,1.5);
        if (getprop("/engines/engine[1]/thruster/rpm") > 200 or getprop("/engines/engine[1]/oil-pressure-psi") > 13 ) { feat_rh_rq = 1; }
	}

    # when it was feathered and the lever is in feather position
    if (getprop("/engines/engine[0]/thruster/pitch") > 82 and pitch_lh < 0) { feat_lh_rq = 1; }
    if (getprop("/engines/engine[1]/thruster/pitch") > 82 and pitch_rh < 0) { feat_rh_rq = 1; }
    
    
    # feathering by buttons (and autofeathering)
    if (getprop("/controls/switches/prop-feat1-sw") == 1) {
        setprop("/engines/engine[0]/feather-pump-timer",0.0);
        setprop("/controls/switches/prop-feat1-sw",0);
    }
    if (getprop("/controls/switches/prop-feat2-sw") == 1) {
        setprop("/engines/engine[1]/feather-pump-timer",0.0);
        setprop("/controls/switches/prop-feat2-sw",0);
    }

    feat_pump_timer_lh = getprop("/engines/engine[0]/feather-pump-timer");
    feat_pump_timer_rh = getprop("/engines/engine[1]/feather-pump-timer");
    
    if (feat_pump_timer_lh < 15 or getprop("/controls/switches/chck-feather-lh-sw")==1) {
        setprop("/engines/engine[0]/feather-pump-timer",feat_pump_timer_lh + 0.1);
        if (getprop("/systems/electrical/outputs/feather-pump-lh") > 1) {
            feat_lh_rq = 1;
            setprop("/engines/engine[0]/feather-pump-running",1);
        } else {
            setprop("/engines/engine[0]/feather-pump-running",0);
            setprop("/engines/engine[0]/feather-pump-timer",20.0);
        }
    } else {
            setprop("/engines/engine[0]/feather-pump-running",0);
            setprop("/engines/engine[0]/feather-pump-timer",20.0);
    }

    if (feat_pump_timer_rh < 15 or getprop("/controls/switches/chck-feather-rh-sw")==1) {
        setprop("/engines/engine[1]/feather-pump-timer",feat_pump_timer_rh + 0.1);
        if (getprop("/systems/electrical/outputs/feather-pump-rh") > 1) {
            feat_rh_rq = 1;
            setprop("/engines/engine[1]/feather-pump-running",1);
        } else {
            setprop("/engines/engine[1]/feather-pump-running",0);
            setprop("/engines/engine[1]/feather-pump-timer",20.0);
        }
    } else {
            setprop("/engines/engine[1]/feather-pump-running",0);
            setprop("/engines/engine[1]/feather-pump-timer",20.0);
    }

    # results

    if (feat_lh_rq == 1) { setprop("/controls/engines/engine[0]/propeller-feather",1); }
    else { setprop("/controls/engines/engine[0]/propeller-feather",0); }
    if (feat_rh_rq == 1) { setprop("/controls/engines/engine[1]/propeller-feather",1); }
    else { setprop("/controls/engines/engine[1]/propeller-feather",0); }

}

update_propeller_feathering = func {
    # when switched off old state will be forgoten
    if (getprop("/controls/switches/feat-autbank1-sw") == 0 and
        getprop("/controls/switches/feat-autbank2-sw") == 0 ) {
        setprop("/engines/autofeather-block-lh",1);
        setprop("/engines/autofeather-block-rh",1);
        setprop("/engines/autofeather-ielublock-lh",1);
        setprop("/engines/autofeather-ielublock-rh",1);
        
        setprop("/controls/engines/aileron-abc-goal-norm",0.0);
        setprop("/engines/abc-block",1);
    }

    if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
        getprop("/controls/engines/engine[1]/throttle") > 0.75 and
        getprop("/engines/engine[0]/reversed") == 0 and
        getprop("/engines/engine[1]/reversed") == 0 ) {
        if (getprop("/engines/autofeather-timer") < 6) {
            setprop("/engines/autofeather-timer",getprop("/engines/autofeather-timer")+0.1);
        }
        if (getprop("/engines/abc-timer") < 5.8) {
            setprop("/engines/abc-timer",getprop("/engines/abc-timer")+0.1);
        }
    } else {
        setprop("/engines/autofeather-timer",0);
        setprop("/engines/abc-timer",0);
    }
    if (getprop("/systems/electrical/outputs/feather-auto-lh") <= 1 or
        getprop("/systems/electrical/outputs/feather-auto-rh") <= 1) {
        setprop("/engines/autofeather-timer",0);
    }
    if (getprop("/systems/electrical/outputs/abc") <= 1 or 
        getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") > 111) {
        setprop("/engines/abc-timer",0);
    }
    
    # automatic feathering in action:
    
    if (getprop("/engines/autofeather-timer") >= 6 ) {

        # 1st degree (torque under 24%)
        if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
            getprop("/controls/engines/engine[1]/throttle") > 0.75 and
            getprop("/instrumentation/engine/indicated-pshaft1-perc") < 24 and
            getprop("/engines/autofeather-block-lh") == 1 and
            getprop("/engines/engine[0]/reversed") == 0 ) {
            # set 1st degree on LH engine
            setprop("/engines/autofeather-block-rh",0);
        }
        if ((getprop("/controls/engines/engine[0]/throttle") <= 0.75 or
            getprop("/controls/engines/engine[1]/throttle") <= 0.75 or
            getprop("/instrumentation/engine/indicated-pshaft1-perc") >= 24) and
            getprop("/engines/autofeather-block-lh") == 1 and
            getprop("/engines/autofeather-block-rh") == 0 ) {
            # remove 1st degree on LH engine
            setprop("/engines/autofeather-block-rh",1);
        }

        if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
            getprop("/controls/engines/engine[1]/throttle") > 0.75 and
            getprop("/instrumentation/engine/indicated-pshaft2-perc") < 24 and
            getprop("/engines/autofeather-block-rh") == 1 and
            getprop("/engines/engine[1]/reversed") == 0 ) {
            # set 1st degree on RH engine
            setprop("/engines/autofeather-block-lh",0);
        }
        if ((getprop("/controls/engines/engine[0]/throttle") <= 0.75 or
            getprop("/controls/engines/engine[1]/throttle") <= 0.75 or
            getprop("/instrumentation/engine/indicated-pshaft2-perc") >= 24) and
            getprop("/engines/autofeather-block-rh") == 1 and
            getprop("/engines/autofeather-block-lh") == 0 ) {
            # remove 1st degree on RH engine
            setprop("/engines/autofeather-block-lh",1);
        }
    }
    
    # 2nd degree (torque under 18%)
    if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
        getprop("/controls/engines/engine[1]/throttle") > 0.75 and
        getprop("/instrumentation/engine/indicated-pshaft1-perc") < 18 and
        getprop("/engines/autofeather-block-lh") == 1 and
        getprop("/engines/autofeather-block-rh") == 0 and
        getprop("/engines/engine[0]/reversed") == 0 ) {
        # set 2nd degree on LH engine
        setprop("/engines/autofeather-block-lh",0);
        setprop("/engines/autofeather-block-rh",0);
        setprop("/engines/engine[0]/feather-pump-timer",0.0);
        setprop("/engines/autofeather-ielublock-rh",0);
    }
    
    if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
        getprop("/controls/engines/engine[1]/throttle") > 0.75 and
        getprop("/instrumentation/engine/indicated-pshaft2-perc") < 18 and
        getprop("/engines/autofeather-block-rh") == 1 and
        getprop("/engines/autofeather-block-lh") == 0 and
        getprop("/engines/engine[1]/reversed") == 0 ) {
        # set 2nd degree on RH engine
        setprop("/engines/autofeather-block-lh",0);
        setprop("/engines/autofeather-block-rh",0);
        setprop("/engines/engine[1]/feather-pump-timer",0.0);
        setprop("/engines/autofeather-ielublock-lh",0);
    }
    
    # automatic bank control in action:
    if (getprop("/engines/abc-timer") >= 5.8) {
        if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
            getprop("/controls/engines/engine[1]/throttle") > 0.75 and
            getprop("/instrumentation/engine/indicated-pshaft1-perc") < 24 and
            getprop("/engines/abc-block") == 1 ) {
            setprop("/controls/engines/aileron-abc-goal-norm",0.5);
            setprop("/engines/abc-block",0);
        }
        if (getprop("/controls/engines/engine[0]/throttle") > 0.75 and
            getprop("/controls/engines/engine[1]/throttle") > 0.75 and
            getprop("/instrumentation/engine/indicated-pshaft2-perc") < 24 and
            getprop("/engines/abc-block") == 1 ) {
            setprop("/controls/engines/aileron-abc-goal-norm",-0.5);
            setprop("/engines/abc-block",0);
        }
    }
    
    if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") > 111) {
        setprop("/controls/engines/aileron-abc-goal-norm",0.0);
    }
        
    if (getprop("/systems/hydraulic/main-pressure-MPa") > 1.5) {
        interpolate("/controls/engines/aileron-abc-norm",getprop("/controls/engines/aileron-abc-goal-norm"),0.2);
        #setprop("/fdm/jsbsim/aero/aileron-abc-norm",getprop("/controls/engines/aileron-abc-norm"));
    }
    
    if (getprop("/controls/engines/aileron-abc-norm")>0) {
        setprop("/surface-positions/abc-right-norm",getprop("/controls/engines/aileron-abc-norm")*2);
    } else {
        setprop("/surface-positions/abc-right-norm",0);
    }
    if (getprop("/controls/engines/aileron-abc-norm")<0) {
        setprop("/surface-positions/abc-left-norm",-getprop("/controls/engines/aileron-abc-norm")*2);
    } else {
        setprop("/surface-positions/abc-left-norm",0);
    }
    
}

#Updates tanks content if fuel cross feed is on
update_fuel_cross_feed = func {
    tank0 = getprop("consumables/fuel/tank[0]/level-gal_us");
    tank1 = getprop("consumables/fuel/tank[1]/level-gal_us");
    delta = tank0 - tank1;
	
    setprop("consumables/fuel/tank[0]/level-gal_us",check_norm_diff(tank0,tank0-delta/2,2,-2));
    setprop("consumables/fuel/tank[1]/level-gal_us",check_norm_diff(tank1,tank1+delta/2,2,-2));
}

update_voltmeters = func {

    # VOLTMETERS
    
	if (getprop("/controls/switches/inv-115-select-sw")==0 or getprop("/controls/switches/inv-115-select-sw")==-1) {
		setprop("/controls/switches/inv-115-select-inv1",1); } 
	else {
		setprop("/controls/switches/inv-115-select-inv1",0); }

	if (getprop("/controls/switches/inv-115-select-sw")==0 or getprop("/controls/switches/inv-115-select-sw")==1) {
		setprop("/controls/switches/inv-115-select-inv2",1); } 
	else {
		setprop("/controls/switches/inv-115-select-inv2",0); }

	max_needle_speed=100;

	#max_bat_volt=60;
	max_gen_volt=28;
	#max_alt_amps=100;
	
	if (getprop("/controls/switches/v-150-meter-sw")==-2) {
		goal_v150=getprop("/systems/electrical/outputs/bus115v")/ max_gen_volt * 115;}
	if (getprop("/controls/switches/v-150-meter-sw")==-1) {
		goal_v150=getprop("/systems/electrical/outputs/bus-alt115v1")}
	if (getprop("/controls/switches/v-150-meter-sw")==0) { goal_v150=0; }
	if (getprop("/controls/switches/v-150-meter-sw")==1) {
		goal_v150=getprop("/systems/electrical/outputs/bus-alt115v2")}

	goal_v45=getprop("/systems/electrical/outputs/bus36v") / max_gen_volt * 36;

	goal_v30_2=getprop("/systems/electrical/outputs/bus28v2");
	if (getprop("/engines/engine[1]/starting")==1) { goal_v30_2=getprop("/systems/electrical/outputs/bus28v");}
	
    if (getprop("/controls/switches/va-meter-sw") == 0) {
        #generator LH
	    goal_v30_1=getprop("/systems/electrical/outputs/bus28v1");
	    if (getprop("/engines/engine[0]/starting")==1) { goal_v30_1=getprop("/systems/electrical/outputs/bus28v");}
    }
    if (getprop("/controls/switches/va-meter-sw") == 1) {
        #external power not simulated!
	    goal_v30_1=0;
    }
    if (getprop("/controls/switches/va-meter-sw") == -1) {
        #battery 1
	    if (getprop("/systems/health/battery1-ok") == 1 and getprop("/controls/switches/battery1-sw") == 1) {
            if ((getprop("/systems/electrical/outputs/bus28v1")> 24 or 
                getprop("/systems/electrical/outputs/bus28v2")> 24)) {
                goal_v30_1=getprop("/systems/electrical/outputs/bus28v1");
                if (getprop("/systems/electrical/outputs/bus28v2") > goal_v30_1) {
                    goal_v30_1=getprop("/systems/electrical/outputs/bus28v2") ;
                }
            } else { goal_v30_1=24; }
        } else { goal_v30_1 = 0; }
    }
    if (getprop("/controls/switches/va-meter-sw") == -2) {
        #battery 2
	    if (getprop("/systems/health/battery2-ok") == 1 and getprop("/controls/switches/battery2-sw")==1) {
            if ((getprop("/systems/electrical/outputs/bus28v1") > 24 or 
            getprop("/systems/electrical/outputs/bus28v2") > 24)) {
                goal_v30_1=getprop("/systems/electrical/outputs/bus28v1");
                if (getprop("/systems/electrical/outputs/bus28v2") > goal_v30_1) {
                    goal_v30_1=getprop("/systems/electrical/outputs/bus28v2") ;
                }
            } else { goal_v30_1=24; }
        } else { goal_v30_1 = 0; }
    }
    if (getprop("/controls/switches/va-meter-sw") == -3) {
        #emergency (if sometrhing is working, then use it)
        goal_v30_1 = 0;
        #if (getprop("/systems/electrical/outputs/bus28v1") > goal_v30_1) { goal_v30_1=getprop("/systems/electrical/outputs/bus28v1"); }
        #if (getprop("/systems/electrical/outputs/bus28v2") > goal_v30_1) { goal_v30_1=getprop("/systems/electrical/outputs/bus28v2"); }
        if (getprop("/systems/electrical/outputs/bus28v") > goal_v30_1) { goal_v30_1=getprop("/systems/electrical/outputs/bus28v"); }
    }
    
	base=getprop("/instrumentation/voltmeters/volt-150vac");
	setprop("/instrumentation/voltmeters/volt-150vac",check_norm_diff(base,goal_v150,max_needle_speed,-max_needle_speed));
	base=getprop("/instrumentation/voltmeters/volt-45vac");
	setprop("/instrumentation/voltmeters/volt-45vac",check_norm_diff(base,goal_v45,max_needle_speed,-max_needle_speed));

	base=getprop("/instrumentation/voltmeters/volt-30vdc1");
	setprop("/instrumentation/voltmeters/volt-30vdc1",check_norm_diff(base,goal_v30_1,max_needle_speed,-max_needle_speed));
	base=getprop("/instrumentation/voltmeters/volt-30vdc2");
	setprop("/instrumentation/voltmeters/volt-30vdc2",check_norm_diff(base,goal_v30_2,max_needle_speed,-max_needle_speed));

    # AMPERMETERS
    
    if (getprop("/controls/switches/battery1-sw")==1) {
        goal_a30_1 = 4.7;
        if (getprop("/engines/engine[0]/starting")==1) { goal_a30_1 = goal_a30_1 + 21.1; }
        if (getprop("/engines/engine[1]/starting")==1) { goal_a30_1 = goal_a30_1 + 21.2; }
        if (getprop("/systems/electrical/outputs/bus28v1") > 24) { goal_a30_1 = goal_a30_1 - 9.7; }
        #if (getprop("/systems/electrical/outputs/bus28v2") > 24) { goal_a30_1 = goal_a30_1 - 5.1; }
    } else { goal_a30_1 = 0; }

    if (getprop("/controls/switches/battery2-sw")==1) {
        goal_a30_2 = 4.7;
        if (getprop("/engines/engine[0]/starting")==1) { goal_a30_2 = goal_a30_2 + 21.1; }
        if (getprop("/engines/engine[1]/starting")==1) { goal_a30_2 = goal_a30_2 + 21.2; }
        #if (getprop("/systems/electrical/outputs/bus28v1") > 24) { goal_a30_2 = goal_a30_2 - 5.3; }
        if (getprop("/systems/electrical/outputs/bus28v2") > 24) { goal_a30_2 = goal_a30_2 - 9.8; }
    } else { goal_a30_2 = 0; }

	base=getprop("/instrumentation/voltmeters/amps-30vdc1");
	setprop("/instrumentation/voltmeters/amps-30vdc1",check_basic_diff(base,goal_a30_1,max_needle_speed,-max_needle_speed));
	base=getprop("/instrumentation/voltmeters/amps-30vdc2");
	setprop("/instrumentation/voltmeters/amps-30vdc2",check_basic_diff(base,goal_a30_2,max_needle_speed,-max_needle_speed));
}

update_aircaft_control = func {
    # update spoilers position only when there is electrical power (28Vdc) and spoilers are not damaged
    if (getprop("/systems/hydraulic/main-pressure-MPa") > 2 and
        getprop("/systems/electrical/outputs/spoilers") > 1) {
        setprop("/controls/flight/spoilers-cond",getprop("/controls/flight/spoilers"));
    }

    # update flaps position (not damaged and 28Vdc) and when in emergency mode
#    if (getprop("/systems/electrical/outputs/flaps") > 1 and getprop("/controls/switches/flaps-emergency-sw")==0) {
    if (getprop("/systems/hydraulic/main-pressure-MPa") > 2 and
        getprop("/systems/electrical/outputs/flaps") > 1 and 
        getprop("/controls/switches/flaps-emergency-sw")==0 ) {
        if (getprop("/controls/flight/flaps")<1 or getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") < 112) {
            setprop("/controls/flight/flaps-cond",getprop("/controls/flight/flaps"));
        }
    }
    if (getprop("/controls/switches/flaps-emergency-sw")==1 and getprop("/systems/health/flaps-emerg-ok")==1) {
        if (getprop("/controls/flight/flaps") > getprop("/controls/flight/flaps-cond")) {
            setprop("/controls/flight/flaps-cond",getprop("/controls/flight/flaps"));
        }
    }
    
    # update gear position (not damaged and 28Vdc) and when in emergency mode
#    if (getprop("/systems/electrical/outputs/gear") > 1 and getprop("/controls/switches/gear-emergency-sw")==0) {
    if (getprop("/systems/hydraulic/main-pressure-MPa") > 3 and
        getprop("/systems/electrical/outputs/gear") > 1 and 
        getprop("/controls/switches/gear-emergency-sw")==0) {
        setprop("/controls/gear/gear-down-cond",getprop("/controls/gear/gear-down"));
    }
    if (getprop("/controls/switches/gear-emergency-sw")==1 and getprop("/systems/health/gear-emerg-ok")==1) {
        if (getprop("/controls/gear/gear-down") > getprop("/controls/gear/gear-down-cond")) {
            setprop("/controls/gear/gear-down-cond",getprop("/controls/gear/gear-down"));
        }
    }

    # update separator vane position only when there is electrical power (28Vdc) and parts are not damaged
    if (getprop("/systems/electrical/outputs/separator-vane-lh") > 1) {
        setprop("/instrumentation/deicing/separator-vane-lh-cond",getprop("/controls/switches/separator-vane-lh-sw"));
    }
    if (getprop("/systems/electrical/outputs/separator-vane-rh") > 1) {
        setprop("/instrumentation/deicing/separator-vane-rh-cond",getprop("/controls/switches/separator-vane-rh-sw"));
    }
}


update_wheels_spin = func {
    speed_fps = getprop("/velocities/uBody-fps");
    speed_rpm = speed_fps * 10;
    if (getprop("/gear/gear[0]/wow")==1) { setprop("/gear/gear[0]/spin-rpm",speed_rpm); }
    else { 
        setprop("/gear/gear[0]/spin-rpm",check_norm_diff(getprop("/gear/gear[0]/spin-rpm"),0,10,-10)); 
    }
    speed_rpm = speed_fps * 6.5;
    if (getprop("/gear/gear[1]/wow")==1) { setprop("/gear/gear[1]/spin-rpm",speed_rpm); }
    else {
        brake_force = 0;
        if (getprop("/controls/gear/brake-left") > getprop("/controls/gear/brake-parking")) { brake_force = getprop("/controls/gear/brake-left");}
        else { brake_force = getprop("/controls/gear/brake-parking");}
        setprop("/gear/gear[1]/spin-rpm",check_norm_diff(getprop("/gear/gear[1]/spin-rpm"),0,10+(brake_force*200),-10-(brake_force*200))); 
    }
    if (getprop("/gear/gear[2]/wow")==1) { setprop("/gear/gear[2]/spin-rpm",speed_rpm); }
    else { 
        brake_force = 0;
        if (getprop("/controls/gear/brake-right") > getprop("/controls/gear/brake-parking")) { brake_force = getprop("/controls/gear/brake-right");}
        else { brake_force = getprop("/controls/gear/brake-parking");}
        setprop("/gear/gear[2]/spin-rpm",check_norm_diff(getprop("/gear/gear[2]/spin-rpm"),0,10+(brake_force*200),-10-(brake_force*200)));
    }
}


setprop("/instrumentation/temperature/inner-temp-degc",getprop("/environment/temperature-degc"));
setprop("/instrumentation/temperature/heating-temp-degc",getprop("/environment/temperature-degc"));
update_heating_temperatures = func {
    temp_plus=getprop("/environment/temperature-degc");
    temp_minus=getprop("/environment/temperature-degc");
    if (getprop("/engines/engine[0]/running") == 1 or getprop("/engines/engine[1]/running")) {
        temp_plus=200;
    }
    
    p_plus=getprop("/controls/heating/heating-sw")*0.33;
    p_minus=getprop("/controls/heating/ventilation-sw")*1.5+1;
    temp_tot = (temp_plus*p_plus + temp_minus*p_minus) / (p_plus+p_minus);
    
    base=getprop("/instrumentation/temperature/heating-temp-degc");
    setprop("/instrumentation/temperature/heating-temp-degc",check_norm_diff(base,temp_tot,10,-10));

    goal=getprop("/instrumentation/temperature/heating-temp-degc");
    base=getprop("/instrumentation/temperature/inner-temp-degc");
    setprop("/instrumentation/temperature/inner-temp-degc",check_norm_diff(base,goal,0.003*(p_plus+p_minus),-0.003*(p_plus+p_minus)));

    base=getprop("/instrumentation/temperature/inner-temp-degc");
    setprop("/instrumentation/temperature/inner-temp-degc",check_norm_diff(base,temp_minus,0.01,-0.01));

    if (getprop("/systems/electrical/outputs/cwd-airframe") > 10) {
        goal_heat=getprop("/instrumentation/temperature/heating-temp-degc");
        goal_inner=getprop("/instrumentation/temperature/inner-temp-degc");
    } else {
        goal_heat=0.0;
        goal_inner=0.0;
    }
    base=getprop("/instrumentation/temperature/indicated-heating-temp-degc");
    setprop("/instrumentation/temperature/indicated-heating-temp-degc",check_norm_diff(base,goal_heat,50,-50));
    base=getprop("/instrumentation/temperature/indicated-inner-temp-degc");
    setprop("/instrumentation/temperature/indicated-inner-temp-degc",check_norm_diff(base,goal_inner,50,-50));

    #windshield air flow
    setprop("/instrumentation/temperature/windshield-flow",
        (getprop("/controls/heating/heating-sw") + getprop("/controls/heating/ventilation-sw")) / 2000 *
         getprop("/controls/heating/air-sw") * getprop("/controls/heating/windshield-sw") );
    
}

update_hydraulic_system = func {
    # update system
    
    press_inc1 = (getprop("/engines/engine[0]/n1") - 20)*2.5;
    if (press_inc1 < 0) { press_inc1 = 0; }
    press_inc2 = (getprop("/engines/engine[1]/n1") - 20)*2.5;
    if (press_inc2 < 0) { press_inc2 = 0; }
    
    press_inc = press_inc1 + press_inc2;
    press_inc_lim = press_inc;
    if (press_inc_lim > 100) { press_inc_lim = 100; }
    
    # extending / retracting gear, flaps... and so on (everything, that needs hydraulic)
    down_speed=1;
    if (getprop("/gear/gear[0]/position-norm") != 0 and getprop("/gear/gear[0]/position-norm") != 1) {
        # when gear in transit
        down_speed = down_speed + 150;
    }
    if ((getprop("/surface-positions/flap-pos-norm") > 0.005 and 
        getprop("/surface-positions/flap-pos-norm") < 0.495) or (getprop("/surface-positions/flap-pos-norm") > 0.505 and
        getprop("/surface-positions/flap-pos-norm") < 0.995 )) {
        # when flaps in transit
        down_speed = down_speed + 120;
    }
    if (getprop("/surface-positions/spoilers-pos-norm") > 0.005 and 
        getprop("/surface-positions/spoilers-pos-norm") < 0.995 ) {
        # when spoilers in transit
        down_speed = down_speed + 200;
    }
    if (getprop("/controls/engines/aileron-abc-norm") != 0 and 
        getprop("/controls/engines/aileron-abc-norm") < getprop("/controls/engines/aileron-abc-goal-norm")-0.001 and
        getprop("/controls/engines/aileron-abc-norm") > getprop("/controls/engines/aileron-abc-goal-norm")+0.001 ) {
        # when abc in transit
        down_speed = down_speed + 50;
    }
    
    goal = 0.147 * press_inc_lim;
    if (getprop("/systems/health/hydraulic-ok") == 0) { 
        # when main hydraulic circuit damaged
        goal = 0.0; 
        down_speed = down_speed + 10;
    }

    base=getprop("/systems/hydraulic/main-pressure-MPa");
    setprop("/systems/hydraulic/main-pressure-MPa",check_norm_diff(base,goal,0.003*press_inc,-0.001*down_speed));
    
    goal = getprop("/systems/hydraulic/main-pressure-MPa");
    base=getprop("/systems/hydraulic/brakes-pressure-MPa");
    
    if (getprop("/controls/gear/wheel[0]/brake-cmd-cond") > getprop("/controls/gear/brake-left")) {
        # left wheel brake was pressed (and is not yet filled with oil)
        base = base - 0.1;
    }
    if (getprop("/controls/gear/wheel[1]/brake-cmd-cond") > getprop("/controls/gear/brake-right")) {
        # right wheel brake was pressed (and is not yet filled with oil)
        base = base - 0.1;
    }
    
    setprop("/systems/hydraulic/brakes-pressure-MPa",check_norm_diff(base,goal,0.1,-0.0005));
    if (getprop("/systems/hydraulic/brakes-pressure-MPa") > 5.88) {
        setprop("/systems/hydraulic/brakes-pressure-MPa",5.88);
    }
    if (base < 5.87 and goal>base ) {
        # transefer oil from main circuit to brakes circuit
        basem=getprop("/systems/hydraulic/main-pressure-MPa");
        setprop("/systems/hydraulic/main-pressure-MPa",check_norm_diff(basem,0.0,0.001*press_inc,-0.001*80*(goal-base)));
    }
        
    # update pressure indicators
    goal=getprop("/systems/hydraulic/main-pressure-MPa");
    base=getprop("/instrumentation/pressure/indicated-maincircuit-MPa");
    setprop("/instrumentation/pressure/indicated-maincircuit-MPa",check_norm_diff(base,goal,50,-50));

    goal=getprop("/systems/hydraulic/brakes-pressure-MPa");
    base=getprop("/instrumentation/pressure/indicated-brakescircuit-MPa");
    setprop("/instrumentation/pressure/indicated-brakescircuit-MPa",check_norm_diff(base,goal,50,-50));
}

update_lights = func {
    passenger=0;
    if (getprop("/systems/electrical/outputs/passenger-1-lights")>1) { passenger = passenger + 1.5; }
    if (getprop("/systems/electrical/outputs/passenger-2-lights")>1) { passenger = passenger + 2; }
    setprop("/instrumentation/lights/passenger-intensity",passenger);
    
    if (getprop("/surface-positions/door-rear-pos-norm")>0.1 and getprop("/sim/time/sun-angle-rad")>1.6) {
        setprop("/controls/switches/lgh-passenger1-door-sw",1);
    } else {
        setprop("/controls/switches/lgh-passenger1-door-sw",0);
    }
    
    instruments_p=0;
    control_p=0;
    rear_p=0;
    overhead_p=0;
    cabin_p=0;
    
    neos=1; os=3;
    
    if (getprop("/systems/electrical/outputs/cabin-lighting")>1) {
        if (instruments_p<neos) { instruments_p=instruments_p+neos; }
        if (control_p<os) { control_p=control_p+os; } else { control_p=control_p+neos; } 
        if (rear_p<os) { rear_p=rear_p+os; } else { rear_p=rear_p+neos; } 
        if (overhead_p<neos) { overhead_p=overhead_p+neos; }
        if (cabin_p<neos) { cabin_p=cabin_p+neos; }
    }
    if (getprop("/systems/electrical/outputs/instrument-lights-stby")>1) {
        if (instruments_p<os) { instruments_p=instruments_p+os; } else { instruments_p=instruments_p+neos; } 
        # if (control_p<neos) { control_p=control_p+neos; }
        # if (rear_p<neos) { rear_p=rear_p+neos; }
        # if (overhead_p<neos) { overhead_p=overhead_p+neos; }
        # if (cabin_p<neos) { cabin_p=cabin_p+neos; }
    }
    if (getprop("/systems/electrical/outputs/instrument-lights-2")>1) {
        if (instruments_p<neos) { instruments_p=instruments_p+neos; }
        if (control_p<os) { control_p=control_p+os; } else { control_p=control_p+neos; } 
        if (rear_p<neos) { rear_p=rear_p+neos; }
        if (overhead_p<os) { overhead_p=overhead_p+os; } else { overhead_p=overhead_p+neos; } 
        if (cabin_p<neos) { cabin_p=cabin_p+neos; }
    }
    if (getprop("/systems/electrical/outputs/cabin-lights")>1) {
        instruments_p=10; control_p=10; rear_p=10; overhead_p=10; cabin_p=10;
    }
    setprop("/instrumentation/lights/instruments-panel-intensity",instruments_p);
    setprop("/instrumentation/lights/control-panel-intensity",control_p);
    setprop("/instrumentation/lights/rear-panel-intensity",rear_p);
    setprop("/instrumentation/lights/overhead-panel-intensity",overhead_p);
    setprop("/instrumentation/lights/cabin-intensity",cabin_p);
 
    search_p=0;
    search_p = search_p + getprop("/instrumentation/lights/search1-on") * 1;
    if (getprop("/instrumentation/lights/search1-on")>1) {
        search_p = search_p + 2;
    }
    search_p = search_p + ( getprop("/instrumentation/lights/search2-on") * 2 );
    if (getprop("/instrumentation/lights/search2-on")>1) {
        search_p = search_p + 5;
    }
    setprop("/instrumentation/lights/search-intensity",search_p);
    if (search_p > 8) { setprop("/sim/light/light-source[0]/switch",1); } 
    else { setprop("/sim/light/light-source[0]/switch",0); } 
    if (search_p > 0 and getprop("/sim/current-view/internal")==1) { setprop("/sim/light/light-source[1]/switch",1); } 
    else { setprop("/sim/light/light-source[1]/switch",0); } 
    if (search_p > 2 and search_p<=8 ) { setprop("/sim/light/light-source[2]/switch",1); } 
    else { setprop("/sim/light/light-source[2]/switch",0); } 
 
    #Static ice detector Lgh.
    if (getprop("/systems/electrical/outputs/static-ice-light")>10) {
        setprop("/instrumentation/lights/ice-detector",1);
    } else {
        setprop("/instrumentation/lights/ice-detector",0);
    }
}

setprop("/controls/gear/gear-down-cond",getprop("/controls/gear/gear-down"));
#
# 100ms update
#
update100ms = func {

    update_nav2_radio_check();
    update_nav2_is_ils_freq();
	update_nav_goals();

	update_nav_vor_adf_needles();
	update_encoding_altimeter();
	update_voltmeters();
	
	update_magnetic_gyro_diff();
	
	update_engine_power();
	update_engine_fire();

	update_propeller_pitch();
    update_propeller_feathering();

    update_aircaft_control(); # spoilers, flaps, gear

    update_wheels_spin();

    update_central_warning_display();
    
    update_heating_temperatures();
    
    update_hydraulic_system();

    update_lights();

	settimer ( update100ms , 0.1 );
};

rnav_prev_dist=0;
settimer ( update100ms , 10 );

#
# 1s update
#

update1s = func {

	if (getprop("controls/switches/fuelcross-sw")) {
		if (getprop("systems/electrical/outputs/bus28v") > 0) {
			update_fuel_cross_feed();
		}
	}
	
	update_slow_nav_goals();
	
	settimer ( update1s , 1 );
};

settimer ( update1s , 10 );

#
# gyro compass correction
#
KA51Bcorr = func {
    if (getprop("/systems/electrical/outputs/heading-indicator-selsyn") > 10) {
        #GYRO1
	    if (getprop("/instrumentation/heading-indicator[0]/auto-correction")) {
		    gyro = getprop("/instrumentation/heading-indicator[0]/indicated-heading-deg");
	    	mag  = getprop("/orientation/heading-magnetic-deg");
    		diff = mag - gyro;
		    if (diff > 180 ) { diff=diff-360; }
	    	if (-180 > diff ) { diff=diff+360; }
    		if (getprop("/instrumentation/heading-indicator[0]/quick-correction")==1) {
                if (diff > 2) {diff=2};
		        if (-2 > diff) {diff=-2};
                if (diff>-2 and diff<2) {
                    setprop("/instrumentation/heading-indicator[0]/quick-correction",0)
                }
            } else {
                if (diff > 0.1) {diff=0.1};
		        if (-0.1 > diff) {diff=-0.1};
            }
    		setprop("/instrumentation/heading-indicator[0]/offset-deg",getprop("/instrumentation/heading-indicator[0]/offset-deg")+diff);
	    }
        #GYRO2
	    if (getprop("/instrumentation/heading-indicator[1]/auto-correction")) {
    		gyro = getprop("/instrumentation/heading-indicator[1]/indicated-heading-deg");
		    mag  = getprop("/orientation/heading-magnetic-deg");
	    	diff = mag - gyro;
    		if (diff > 180 ) { diff=diff-360; }
		    if (-180 > diff ) { diff=diff+360; }
	    	if (getprop("/instrumentation/heading-indicator[1]/quick-correction")==1) {
                if (diff > 2) {diff=2};
		        if (-2 > diff) {diff=-2};
                if (diff>-2 and diff<2) {
                    setprop("/instrumentation/heading-indicator[1]/quick-correction",0)
                }
            } else {
                if (diff > 0.1) {diff=0.1};
    		    if (-0.1 > diff) {diff=-0.1};
            }
	    	setprop("/instrumentation/heading-indicator[1]/offset-deg",getprop("/instrumentation/heading-indicator[1]/offset-deg")+diff);
    	}
    }
	settimer ( KA51Bcorr , 0.5 );
	return 0;
}

settimer ( KA51Bcorr , 10 );

Propeller_noise = func {

    a = math.atan2 (getprop("/velocities/uBody-fps"), 30 * getprop("/engines/engine[0]/thruster/rpm") / 60) * 57;
    da = getprop("/engines/engine[0]/thruster/pitch") - a;
    if (da<0) { da = -da * 5; }
    da = da * getprop("/engines/engine[0]/thruster/rpm") / 30000;
    if (getprop("/sim/current-view/internal")==1) { da = da / 2; }
    setprop("/engines/engine[0]/thruster/noise-coef",da);

    a = math.atan2 (getprop("/velocities/uBody-fps"), 30 * getprop("/engines/engine[1]/thruster/rpm") / 60) * 57;
    da = getprop("/engines/engine[1]/thruster/pitch") - a;
    if (da<0) { da = -da * 5; }
    da = da * getprop("/engines/engine[1]/thruster/rpm") / 30000;
    if (getprop("/sim/current-view/internal")==1) { da = da / 2; }
    setprop("/engines/engine[1]/thruster/noise-coef",da);

    settimer ( Propeller_noise , 0 );
}
settimer ( Propeller_noise , 2 );

ZadnaCinnost = func {
    return 0;
}

# initialization of lights switches
setprop("/controls/switches/lgh-beacon-sw",0);
setprop("/controls/switches/lgh-navigation-sw",0);
setprop("/controls/switches/lgh-search1-sw",0);
setprop("/controls/switches/lgh-search2-sw",0);
setprop("/controls/switches/lgh-passenger2-sw",0);
setprop("/controls/switches/lgh-passenger1-sw",0);
setprop("/controls/switches/cabin-lights-sw",0);
setprop("/controls/switches/cabin-lighting-sw",0);
setprop("/controls/switches/instrument-lights-stby-sw",0);
setprop("/controls/switches/instrument-lights-2-sw",0);
setprop("/controls/switches/lgh-static-ice-sw",0);

# initialization of electrical system nodes (for windows compatibility)

setprop("/systems/electrical/suppliers/battery[0]",28);
setprop("/systems/electrical/suppliers/battery[1]",28);
setprop("/systems/electrical/suppliers/generator[0]",28);
setprop("/systems/electrical/suppliers/generator[1]",28);
setprop("/systems/electrical/suppliers/alternator[0]",28);
setprop("/systems/electrical/suppliers/alternator[1]",28);
setprop("/systems/electrical/suppliers/external[0]",28);
setprop("/systems/electrical/outputs/bus28v",28);
setprop("/systems/electrical/outputs/busbat28v",28);
setprop("/systems/electrical/outputs/bus28v1",28);
setprop("/systems/electrical/outputs/bus28v2",28);
setprop("/systems/electrical/outputs/bus115v",28);
setprop("/systems/electrical/outputs/bus115v1",28);
setprop("/systems/electrical/outputs/bus115v2",28);
setprop("/systems/electrical/outputs/bus26v",28);
setprop("/systems/electrical/outputs/bus36v",28);
setprop("/systems/electrical/outputs/bus36v1",28);
setprop("/systems/electrical/outputs/bus36v2",28);
setprop("/systems/electrical/outputs/bus-alt115v",28);
setprop("/systems/electrical/outputs/bus-alt115v1",28);
setprop("/systems/electrical/outputs/bus-alt115v2",28);
setprop("/systems/electrical/outputs/cabin-lights",0);
setprop("/systems/electrical/outputs/instrument-lights",28);
setprop("/systems/electrical/outputs/instrument-lights-2",0);
setprop("/systems/electrical/outputs/instrument-lights-stby",0);
setprop("/systems/electrical/outputs/cabin-lighting",0);
setprop("/systems/electrical/outputs/passenger-1-lights",0);
setprop("/systems/electrical/outputs/passenger-2-lights",0);
setprop("/systems/electrical/outputs/beacon-lights",28);
setprop("/systems/electrical/outputs/navigation-lights",28);
setprop("/systems/electrical/outputs/landing-lights",28);
setprop("/systems/electrical/outputs/instrument-lights",28);
setprop("/systems/electrical/outputs/seat-belts",28);
setprop("/systems/electrical/outputs/cwd-englh",28);
setprop("/systems/electrical/outputs/cwd-engrh",28);
setprop("/systems/electrical/outputs/cwd-airframe",28);
setprop("/systems/electrical/outputs/cwd-electrical",28);
setprop("/systems/electrical/outputs/cwd-electrical-spec",28);
setprop("/systems/electrical/outputs/cwd-others",28);
setprop("/systems/electrical/outputs/firesgn-englh",28);
setprop("/systems/electrical/outputs/firesgn-engrh",28);
setprop("/systems/electrical/outputs/firesgn-bag-front",28);
setprop("/systems/electrical/outputs/firesgn-bag-aft",28);
setprop("/systems/electrical/outputs/turn-indicator[0]",28);
setprop("/systems/electrical/outputs/turn-indicator[1]",28);
setprop("/systems/electrical/outputs/gyro",28);
setprop("/systems/electrical/outputs/hsi",28);
setprop("/systems/electrical/outputs/radioaltimeter",28);
setprop("/systems/electrical/outputs/weatherradar",28);
setprop("/systems/electrical/outputs/nav[0]",28);
setprop("/systems/electrical/outputs/nav[1]",28);
setprop("/systems/electrical/outputs/dme[0]",28);
setprop("/systems/electrical/outputs/dme[1]",28);
setprop("/systems/electrical/outputs/adf[0]",28);
setprop("/systems/electrical/outputs/adf[1]",28);
setprop("/systems/electrical/outputs/mkr[0]",28);
setprop("/systems/electrical/outputs/mkr[1]",28);
setprop("/systems/electrical/outputs/ssr[0]",28);
setprop("/systems/electrical/outputs/ssr[1]",28);
setprop("/systems/electrical/outputs/comm[0]",28);
setprop("/systems/electrical/outputs/comm[1]",28);
setprop("/systems/electrical/outputs/flight-rec",28);
setprop("/systems/electrical/outputs/intercom[0]",28);
setprop("/systems/electrical/outputs/intercom[1]",28);
setprop("/systems/electrical/outputs/marker[0]",28);
setprop("/systems/electrical/outputs/xpdr[0]",28);
setprop("/systems/electrical/outputs/xpdr[1]",28);
setprop("/systems/electrical/outputs/feather-pump-lh",28);
setprop("/systems/electrical/outputs/feather-pump-rh",28);
setprop("/systems/electrical/outputs/feather-auto-lh",28);
setprop("/systems/electrical/outputs/feather-auto-rh",28);
setprop("/systems/electrical/outputs/abc",28);
setprop("/systems/electrical/outputs/spoilers",28);
setprop("/systems/electrical/outputs/flaps",28);
setprop("/systems/electrical/outputs/gear",28);
setprop("/systems/electrical/outputs/flaps",28);
setprop("/systems/electrical/outputs/heading-indicator-gyro[0]",28);
setprop("/systems/electrical/outputs/heading-indicator-gyro[1]",28);
setprop("/systems/electrical/outputs/heading-indicator-selsyn",28);
setprop("/systems/electrical/outputs/attitude-indicator-gyro[0]",28);
setprop("/systems/electrical/outputs/attitude-indicator-gyro[1]",28);
setprop("/systems/electrical/outputs/attitude-indicator-gyro[2]",28);
setprop("/systems/electrical/outputs/autopilot",28);
setprop("/systems/electrical/outputs/fuelpump-lh",28);
setprop("/systems/electrical/outputs/fuelpump-rh",28);
setprop("/systems/electrical/outputs/starter-lh",28);
setprop("/systems/electrical/outputs/starter-rh",28);
setprop("/systems/electrical/outputs/ielu-lh",28);
setprop("/systems/electrical/outputs/ielu-rh",28);
setprop("/systems/electrical/outputs/turn-coordinator",28);
setprop("/systems/electrical/outputs/static-ice-light",28);
setprop("/systems/electrical/outputs/ice-detect-static",28);
setprop("/systems/electrical/outputs/ice-detect-rotary",28);
setprop("/systems/electrical/outputs/deicing-airframe",28);
setprop("/systems/electrical/outputs/deicing-stall",28);
setprop("/systems/electrical/outputs/deicing-static1",28);
setprop("/systems/electrical/outputs/deicing-static2",28);
setprop("/systems/electrical/outputs/deicing-pitot1",28);
setprop("/systems/electrical/outputs/deicing-pitot2",28);
setprop("/systems/electrical/outputs/deicing-ws-heating-lh",28);
setprop("/systems/electrical/outputs/deicing-ws-heating-rh",28);
setprop("/systems/electrical/outputs/separator-vane-rh",28);
setprop("/systems/electrical/outputs/separator-vane-lh",28);


setprop("/instrumentation/nav[0]/heading-magnetic",0);
setprop("/instrumentation/nav[1]/heading-magnetic",0);

# setprop("/systems/fire/fire-englh1",1);

