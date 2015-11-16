
# Test!

dialog = nil;
x=1;
q=nil;

showDialog = func {
    x=x+1;
    
	name = "l410-help";
	if (dialog != nil) {
		fgcommand("dialog-close", props.Node.new({ "dialog-name" : name }));
		dialog = nil;
		return;
	}

	dialog = gui.Widget.new();
	dialog.set("layout", "vbox");
	dialog.set("name", name);
	dialog.set("x", -40);
	dialog.set("y", -40);

	# "window" titlebar
	titlebar = dialog.addChild("group");
	titlebar.set("layout", "hbox");
	titlebar.addChild("empty").set("stretch", 1);
	titlebar.addChild("text").set("label", "L410");
	titlebar.addChild("empty").set("stretch", 1);

	dialog.addChild("hrule").addChild("dummy");
	w = titlebar.addChild("button");
	w.set("pref-width", 16);
	w.set("pref-height", 16);
	w.set("legend", "");
	w.set("default", 1);
	w.set("keynum", 27);
	w.set("border", 1);
	w.prop().getNode("binding[0]/command", 1).setValue("nasal");
	w.prop().getNode("binding[0]/script", 1).setValue("l410-dialog.dialog = nil");
	w.prop().getNode("binding[1]/command", 1).setValue("dialog-close");

    # -----------------------------------

	t = dialog.addChild("group");
	t.set("layout", "hbox");

    cb=t.addChild("combo");
    cb.set("pref-width",200);
    cb.set("value","Taxi to runway");
    cb.set("value[1]","Take off");
    cb.set("value[2]","Land");

	t = dialog.addChild("group");
	t.set("layout", "hbox");
	r=t.addChild("checkbox");
    r.set("label", "Using autopilot");
    r.set("pref-width",200);

	t = dialog.addChild("group");
	t.set("layout", "hbox");
	q=titlebar.addChild("text");
    q.set("label", "0123456789");
    q.set("property", "/sim/test");

    # -----------------------------------
	# finale
	dialog.addChild("empty").set("pref-height", "3");
	fgcommand("dialog-new", dialog.prop());
	gui.showDialog(name);
}

setprop("/sim/test",0);

rrr = func {
    x=x+1;
    setprop("/sim/test",x);
    settimer(rrr,2);
}

settimer(rrr,2);
