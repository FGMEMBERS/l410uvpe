
#functions for com
modulo = func {
	r = arg[0] / arg[1];
	i = int (r);
	r = r - i;
	r = r * arg[1];
	return r;
}

com_round_freq = func {

    f1 = getprop("/instrumentation/comm[0]/frequencies/selected-mhz");
    f1 = f1*10000;
    f1 = int(f1+0.5);
    mf1 = modulo(f1,10);
    f1 = f1/10000;
    if (mf1>8 or mf1<2) {
        f1 = f1*1000;
        f1 = int(f1+0.5);
        f1 = f1/1000;
    }
    if (getprop("/instrumentation/comm[0]/sel[0]")==1) {
        f1 = f1 * 40;
        f1 = int(f1);
        f1 = f1 / 40;
    }
    setprop("/instrumentation/comm[0]/frequencies/selected-mhz",f1);
    
    f1 = getprop("/instrumentation/comm[1]/frequencies/selected-mhz");
    f1 = f1*10000;
    f1 = int(f1+0.5);
    mf1 = modulo(f1,10);
    f1 = f1/10000;
    if (mf1>8 or mf1<2) {
        f1 = f1*1000;
        f1 = int(f1+0.5);
        f1 = f1/1000;
    }
    if (getprop("/instrumentation/comm[1]/sel[0]")==1) {
        f1 = f1 * 40;
        f1 = int(f1);
        f1 = f1 / 40;
    }
    setprop("/instrumentation/comm[1]/frequencies/selected-mhz",f1);

}
