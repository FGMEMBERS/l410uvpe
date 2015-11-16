
# autopilot for L410

autopilot_tested = 0;
test_in_progress = 0;
test_failed = 1;

nav_armed=0;
apr_armed=0;
gs_armed=0;
alt_armed=0; alt_alert_disp_timeout=0;
vs_armed=0;
cws_btn_pressed=0;
ann_mode_ap = 0;
ann_mode_trim = 0;


trim_dn_btn_pressed=0;
trim_up_btn_pressed=0;
cws_trim_dn_btn_pressed=0;
cws_trim_up_btn_pressed=0;
ap_flash_time=0;
yd_flash_time=0;

modulo = func {
	r = arg[0] / arg[1];
	i = int (r);
	r = r - i;
	r = r * arg[1];
	return r;
}

#numbers:

inc_value_fine= func {
    if (getprop("/instrumentation/autopilot/as-vs-sw")==1) {
        vs=getprop("/instrumentation/autopilot/set-vs");
        vs = int(vs/100)*100;
        if (vs+100 > 5000) {
            vs=4900;
        }
        setprop("/instrumentation/autopilot/set-vs",vs+100);
        setprop("/instrumentation/autopilot/selected-vs",vs+100);
        setprop("/instrumentation/autopilot/as-vsdispl",1);
    } else {
        alt=getprop("/instrumentation/autopilot/selected-alt");
        if (alt+100 > 50000) {
            alt=49900;
        }
        setprop("/instrumentation/autopilot/selected-alt",alt+100);
        setprop("/instrumentation/autopilot/as-vsdispl",0);
    }
}

dec_value_fine= func {
    if (getprop("/instrumentation/autopilot/as-vs-sw")==1) {
        vs=getprop("/instrumentation/autopilot/set-vs");
        vs = int(vs/100)*100;
        if (vs-100 < -5000) {
            vs=-4900;
        }
        setprop("/instrumentation/autopilot/set-vs",vs-100);
        setprop("/instrumentation/autopilot/selected-vs",vs-100);
        setprop("/instrumentation/autopilot/as-vsdispl",1);
    } else {
        alt=getprop("/instrumentation/autopilot/selected-alt");
        if (alt-100 < 0) {
            alt=100;
        }
        setprop("/instrumentation/autopilot/selected-alt",alt-100);
        setprop("/instrumentation/autopilot/as-vsdispl",0);
    }
}

inc_value= func {
    if (getprop("/instrumentation/autopilot/as-vs-sw")==1) {
        vs=getprop("/instrumentation/autopilot/set-vs");
        vs = int(vs/100)*100;
        if (vs+1000 > 5000) {
            vs=4000;
        }
        setprop("/instrumentation/autopilot/set-vs",vs+1000);
        setprop("/instrumentation/autopilot/selected-vs",vs+1000);
        setprop("/instrumentation/autopilot/as-vsdispl",1);
    } else {
        alt=getprop("/instrumentation/autopilot/selected-alt");
        if (alt+1000 > 50000) {
            alt=49000;
        }
        setprop("/instrumentation/autopilot/selected-alt",alt+1000);
        setprop("/instrumentation/autopilot/as-vsdispl",0);
    }
}

dec_value= func {
    if (getprop("/instrumentation/autopilot/as-vs-sw")==1) {
        vs=getprop("/instrumentation/autopilot/set-vs");
        vs = int(vs/100)*100;
        if (vs-1000 < -5000) {
            vs=-4000;
        }
        setprop("/instrumentation/autopilot/set-vs",vs-1000);
        setprop("/instrumentation/autopilot/selected-vs",vs-1000);
        setprop("/instrumentation/autopilot/as-vsdispl",1);
    } else {
        alt=getprop("/instrumentation/autopilot/selected-alt");
        if (alt-1000 < 0) {
            alt=1000;
        }
        setprop("/instrumentation/autopilot/selected-alt",alt-1000);
        setprop("/instrumentation/autopilot/as-vsdispl",0);
    }
}

#buttons:

activate_fd= func () {
    if (getprop("/instrumentation/autopilot/mode-fd-on")==0 and autopilot_tested==1) {
        setprop("/autopilot/settings/target-pitch-deg",getprop("/orientation/pitch-deg"));
    }
    setprop("/instrumentation/autopilot/mode-fd-on",1);
}
deactivate_fd= func {
    setprop("/instrumentation/autopilot/mode-fd-on",0);
    
    deactivate_ap();
    deactivate_yd();
    deactivate_hb();
    deactivate_alt();
    deactivate_hdg();
    deactivate_nav();
    deactivate_apr();
    deactivate_bc();

    nav_armed=0;
    apr_armed=0;
    gs_armed=0;
    alt_armed=0;
    vs_armed=0;
}

activate_ap= func {
    activate_yd();
    setprop("/instrumentation/autopilot/mode-ap-on",1);
    ap_flash_time = 0;
}
deactivate_ap= func {
    if (getprop("/instrumentation/autopilot/mode-ap-on")==1) {
  	    setprop("/instrumentation/autopilot/mode-ap-on",0);
	    ap_flash_time = getprop("/sim/time/elapsed-sec");
    }
}

activate_yd= func {
    setprop("/instrumentation/autopilot/mode-yd-on",1);
    yd_flash_time = 0;
}
deactivate_yd= func {
    if (getprop("/instrumentation/autopilot/mode-ap-on")<1) {
        if (getprop("/instrumentation/autopilot/mode-yd-on")==1) {
	        setprop("/instrumentation/autopilot/mode-yd-on",0);
	        yd_flash_time = getprop("/sim/time/elapsed-sec");
        }
    }
}

activate_hb= func {
    setprop("/instrumentation/autopilot/mode-hb-on",1);
}
deactivate_hb= func {
    setprop("/instrumentation/autopilot/mode-hb-on",0);
}

activate_alt= func {
    setprop("/instrumentation/autopilot/mode-alt-on",1);
    deactivate_apr();
    alt_armed=0;
    vs_armed=0;
}
deactivate_alt= func {
    setprop("/instrumentation/autopilot/mode-alt-on",0);
    setprop("/autopilot/settings/target-pitch-deg",getprop("/orientation/pitch-deg"));
}

activate_hdg= func {
    setprop("/instrumentation/autopilot/mode-hdg-on",1);
    deactivate_nav();
    deactivate_apr();
}
deactivate_hdg= func {
    setprop("/instrumentation/autopilot/mode-hdg-on",0);
}

activate_nav= func {
    #deactivate_hdg();
    deactivate_apr();
    setprop("/instrumentation/autopilot/mode-nav-on",1);
}
deactivate_nav= func {
    setprop("/instrumentation/autopilot/mode-nav-on",0);
    nav_armed=0;
}

activate_apr= func {
    #deactivate_hdg();
    deactivate_nav();
    deactivate_bc();
    setprop("/instrumentation/autopilot/mode-apr-on",1);
}
deactivate_apr= func {
    deactivate_bc();
    setprop("/instrumentation/autopilot/mode-apr-on",0);
    apr_armed=0;
    gs_armed=0;
    setprop("/autopilot/settings/target-pitch-deg",getprop("/orientation/pitch-deg"));
}

activate_bc= func {
    setprop("/instrumentation/autopilot/mode-bc-on",1);
    apr_armed=1;
    gs_armed=1;
}
deactivate_bc= func {
    setprop("/instrumentation/autopilot/mode-bc-on",0);
}
 

fd_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-fd-on")==1) {
            deactivate_fd();
        } else {
            activate_fd();
        }
    }
}

ap_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-fd-on")==1) {
            if (getprop("/instrumentation/autopilot/mode-ap-on")==0) {
                activate_fd();
                activate_ap();
            } else {
                deactivate_ap();
            }
        }
    }
}

alt_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-alt-on")==1) {
            deactivate_alt();
        } else {
            activate_fd();
            activate_alt();
            setprop("/autopilot/settings/target-altitude-ft",getprop("/instrumentation/altimeter/indicated-altitude-ft"));
        }
    }    
}

hdg_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-hdg-on")==1) {
            deactivate_hdg();
        } else {
            activate_fd();
            activate_hdg();
        }
    }
}

nav_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-nav-on")==1) {
            deactivate_nav();
        } else {
            activate_fd();
            setprop("/instrumentation/autopilot/mode-nav-on",1);
            nav_armed=1;
            deactivate_apr();
        }
    }
}

apr_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-apr-on")==1) {
            deactivate_apr();
        } else {
            activate_fd();
            setprop("/instrumentation/autopilot/mode-apr-on",1);
            apr_armed=1;
            gs_armed=1;
            deactivate_nav();
        }
    }
}

as_alt_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (alt_armed==0) {
            alt_armed=1;
            deactivate_alt();
        } else {
            alt_armed=0;
            setprop("/autopilot/settings/target-pitch-deg",getprop("/orientation/pitch-deg"));
        }
    }
}

as_vs_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (vs_armed==0) {
            vs_armed=1;
            deactivate_alt();
            deactivate_apr();
            if (getprop("/instrumentation/autopilot/as-vs-sw")==1) {
                setprop("/autopilot/internal/gs-rate-of-climb",getprop("/instrumentation/autopilot/selected-vs"));
            } else {
                setprop("/instrumentation/autopilot/selected-vs",getprop("/velocities/vertical-speed-fps")*60.0);
                setprop("/instrumentation/autopilot/as-vsdispl",1);
                settimer(autopilot_current_vs_disp_off,5);
            }
            setprop("/autopilot/settings/target-vertical-speed-fpm",getprop("/instrumentation/autopilot/selected-vs"));
        } else {
            vs_armed=0;
            setprop("/autopilot/settings/target-pitch-deg",getprop("/orientation/pitch-deg"));
        }
    }
}

bc_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-bc-on")==1) {
            deactivate_bc();
        } else {
            deactivate_alt();
            activate_apr();
	        activate_bc();
        }
    }
}

yd_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
        if (getprop("/instrumentation/autopilot/mode-yd-on")==1) {
            deactivate_yd();
        } else {
            activate_yd();
        }
    }
}

hb_btn= func {
    if (getprop("/systems/electrical/outputs/autopilot")>10) { 
	if (getprop("/instrumentation/autopilot/mode-apr-on")==0 or apr_armed==1) {
	    if (getprop("/instrumentation/autopilot/mode-hb-on")==1) {
		deactivate_hb();
	    } else {
		activate_hb();
	    }
	}
    }
}

cws_btn= func {
    cws_btn_pressed=1;
    activate_fd();
}

cws_btn_modup= func {
    cws_btn_pressed=0;
    if (getprop("/instrumentation/autopilot/mode-alt-on")) {
        setprop("/autopilot/settings/target-altitude-ft",getprop("/instrumentation/altimeter/indicated-altitude-ft"));
    } else {
        setprop("/autopilot/settings/target-pitch-deg",getprop("/orientation/pitch-deg"));
    }
}

cws_trim_dn_btn= func {
    deactivate_ap();
    cws_trim_dn_btn_pressed=1;
}

cws_trim_dn_btn_modup= func {
    cws_trim_dn_btn_pressed=0;
}

cws_trim_up_btn= func {
    deactivate_ap();
    cws_trim_up_btn_pressed=1;
}

cws_trim_up_btn_modup= func {
    cws_trim_up_btn_pressed=0;
}

trim_dn_btn= func {
    trim_dn_btn_pressed=1;
}

trim_dn_btn_modup= func {
    trim_dn_btn_pressed=0;
}

trim_up_btn= func {
    trim_up_btn_pressed=1;
}

trim_up_btn_modup= func {
    trim_up_btn_pressed=0;
}

ap_disconnect_btn= func{
    deactivate_ap();
    deactivate_fd();
    deactivate_alt();
    deactivate_apr();
    deactivate_hdg();
    deactivate_nav();
    deactivate_yd();
    deactivate_hb();
    deactivate_bc();
}

test_btn= func {
    if (test_in_progress==0) {
        ap_disconnect_btn();
        test_failed=0;
        setprop("/instrumentation/autopilot/bulbs-test-on",1);
        test_in_progress=1;
        autopilot_tested=0;
    }
}

autopilot_frame = func {
    if (trim_dn_btn_pressed==1) {
    	if (getprop("/instrumentation/autopilot/mode-alt-on")==1) {
    	    controls.slewProp("/autopilot/settings/target-altitude-ft", -8.3);
    	} elsif (getprop("/instrumentation/autopilot/mode-vs-on")==1) {
	        controls.slewProp("/autopilot/settings/target-vertical-speed-fpm", -100);
	    } elsif (getprop("/instrumentation/autopilot/mode-fd-on")==1) {
    	    controls.slewProp("/autopilot/settings/target-pitch-deg", -1);
    	}
    } elsif (trim_up_btn_pressed==1) {
    	if (getprop("/instrumentation/autopilot/mode-alt-on")==1) {
	        controls.slewProp("/autopilot/settings/target-altitude-ft", 8.3);
	    } elsif (getprop("/instrumentation/autopilot/mode-vs-on")==1) {
    	    controls.slewProp("/autopilot/settings/target-vertical-speed-fpm", 100);
    	} elsif (getprop("/instrumentation/autopilot/mode-fd-on")==1) {
	        controls.slewProp("/autopilot/settings/target-pitch-deg", 1);
	    }
    }

    if (cws_trim_dn_btn_pressed==1) {
    	controls.elevatorTrim(1);
    }
    if (cws_trim_up_btn_pressed==1) {
    	controls.elevatorTrim(-1);
    }
    
    settimer ( autopilot_frame , 0 );
}

autopilot_75ms = func {
    alt_req=0; vspeed=1;
    if (getprop("/instrumentation/autopilot/ann-alt-on")==1) {
        alt_req=getprop("/autopilot/internal/target-climb-rate-fps");
    } else {
    if (getprop("/instrumentation/autopilot/ann-apr-gs-on")==1) {
        alt_req=getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/gs-rate-of-climb");
    } else {
    if (getprop("/instrumentation/autopilot/as-vs-flag")==1) {
        alt_req=getprop("/autopilot/settings/target-vertical-speed-fpm")/60.0;
    } else {
        alt_req=getprop("/autopilot/settings/target-pitch-deg");
        vspeed=0;
    }}}
    
    hdg_req=0;
#    if (getprop("/instrumentation/autopilot/ann-hdg-on")==1 or
#        (getprop("/instrumentation/autopilot/ann-apr-on")==1 and getprop("/instrumentation/autopilot/ann-apr-arm-on")==0) or
#        (getprop("/instrumentation/autopilot/ann-nav-on")==1 and getprop("/instrumentation/autopilot/ann-nav-arm-on")==0)) {
        hdg_req=getprop("/autopilot/internal/target-roll-deg");
#    }
    
    setprop("/instrumentation/autopilot/requested_roll_ind",hdg_req);
    setprop("/instrumentation/autopilot/requested_pitch",alt_req);
    
    if (vspeed==1) {
        vsn = -( alt_req - getprop("/velocities/vertical-speed-fps") ) * 0.6;
        setprop("/instrumentation/autopilot/requested_pitch_ind",vsn);
    } else {
        vsn = -( alt_req - getprop("/orientation/pitch-deg") ) * 3;
        setprop("/instrumentation/autopilot/requested_pitch_ind",vsn);
    }
    
    settimer ( autopilot_75ms , 0.075 );
}

autopilot_300ms = func {
    
    # check power on
    fd_required_on = 1; 
    if (getprop("/systems/electrical/outputs/autopilot")<10 or autopilot_tested==0) { 
        fd_required_on = 0; 
        setprop("/instrumentation/autopilot/mode-ap-on",0);
        setprop("/instrumentation/autopilot/mode-fd-on",0);
        setprop("/instrumentation/autopilot/mode-alt-on",0);
        setprop("/instrumentation/autopilot/mode-hdg-on",0);
        setprop("/instrumentation/autopilot/mode-nav-on",0);
        setprop("/instrumentation/autopilot/mode-apr-on",0);
        setprop("/instrumentation/autopilot/mode-yd-on",0);
        setprop("/instrumentation/autopilot/mode-hb-on",0);
        setprop("/instrumentation/autopilot/mode-bc-on",0);
        
        if (getprop("/systems/electrical/outputs/autopilot")<10) {
            test_in_progress=0;
            setprop("/instrumentation/autopilot/bulbs-test-on",0);
            setprop("/instrumentation/autopilot/test-in-progress",0);
        }
        autopilot_tested=0;
    }
    # tady se pridaji dalsi podminky na vsechny pristroje, ktere musi fungovat, aby bylo mozne zapnout autopilota
    if (  
        getprop("/systems/electrical/outputs/elevator-trim")<10 or
        getprop("/systems/static[0]/serviceable")==0 or
        getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/serviceable")==0 or
        getprop("/systems/electrical/outputs/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]")<10 or
        getprop("/instrumentation/dme["~getprop("/autopilot/settings/nav-radio-selector")~"]/serviceable")==0 or
        getprop("/systems/electrical/outputs/dme["~getprop("/autopilot/settings/nav-radio-selector")~"]")<10 or
        getprop("/systems/electrical/outputs/radioaltimeter")<10 or

        getprop("/instrumentation/heading-indicator-selected/spin") < 0.9 or
        getprop("/systems/electrical/outputs/heading-indicator-selsyn") < 20 or

        getprop("/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/selected")~"]/serviceable")==0 or
        getprop("/systems/electrical/outputs/xpdr["~getprop("/instrumentation/xpdr-selected/selected")~"]")<10
    ) {
        deactivate_ap();
        test_failed=1;
        autopilot_tested=0;
    }
    #pokud probiha test, tak je vse v poradku a test muze projit
    if (test_in_progress>0) {
        if (test_in_progress > 18) {
            setprop("/instrumentation/autopilot/test-in-progress",0);
        } else {
            setprop("/instrumentation/autopilot/test-in-progress",1);
        }
        test_in_progress = test_in_progress + 1;
        if (test_in_progress > 9) {
            setprop("/instrumentation/autopilot/bulbs-test-on",0);
            ap_flash_time = getprop("/sim/time/elapsed-sec");
        }
        if (test_in_progress == 35) {
            ap_flash_time=0;
            setprop("/instrumentation/autopilot/test-in-progress",0);
            if (test_failed==0) {
                autopilot_tested=1;
            }
            test_in_progress=0;
        }
    }
        

    if (fd_required_on == 0) {
        deactivate_fd();
    }

    ann_fd = 0;
    ann_ap = 0;
    ann_alt = 0;
    ann_hdg = 0;
    ann_nav = 0;
    ann_nav_arm = 0;
    ann_apr = 0;
    ann_apr_arm = 0;
    ann_apr_gs = 0;
    ann_apr_ga = 0;
    ann_as_capture = 0;
    ann_bc = 0;
    ann_mode_yd = 0;
    ann_hb = 0;
    ann_mode_ap = 0;
    
    if (getprop("/instrumentation/autopilot/mode-fd-on")==1) { ann_fd=1; }
#    if (getprop("/instrumentation/autopilot/mode-ap-on")==1) { ann_ap=1; }
    if (getprop("/instrumentation/autopilot/mode-ap-on")==1) { ann_mode_ap=1; }

    current_heading_mode="wing-leveler";
    current_altitude_mode="pitch-hold";
    current_rudder_mode="none";
    
        #je-li aktivni computer autopilota:

        if (getprop("/instrumentation/autopilot/mode-alt-on")==1) { 
            ann_alt=1; 
            current_altitude_mode="altitude-hold";
        }
        if (getprop("/instrumentation/autopilot/mode-hdg-on")==1) { 
            ann_hdg=1; 
            current_heading_mode="dg-heading-hold";
        }

        if (getprop("/instrumentation/autopilot/mode-nav-on")==1) { 
            ann_nav=1;
            if (nav_armed==1) {
                ann_nav_arm = 1;
                if (getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/in-range")==1) {
                    if (abs(getprop("/autopilot/internal/adjustment"))<29) {
                        #pri priblizeni na 0.5 NM k radiale se prepne na aktivni
                        nav_armed=0;
                        deactivate_hdg();
                    }
                }
            }
            if (nav_armed==0) {
                current_heading_mode="nav1-hold";
            }
        }

        if (getprop("/instrumentation/autopilot/mode-apr-on")==1) { 
            ann_apr=1;
            if (apr_armed==1) {
                ann_apr_arm = 1;
                if (getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/in-range")==1) {
                    if (abs(getprop("/autopilot/internal/adjustment"))<29) {
                        #pri priblizeni na 0.5 NM k radiale se prepne na aktivni
                        apr_armed=0;
                        deactivate_hdg();
                    }
                }
            }
            if (apr_armed==0) {
                current_heading_mode="nav1-hold";
            }
            
            if (getprop("/instrumentation/autopilot/mode-bc-on")==0) {
                if (gs_armed==1) {
                    ann_apr_ga = 1;
                    if (getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/in-range")==1 and
                        getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/has-gs")==1 and
                        apr_armed == 0) {
                        if (getprop("/instrumentation/nav["~getprop("/autopilot/settings/nav-radio-selector")~"]/gs-needle-deflection")<1) {
                            #pri priblizeni pod +1 stupne k sestupovemu paprsku
                            gs_armed=0;
                            deactivate_alt();
                        }
                    }
                }
                if (gs_armed==0) {
                    ann_apr_gs = 1;
                    current_altitude_mode="gs1-hold";
                    alt_armed=0;
                    vs_armed=0;
                }
            } else {
                ann_bc = 1;
            }
        }

        current_heading_mode_ap = current_heading_mode;
        if (getprop("/instrumentation/autopilot/mode-hb-on")==1 and 
            ((getprop("/instrumentation/autopilot/mode-apr-on")==0 and
            getprop("/instrumentation/autopilot/mode-bc-on")==0) or apr_armed==1) ) { 
            ann_hb=1; 
            current_heading_mode="halfbank-"~current_heading_mode;
        }


        if (getprop("/instrumentation/autopilot/mode-yd-on")==1) { 
            ann_mode_yd=1; 
#            current_rudder_mode="rudder-coord";
        }
    #zobrazeni a zpracovani selektoru vysky:

    sel_alt = getprop("/instrumentation/autopilot/selected-alt");
    # setprop("/autopilot/settings/target-altitude-ft",sel_alt);
    if (abs(sel_alt-getprop("/instrumentation/altimeter/indicated-altitude-ft"))<20) {
        if (alt_armed==1) {
            setprop("/instrumentation/autopilot/as-alert-flag",1);
            settimer( autopilot_alert_off, 1.5);
            setprop("/autopilot/settings/target-altitude-ft",getprop("/instrumentation/autopilot/selected-alt"));
            activate_alt();
            alt_alert_disp_timeout=1;
        }
    }
    if ((abs(sel_alt-getprop("/instrumentation/altimeter/indicated-altitude-ft"))<1000 and 
        abs(sel_alt-getprop("/instrumentation/altimeter/indicated-altitude-ft"))>300  and
        alt_armed==1) 
        or
        (abs(getprop("/autopilot/settings/target-altitude-ft")-getprop("/instrumentation/altimeter/indicated-altitude-ft"))<1000 and 
        abs(getprop("/autopilot/settings/target-altitude-ft")-getprop("/instrumentation/altimeter/indicated-altitude-ft"))>300  and
        ann_alt==1 )) {
        setprop("/instrumentation/autopilot/as-alert-flag",1);
    } else {
        if (alt_alert_disp_timeout==0) {
            setprop("/instrumentation/autopilot/as-alert-flag",0);
        }
    }
    if (abs(sel_alt-getprop("/instrumentation/altimeter/indicated-altitude-ft"))<200 and 
        abs(sel_alt-getprop("/instrumentation/altimeter/indicated-altitude-ft"))>20  and
        alt_armed==1) {
        ann_as_capture = 1;
        setprop("/autopilot/settings/target-altitude-ft",getprop("/instrumentation/autopilot/selected-alt"));
        current_altitude_mode="altitude-hold";
    }

    #zobrazeni a zpracovani selektoru vertikalni rychlosti
    
    if (vs_armed==1 and ann_as_capture==0) {
        setprop("/instrumentation/autopilot/as-vs-flag",1);
        current_altitude_mode="vertical-speed-hold";
    } else {
        setprop("/instrumentation/autopilot/as-vs-flag",0);
    }

    #zobrazeni aktualnich hodnot:
    if (autopilot_tested==0) {
        setprop("/instrumentation/autopilot/ann-trim-on",1);
    } else {
        setprop("/instrumentation/autopilot/ann-trim-on",0);
    }

    setprop("/instrumentation/autopilot/tested",autopilot_tested);
    setprop("/instrumentation/autopilot/ann-fd-on",ann_fd);
    #setprop("/instrumentation/autopilot/ann-ap-on",ann_ap);
    setprop("/instrumentation/autopilot/ann-alt-on",ann_alt);
    setprop("/instrumentation/autopilot/ann-hdg-on",ann_hdg);
    setprop("/instrumentation/autopilot/ann-nav-on",ann_nav);
    setprop("/instrumentation/autopilot/ann-nav-arm-on",ann_nav_arm);
    setprop("/instrumentation/autopilot/ann-apr-on",ann_apr);
    setprop("/instrumentation/autopilot/ann-apr-arm-on",ann_apr_arm);
    # setprop("/instrumentation/autopilot/ann-apr-ga-on",ann_apr_ga);
    setprop("/instrumentation/autopilot/ann-apr-gs-on",ann_apr_gs);
    setprop("/instrumentation/autopilot/as-arm-flag",alt_armed);
    setprop("/instrumentation/autopilot/as-capture-flag",ann_as_capture);
    setprop("/instrumentation/autopilot/ann-bc-on",ann_bc);
    setprop("/instrumentation/autopilot/ann-mode-yd-on",ann_mode_yd);
    setprop("/instrumentation/autopilot/ann-hb-on",ann_hb);

    setprop("/autopilot/locks/heading",current_heading_mode);
    setprop("/autopilot/locks/altitude",current_altitude_mode);
    
    if (ann_mode_ap==1 and cws_btn_pressed==0) {
        setprop("/autopilot/locks/heading-ap",current_heading_mode_ap);
        setprop("/autopilot/locks/altitude-ap",current_altitude_mode);

        #trim slowly to no elevator deflection
        if (getprop("/controls/flight/elevator-ap")>0.01) {
            if (getprop("/controls/flight/elevator-trim")+0.002 < 1.0) {
                setprop("/controls/flight/elevator-trim",getprop("/controls/flight/elevator-trim")+0.002);
            }
        }
        if (getprop("/controls/flight/elevator-ap")<-0.01) {
            if (getprop("/controls/flight/elevator-trim")-0.002 > -1.0) {
                setprop("/controls/flight/elevator-trim",getprop("/controls/flight/elevator-trim")-0.002);
            }
        }

        if (current_heading_mode=="none") {
            setprop("/autopilot/locks/ailerons-off",0);
        } else {
            setprop("/autopilot/locks/ailerons-off",1);
        }
        if (current_altitude_mode=="none" or getprop("/instrumentation/autopilot/mode-bc-on")==1) {
            setprop("/autopilot/locks/elevator-off",0);
        } else {
            setprop("/autopilot/locks/elevator-off",1);
        }

    } else {
        setprop("/autopilot/locks/heading-ap","none");
        setprop("/autopilot/locks/altitude-ap","none");
        setprop("/autopilot/locks/ailerons-off",0);
        setprop("/autopilot/locks/elevator-off",0);
    }

    if (ap_flash_time > 0) {
	if (getprop("/sim/time/elapsed-sec") - ap_flash_time > 5) {
	    ap_flash_time = 0;
	} else {
	    setprop("/instrumentation/autopilot/ann-ap-on", ! getprop("/instrumentation/autopilot/ann-ap-on"));
	}
    } else {
        setprop("/instrumentation/autopilot/ann-ap-on", getprop("/instrumentation/autopilot/mode-ap-on"));
    }
    if (yd_flash_time > 0) {
	if (getprop("/sim/time/elapsed-sec") - yd_flash_time > 5) {
	    yd_flash_time = 0;
	} else {
	    setprop("/instrumentation/autopilot/ann-yd-on", ! getprop("/instrumentation/autopilot/ann-yd-on"));
	}
    } else {
        setprop("/instrumentation/autopilot/ann-yd-on", ann_mode_yd);
    }

    settimer ( autopilot_300ms , 0.3 );
    
    return;
}

setprop("/autopilot/settings/target-altitude-ft",0);
setprop("/autopilot/settings/target-pitch-deg",0);
setprop("/autopilot/settings/target-vertical-speed-fpm",0);
setprop("/velocities/vertical-speed-fps",0);
setprop("/orientation/pitch-deg",0);

setprop("/instrumentation/nav[0]/radials/target-radial-deg",0);
setprop("/instrumentation/nav[1]/radials/target-radial-deg",0);

settimer ( autopilot_300ms , 10 );
settimer ( autopilot_75ms , 10 );
settimer ( autopilot_frame , 10 );

# vypinace casove omezenych zobrazeni

autopilot_alert_off= func {
    setprop("/instrumentation/autopilot/as-alert-flag",0);
    alt_alert_disp_timeout=0;
}

autopilot_current_vs_disp_off= func {
    if (getprop("/instrumentation/autopilot/as-vs-sw")==0) {
        setprop("/instrumentation/autopilot/as-vsdispl",0);
    }
}


autopilot_nav_heading_error_deg_update= func {
    radio = getprop("/autopilot/settings/nav-radio-selector");
    adjustment = getprop("/instrumentation/nav["~radio~"]/indicated-heading-deflection-goal") * 5.0;
    if (adjustment < -30.0) { adjustment = -30; }
    if (adjustment > 30.0) { adjustment = 30; }

    if (getprop("/instrumentation/autopilot/mode-bc-on")==1) {
        adjustment = -adjustment;
    }

    setprop("/autopilot/internal/adjustment",adjustment);
    
    nav_target_auto_hdg_deg = getprop("/instrumentation/nav["~radio~"]/radials/target-radial-deg") + adjustment;

    if (getprop("/instrumentation/autopilot/mode-bc-on")==1) {
        nav_target_auto_hdg_deg = nav_target_auto_hdg_deg - 180 ;
    }
    
    if (nav_target_auto_hdg_deg < 0.0) { nav_target_auto_hdg_deg +=360; }
    if (nav_target_auto_hdg_deg >= 360.0) { nav_target_auto_hdg_deg -=360; }

    diff=nav_target_auto_hdg_deg - getprop("/orientation/heading-deg");
    if (diff <= -180.0) { diff += 360; }
    if (diff > 180.0) { diff -= 360; }

    setprop("/autopilot/internal/nav-heading-error-deg",diff);
    settimer(autopilot_nav_heading_error_deg_update,0.1);
    
    setprop("/autopilot/internal/gs-rate-of-climb",getprop("/instrumentation/nav["~radio~"]/gs-rate-of-climb"));
}

setprop("/autopilot/internal/nav-heading-error-deg",0.0);
settimer(autopilot_nav_heading_error_deg_update,10);

setprop("/velocities/vertical-speed-fps",0);
setprop("/orientation/pitch-deg",0);
