
# inicializace

wr_first_line=0;

wr_start = 1;

wr_level=0;

wr_prev = [0,0,0];
for (i=0; i<3; i=i+1) {
    wr_prev[i]=0;
}

wr_colors = [0,0];
setsize(wr_colors,30);
for (i=0; i<30; i=i+1) {
    wr_colors[i]=0;
}


wr_texts = ["a","b"];
setsize(wr_texts,32);

wr_texts[0]="^";
#wr_texts[1]="ttttSTANDARD PROCEDURES2";
wr_texts[1]="";
wr_texts[2]="0017PREAMBLE";
wr_texts[3]="0018BEFORE TAXI";
wr_texts[4]="xxxxBEFORE TAKE OFF";
wr_texts[5]="xxxxTAKE OFF";
wr_texts[6]="xxxxCLIMBING";
wr_texts[7]="xxxxCRUISE";
wr_texts[8]="xxxxDESCENT";
wr_texts[9]="xxxxBEFORE LANDING";
wr_texts[10]="xxxxNORMAL LANDING";
wr_texts[11]="xxxxMAX RVS THRUST LANDING";
wr_texts[12]="xxxxBAULKED LANDING";
wr_texts[13]="xxxxAFTER LANDING";
wr_texts[14]="xxxxSHUT DOWN AND SECURING";
wr_texts[15]="eeeeEND OF LIST2";
wr_texts[16]="~";
wr_texts[17]="ttttEMERGENCY PROCEDURES";
wr_texts[18]="xxxxemerg preamble";
wr_texts[19]="eeeeEND OF EMERG. LIST";
wr_texts[20]="~";
wr_texts[21]="";
wr_texts[22]="";
wr_texts[23]="";
wr_texts[24]="";
wr_texts[25]="";
wr_texts[26]="";
wr_texts[27]="";
wr_texts[28]="";
wr_texts[29]="";
wr_texts[30]="";
wr_texts[31]="";


wr_set_text_lines = func {
    setprop("/instrumentation/wr/text-alt[0]",wr_texts[wr_start]);

    for (i=1; i<15; i=i+1) {
        if (wr_texts[wr_start+i+wr_first_line] == "~") { break; }
        setprop("/instrumentation/wr/text-alt["~i~"]",substr(wr_texts[wr_start+i+wr_first_line],4));
    }
    for (i2=i; i2<15; i2=i2+1) {
        setprop("/instrumentation/wr/text-alt["~i2~"]","");
    }
    
}

wr_set_text_lines();

wr_set_new_mode = func {
    if (getprop("/instrumentation/gu/mode-sw") == 3) {
        wr_first_line=0;
        wr_start = 1;
        wr_level=0;   
    }
    if (getprop("/instrumentation/gu/mode-sw") == 2) {
        wr_first_line=0;
        wr_start = 17;
        wr_level=0;   
    }
    setprop("/instrumentation/wr/text-col[1]",getprop("/instrumentation/gu/mode-sw"));
    wr_set_text_lines();
}
