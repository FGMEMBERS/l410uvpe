##
# arg[0] is the aileron increment
# arg[1] is the autopilot target heading increment
incAileron = func {
      aileron = props.globals.getNode("/controls/flight/aileron");
      if ( aileron.getValue() == nil ) {
        aileron.setValue( 0.0 );
      }
      aileron.setValue(aileron.getValue() + arg[0]);
      if ( aileron.getValue() < -1.0 ) {
        aileron.setValue( -1.0 );
      }
      if ( aileron.getValue() > 1.0 ) {
        aileron.setValue( 1.0 );
      }
}

##
# arg[0] is the elevator increment
# arg[1] is the autopilot target alitude increment
incElevator = func {
      elevator = props.globals.getNode("/controls/flight/elevator");
      if ( elevator.getValue() == nil ) {
        elevator.setValue( 0.0 );
      }
      elevator.setValue(elevator.getValue() + arg[0]);
      if ( elevator.getValue() < -1.0 ) {
        elevator.setValue( -1.0 );
      }
      if ( elevator.getValue() > 1.0 ) {
        elevator.setValue( 1.0 );
      }
}

centerFlightControls = func {
    setprop("/controls/flight/elevator", 0);
    setprop("/controls/flight/aileron", 0);
    setprop("/controls/flight/rudder", 0);
}
