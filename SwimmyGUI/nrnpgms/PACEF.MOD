TITLE pacef.mod  lets hope this does it
 
 
UNITS {
        (mA) = (milliamp)
        (mV) = (millivolt)
}
 
NEURON {
        SUFFIX pacef
        NONSPECIFIC_CURRENT il
        RANGE  gmax, e, a, b, T, c0, g0
}
 
PARAMETER {
        v (mV)
        dt (ms)
        gmax = .1 (siemens/cm2)
        e= -80 (mV)
        a = .01
        b= .01
        T = 1
        g0=0
        c0=0
}
 
STATE {
        c g
}
 
ASSIGNED {
        il (mA/cm2)
}
 
BREAKPOINT {
        SOLVE states
        il = g*(v - e)
}
 
UNITSOFF
 
INITIAL {
  c=c0
  g=g0
}

PROCEDURE states() { 
if (g>0) {g=g-b*dt}
else
  {g=0
   if (v>0)
     {if (c<T) {c=c+ a*dt}
      else
        {c=0
         g=gmax}
     }
   }
}
 
UNITSON

