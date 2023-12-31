COMMENT
	
Integrate and Fire Unit

Rather than control v, when threshold is reached a strong
current (gON) is switched on for spikedur, the amplitude of the
spike is determined by the equilibrium potential of gON (eON).
At offset gOFF is turned on for one time step.  The repolarizing 
potential is determined by the equilibrim potential of gOFF (eOFF).

I think I did this because I could not figure out how
to control v (outside of fadvance), which is transparently updated.

The AHP consists of an instantaneous current gAHP with time
constant tau

REBOUND: to simulate rebound I made the Eleak increase (thus increasing)
	resting membrane potential) whenever the cell is hyperpolarized.
ENDCOMMENT

UNITS {
	(mV) = (millivolt)
	(mA) = (milliamp)
}

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX ExIAF 
    NONSPECIFIC_CURRENT i
    GLOBAL spikedur, refact, tauAHP, eAHP, gAHPbar
	RANGE Thr, lastspike
	RANGE gPAS, ePAS, gAHP, AHPon, gON, gOFF, eON, eOFF
    :FOR PLASTICITY
	RANGE SetCa, AvgCa, Ca, tauDCCa, Gain, PlasThr
	RANGE ScaleFactor, Induction
    GLOBAL SCALE
	GLOBAL tstop
}


PARAMETER {
    v
	i		(mA/cm2)

	gPAS = 0.001			(mho/cm2)
	ePAS = -60				(mV)
	ePASconst = -60
	Thr	   = -40	(mv)
	ThrConst = -40

	spikedur = 1	(ms)
	refact   = 2.0	(ms)

	gONconst  = 1 	(mho/cm2)
	gOFFconst = 1  (mho/cm2)
	eON  = 40		(mV)
	eOFF = -60		(mV)

	tauAHP   = 0.1 	(/ms)		: 1/tau = actual time constant of gAHP decay
	gAHPbar = 0.00005 (mho/cm2)	: peak of AHP current
	eAHP    = -90 	(mv)

	SetCa = 1
	tauDCCa = 10                  :  in # of trials
    tstop
    SCALE = 1                   : USED TO GATE SCALING PLASTICITY	

}

ASSIGNED {
	lastspike
	gAHP 		(mho/cm2)
	AHPon				: turns AHP on after spike ends

	gON		(mho/cm2)
	gOFF		(mho/cm2)

    Ca
	AvgCa
    PlasThr
    Gain
    ScaleFactor
	Induction
    
}


INITIAL {
	ePAS = ePASconst
	gAHP = 0
	AHPon	  = -9e4

	gON = 0
	gOFF = 0

	lastspike = -9e4
	
    Ca=0
    Induction = 0
    

}

BREAKPOINT {
	SOLVE update
	i = gPAS*(v-ePAS) + gAHP*(v-eAHP)+gON*(v-eON)+gOFF*(v-eOFF)
}

PROCEDURE update() { LOCAL q, dv
: TURN ON AND OFF gON and gOFF to generate ACTION POTENTIAL
   gON = 0
   gOFF = 0
   q = (t-lastspike) - spikedur 

   if (q>refact) {				: refactory period over?
		if (v>Thr) {			: threshod reached?
			gON = gONconst		: turn spike current on
			lastspike = t
			Ca = Ca+1
		}
	}
	else if ( q < 0 ) {			: spike still on
		gON=gONconst			
	} 
	else if (v > 0) {				: turn spike off
		gOFF = gOFFconst
		gAHP = gAHP + gAHPbar
		AHPon = t
	}
	gAHP = gAHP - gAHP*tauAHP*dt

::: INDUCTION :::
::: HACK SO THAT INDUCTION IS RUN ON THE SECOND TO LAST TIMESTEP
    if ( t>(tstop-(2*dt)+dt/2) ) {
        : Induction==0(means that it has not got to INDUCTION yet
        : SCALE!=0 (means you are in a plastic mode)
        if (Induction==0 && SCALE!=0) {
            SOLVE INDUCTION
	    }
	}    
::: END INDUCTION :::


}                              ::: END UPDATE :::	
                       

PROCEDURE INDUCTION() {

::: INDUCTION :::
    AvgCa = AvgCa+(Ca - AvgCa)/tauDCCa
    PlasThr=(AvgCa^2)/SetCa
    Gain = (Ca-PlasThr)
    ScaleFactor = 1+(0.05*(SetCa-AvgCa)/(SetCa+AvgCa))*SCALE
    ::: Triggers PLASTICITY IN EPSPplas
    Induction = 1       
    :VERBATIM
	:    printf("INDUCTIONExIAF		t=%f		Ca=%f		%f\n",t,Ca,ScaleFactor);
    :ENDVERBATIM
::: END INDUCTION :::

}