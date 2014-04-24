#!/usr/bin/perl -w

$filename = "refs.bib";
#$filename = "test.bib";
#$outfilename = "temp.bib";
#`sed -i 's///' $filename`;

#JSSC
#`sed -i 's/Solid-State Circuits, IEEE Journal of/IEEE J. Solid-State Circuits/' $filename`;
`sed -i 's/journal={Solid-State Circuits, IEEE Journal of}/journal={IEEE J. Solid-State Circuits}/' $filename`;

#ISSCC
`sed -i 's/booktitle={Solid-State Circuits Conference Digest of Technical Papers (ISSCC), [0-9][0-9][0-9][0-9] IEEE International}/booktitle={IEEE Int. Solid-State Circuits Conf. (ISSCC) Dig. Tech. Papers}/' $filename`;
`sed -i 's/booktitle={Solid-State Circuits Conference, [0-9][0-9][0-9][0-9]. Digest of Technical Papers. ISSCC. [0-9][0-9][0-9][0-9] IEEE International}/booktitle={IEEE Int. Solid-State Circuits Conf. (ISSCC) Dig. Tech. Papers}/' $filename`;
`sed -i 's/booktitle={Solid-State Circuits Conference, [0-9][0-9][0-9][0-9]. ISSCC [0-9][0-9][0-9][0-9]. Digest of Technical Papers. IEEE International}/booktitle={IEEE Int. Solid-State Circuits Conf. (ISSCC) Dig. Tech. Papers}/' $filename`;

#TCASI Regular Paper
`sed -i 's/journal={Circuits and Systems I: Regular Papers, IEEE Transactions on}/journal={IEEE Trans. Circuits Syst. I, Reg. Papers}/' $filename`;

#TCASII Express Brief
`sed -i 's/journal={Circuits and Systems II: Express Briefs, IEEE Transactions on}/journal={IEEE Trans. Circuits Syst. II, Exp. Briefs}/' $filename`;

#TVLSI
`sed -i 's/journal={Very Large Scale Integration (VLSI) Systems, IEEE Transactions on}/journal={IEEE Trans. Very Large Scale Integr. (VLSI) Syst.}/' $filename`;

#ISQED
`sed -i 's/booktitle={Quality Electronic Design (ISQED), [0-9][0-9][0-9][0-9] [0-9][0-9].. International Symposium on}/booktitle={Int. Symp. Quality Electron. Design (ISQED)}/' $filename`;

#ASQED
`sed -i 's/booktitle={Quality Electronic Design (ASQED), [0-9][0-9][0-9][0-9] [0-9].. Asia Symposium on}/booktitle={Asia Symp. Quality Electron. Design (ASQED)}/' $filename`;

#ESSCIRC
`sed -i 's/booktitle={Solid-State Circuits Conference, [0-9][0-9][0-9][0-9]. ESSCIRC [0-9][0-9][0-9][0-9]. [0-9][0-9].. European}/booktitle={European Solid-State Circuits Conf. (ESSCIRC)}/' $filename`;

#Midwest Symposium
`sed -i 's/booktitle={Circuits and Systems, [0-9][0-9][0-9][0-9]. [0-9][0-9].. Midwest Symposium on}/booktitle={Midwest Symp. Circuits Syst.}/' $filename`;

#VLSI Symposium
`sed -i 's/booktitle={VLSI Circuits (VLSIC), [0-9][0-9][0-9][0-9] Symposium on}/booktitle={Symp. VLSI Circuits (VLSIC)}/' $filename`;

#CICC
`sed -i 's/booktitle={Custom Integrated Circuits Conference, [0-9][0-9][0-9][0-9]. Proceedings of the IEEE [0-9][0-9][0-9][0-9]}/booktitle={Proc. IEEE Custom Integrated Circuits Conf. (CICC)}/' $filename`;

#IEEE Proceedings
`sed -i 's/journal={Proceedings of the IEEE}/journal={Proc. IEEE}/' $filename`;

#To capitalize a set of words in the title

@capitalize_set = ("SRAM", "8T", "CMOS", "VCC", "VLSI");
@units_set = ("kHz", "MHz", "GHz", "mV", "V", "Kb", "Mb"); # These should have a number before them

@file_contents = `cat $filename`;
open(NEW_FILE,">temp.script.file")||die "Error: Unable to write temp.script.file";

foreach(@file_contents){
        chomp;
        $this_line = $_;
   	if(/\btitle={/){ #Check if the line contains the string "title={ -- \b is word delimiter
                @line_fields = split(/\btitle={/, $this_line); #Get the title fields as other fields may be present in the line
                $title = $line_fields[-1]; #Get last field of array
                @line_fields1 = split(/},/, $title); #Remove any other fields in the line - note the comma after '{'
                $title = $line_fields1[0]; #Get the first element
                $old_title = $title; #Store original title to find and replace later
                #capitalize_set
                foreach(@capitalize_set){
                        if(!($title =~ /\{$_\}/)){              # The even one word is already enclosed by curley brackets then do nothing 
                                $title =~ s/\b$_\b/\{$_\}/g;    # as that word is probably already taken care of 
                        }
                }
                #units_set
                foreach(@units_set){
                        if(!($title =~ /[0-9]+\{$_\}/)){         # The even one word is already enclosed by curley brackets then do nothing 
                                $title =~ s/([0-9]+)$_\b/$1\{$_\}/g; # as that word is probably already taken care of 
                        }
                }
                $this_line =~ s/\b\Qtitle={$old_title}\E/title=\{$title\}/;
        }
        print NEW_FILE "$this_line\n";

}#End of foreach
close(NEW_FILE);
`mv temp.script.file $filename`;
