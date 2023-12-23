#include <stdio.h>
#include "hocdec.h"
/* change name when structures in neuron.exe change*/
/* and also change the mos2nrn1.sh script */
int nocmodl5_2;

modl_reg(){
	fprintf(stderr, "Additional mechanisms from files\n");

fprintf(stderr," CHAYHH.MOD");
fprintf(stderr," EPlasInp.mod");
fprintf(stderr," EPlasSom.mod");
fprintf(stderr," EPlasSomf.mod");
fprintf(stderr," EPlasSyn.mod");
fprintf(stderr," EPlasSynf.mod");
fprintf(stderr," ExIAF.mod");
fprintf(stderr," FHH.MOD");
fprintf(stderr," HHALT.MOD");
fprintf(stderr," HHCA.MOD");
fprintf(stderr," HHCA1.MOD");
fprintf(stderr," INPUT.MOD");
fprintf(stderr," InhIAF.mod");
fprintf(stderr," PACEF.MOD");
NOT_PARALLEL_SUB(fprintf(stderr, "\n");)
_CHAYHH_reg();
_EPlasInp_reg();
_EPlasSom_reg();
_EPlasSomf_reg();
_EPlasSyn_reg();
_EPlasSynf_reg();
_ExIAF_reg();
_FHH_reg();
_HHALT_reg();
_HHCA_reg();
_HHCA1_reg();
_INPUT_reg();
_InhIAF_reg();
_PACEF_reg();
}
