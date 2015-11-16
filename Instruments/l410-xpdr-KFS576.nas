
#functions for xpdr

modulo = func {
	r = arg[0] / arg[1];
	i = int (r);
	r = r - i;
	r = r * arg[1];
	return r;
}

xpdr_refresh_disp = func {
    prop_name = "/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/nasal-sel")~"]/";
    if (getprop(prop_name~"mode")==0 or getprop(prop_name~"external-sby")) {
        # jsme ve STBY modu
        setprop(prop_name~"an-sby",1);
        setprop(prop_name~"an-on",0);
        setprop(prop_name~"an-alt",0);
        setprop(prop_name~"an-idt",0);
        setprop(prop_name~"an-fl",0);
        setprop(prop_name~"an-r",0);

        setprop(prop_name~"disp",getprop(prop_name~"code"));
    }

    if (getprop(prop_name~"external-sby")==0) {
        if (getprop(prop_name~"mode")==1) {
            # jsme v ON modu
            setprop(prop_name~"an-sby",0);
            setprop(prop_name~"an-on",1);
            setprop(prop_name~"an-alt",0);
            setprop(prop_name~"an-idt",0);

            setprop(prop_name~"disp",getprop(prop_name~"code"));
        }
        if (getprop(prop_name~"mode")==2) {
            # jsme v ALT modu
            setprop(prop_name~"an-sby",0);
            setprop(prop_name~"an-on",0);
            setprop(prop_name~"an-alt",1);
            setprop(prop_name~"an-idt",0);

            setprop(prop_name~"disp",getprop(prop_name~"code"));
        }
        
        if (getprop(prop_name~"mode")>0 and getprop(prop_name~"mode")<3) {
            #neni-li STBY a TEST mod
            if (getprop(prop_name~"in-range")==0) {
                setprop(prop_name~"an-r",0);
            } else {
                #pokud jsme v ALT modu, tak je potreba zkontrolovat, zda funguje encoding alt. !!! (todo!)
                setprop(prop_name~"an-r",1);
            }
        }
    }
}

xpdr_set_code_down = func {
    prop_name = "/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/nasal-sel")~"]/";
    
    if (getprop(prop_name~"mode")==0) {
        i=1;
        for (n=0; n<getprop(prop_name~"sel-digit"); n=n+1) {
            i=i*10;
        }
        digit = int (modulo(getprop(prop_name~"code"),i*10) / i);
    
        digit = digit - 1;
        if (digit<0) {
            setprop(prop_name~"code",getprop(prop_name~"code")+i*7);
        } else {
            setprop(prop_name~"code",getprop(prop_name~"code")-i);
        }   
        xpdr_refresh_disp();
    }
}

xpdr_set_code_up = func {
    prop_name = "/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/nasal-sel")~"]/";
    
    if (getprop(prop_name~"mode")==0) {
        i=1;
        for (n=0; n<getprop(prop_name~"sel-digit"); n=n+1) {
            i=i*10;
        }
        digit = int (modulo(getprop(prop_name~"code"),i*10) / i);
    
        digit = digit + 1;
        if (digit>7) {
            setprop(prop_name~"code",getprop(prop_name~"code")-i*7);
        } else {
            setprop(prop_name~"code",getprop(prop_name~"code")+i);
        }
        xpdr_refresh_disp();
    }
}


xpdr_load_vfr_action = func {
    prop_name = "/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/nasal-sel")~"]/";
    if (getprop(prop_name~"knob-pr-time")>0) {
        setprop(prop_name~"knob-pr-time",getprop(prop_name~"knob-pr-time")+200);
        
        if (getprop(prop_name~"knob-pr-time")>3000) {
            setprop(prop_name~"code",getprop(prop_name~"code-vfr"));
            setprop(prop_name~"knob-pr-time",-1);
            sel_d=getprop(prop_name~"sel-digit") + 1;
            if (sel_d>3) { sel_d=0; }
            setprop(prop_name~"sel-digit",sel_d);
            xpdr_refresh_disp();
        } else {
            settimer ( xpdr_load_vfr_action , 0.2 );
        }
    }
}

xpdr_start_vfr_load = func {
    prop_name = "/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/nasal-sel")~"]/";
    setprop(prop_name~"knob-pr-time",1);
    settimer ( xpdr_load_vfr_action , 0.2 );
}

xpdr_stop_vfr_load = func {
    prop_name = "/instrumentation/xpdr["~getprop("/instrumentation/xpdr-selected/nasal-sel")~"]/";
    setprop(prop_name~"knob-pr-time",0);
}

xpdr_mode_changed = func {
    xpdr_refresh_disp();
}

#inicialization
getprop("/instrumentation/xpdr-selected/nasal-sel",0);
xpdr_refresh_disp();
getprop("/instrumentation/xpdr-selected/nasal-sel",1);
xpdr_refresh_disp();
