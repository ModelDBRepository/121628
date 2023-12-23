TITLE hhca1.mod  
 
COMMENT
This is an attempt to remodel the hh mechanism to produce something more like
the Ca spikes of nerve terminals.  I have changed ena to 200 in this one but am 
still calling it ena.

 This is the original Hodgkin-Huxley treatment for the set of sodium, 
  potassium, and leakage channels found in the squid giant axon membrane.
  ("A quantitative description of membrane current and its application 
  conduction and excitation in nerve" J.Physiol. (Lond.) 117:500-544 (1952).)
 Membrane voltage is in absolute mV and has been reversed in polarity
  from the original HH convention and shifted to reflect a resting potential
  of -65 mV.
 Initialize this mechanism to steady-state voltage by calling
  rates_gsquid(v) from HOC, then setting m_gsquid=minf_gsquid, etc.
 Remember to set celsius=6.3 (or whatever) in your HOC file.
 See hh1.hoc for an example of a simulation using this model.
 SW Jaslove  6 March, 1992
ENDCOMMENT
 
UNITS {
        (mA) = (milliamp)
        (mV) = (millivolt)
}
COMMENT
Note: If I get rid of the useion statement, currents seem to be computed normally but they do not have any effect on v.  I don't know if this is because I don't have write ina, etc statements or because I haven't declared the ions.  I wonder if a nonspecific current statement would do ok instead since I don't want to use the Nernst equation, etc anyway.
ENDCOMMENT

NEURON {
        SUFFIX hhca1
        :USEION na  WRITE ina
        :USEION k  WRITE ik
        
        NONSPECIFIC_CURRENT il, ina, ik
        RANGE gnabar, gkbar, gl, el, mfact, hfact, nfact, ina, ik, ena, ek
        GLOBAL minf, hinf, ninf, mexp, hexp, nexp
}
 
PARAMETER {
        v (mV)
        celsius = 6.3 (degC)
        dt (ms)
        gnabar = .12 (mho/cm2)
        ena = 50 (mV)
        gkbar = .036 (mho/cm2)
        ek = -77.5 (mV)
        gl = .0003 (mho/cm2)
        el = -54.3 (mV)
        mfact = 1
        hfact = 1
        nfact = 1
}
 
STATE {
        m h n
}
 
ASSIGNED {
        ina (mA/cm2)
        ik (mA/cm2)
        il (mA/cm2)
        minf hinf ninf mexp hexp nexp
}
 
BREAKPOINT {
        SOLVE states
        ina = gnabar*m*m*m*h*(v - ena)
        ik = gkbar*n*n*n*n*(v - ek)      
        il = gl*(v - el)
}
 
UNITSOFF
 
INITIAL {
	rates(v)
	m = minf
	h = hinf
	n = ninf
}

PROCEDURE states() {  :Computes state variables m, h, and n 
        rates(v)      :             at the current v and dt.
        m = m + mexp*(minf-m)
        h = h + hexp*(hinf-h)
        n = n + nexp*(ninf-n)
}
 
PROCEDURE rates(v) {  :Computes rate and other constants at current v.
                      :Call once from HOC to initialize inf at resting v.
        LOCAL  q10, tinc, alpha, beta, sum
        TABLE minf, mexp, hinf, hexp, ninf, nexp DEPEND dt, celsius, mfact, nfact, hfact FROM -100 TO 100 WITH 200
        q10 = 3^((celsius - 6.3)/10)
        tinc = -dt * q10
                :"m" sodium activation system
        alpha =(.1 * vtrap(-(v+40),10))
        beta = (4 * exp(-(v+65)/18))
        sum = alpha + beta
        minf = alpha/sum
        mexp = 1 - exp(tinc*sum*mfact)
                :"h" sodium inactivation system
        alpha = (.07 * exp(-(v+65)/20))
        beta = (1 / (exp(-(v+35)/10) + 1))
        sum = alpha + beta
        hinf = alpha/sum
        hexp = 1 - exp(tinc*sum*hfact)
                :"n" potassium activation system
        alpha = (.01*vtrap(-(v+55),10))
        beta = (.125*exp(-(v+65)/80))
        sum = alpha + beta
        ninf = alpha/sum
        nexp = 1 - exp(tinc*sum*nfact)
}
 
FUNCTION vtrap(x,y) {  :Traps for 0 in denominator of rate eqns.
        if (fabs(x/y) < 1e-6) {
                vtrap = y*(1 - x/y/2)
        }else{
                vtrap = x/(exp(x/y) - 1)
        }
}
 
UNITSON

