#!/usr/bin/perl -w

if (($#ARGV + 1) != 2) {                        # Quit unless we have the correct number of command-line args
    print "\nUsage: bib_mod.pl input_bib_filname  output_bib_filname\n";
    exit;
}
 
$input_file_name=$ARGV[0];
$output_file_name=$ARGV[1];

system("cp $input_file_name $output_file_name");

#JSSC
#`sed -i 's/Solid-State Circuits, IEEE Journal of/IEEE J. Solid-State Circuits/' $output_file_name`;
`sed -i 's/journal={Solid-State Circuits, IEEE Journal of}/journal={IEEE J. Solid-State Circuits}/' $output_file_name`;

#ISSCC
`sed -i 's/booktitle={Solid-State Circuits Conference Digest of Technical Papers (ISSCC), [0-9][0-9][0-9][0-9] IEEE International}/booktitle={IEEE Int. Solid-State Circuits Conf. (ISSCC) Dig. Tech. Papers}/' $output_file_name`;
`sed -i 's/booktitle={Solid-State Circuits Conference, [0-9][0-9][0-9][0-9]. Digest of Technical Papers. ISSCC. [0-9][0-9][0-9][0-9] IEEE International}/booktitle={IEEE Int. Solid-State Circuits Conf. (ISSCC) Dig. Tech. Papers}/' $output_file_name`;
`sed -i 's/booktitle={Solid-State Circuits Conference, [0-9][0-9][0-9][0-9]. ISSCC [0-9][0-9][0-9][0-9]. Digest of Technical Papers. IEEE International}/booktitle={IEEE Int. Solid-State Circuits Conf. (ISSCC) Dig. Tech. Papers}/' $output_file_name`;

#TCASI Regular Paper
`sed -i 's/journal={Circuits and Systems I: Regular Papers, IEEE Transactions on}/journal={IEEE Trans. Circuits Syst. I, Reg. Papers}/' $output_file_name`;

#TCASII Express Brief
`sed -i 's/journal={Circuits and Systems II: Express Briefs, IEEE Transactions on}/journal={IEEE Trans. Circuits Syst. II, Exp. Briefs}/' $output_file_name`;

#TVLSI
`sed -i 's/journal={Very Large Scale Integration (VLSI) Systems, IEEE Transactions on}/journal={IEEE Trans. Very Large Scale Integr. (VLSI) Syst.}/' $output_file_name`;

#ISQED
`sed -i 's/booktitle={Quality Electronic Design (ISQED), [0-9][0-9][0-9][0-9] [0-9][0-9].. International Symposium on}/booktitle={Int. Symp. Quality Electron. Design (ISQED)}/' $output_file_name`;

#ASQED
`sed -i 's/booktitle={Quality Electronic Design (ASQED), [0-9][0-9][0-9][0-9] [0-9].. Asia Symposium on}/booktitle={Asia Symp. Quality Electron. Design (ASQED)}/' $output_file_name`;

#ESSCIRC
`sed -i 's/booktitle={Solid-State Circuits Conference, [0-9][0-9][0-9][0-9]. ESSCIRC [0-9][0-9][0-9][0-9]. [0-9][0-9].. European}/booktitle={European Solid-State Circuits Conf. (ESSCIRC)}/' $output_file_name`;

#Midwest Symposium
`sed -i 's/booktitle={Circuits and Systems, [0-9][0-9][0-9][0-9]. [0-9][0-9].. Midwest Symposium on}/booktitle={Midwest Symp. Circuits Syst.}/' $output_file_name`;

#VLSI Symposium
`sed -i 's/booktitle={VLSI Circuits (VLSIC), [0-9][0-9][0-9][0-9] Symposium on}/booktitle={Symp. VLSI Circuits (VLSIC)}/' $output_file_name`;

#CICC
`sed -i 's/booktitle={Custom Integrated Circuits Conference, [0-9][0-9][0-9][0-9]. Proceedings of the IEEE [0-9][0-9][0-9][0-9]}/booktitle={Proc. IEEE Custom Integrated Circuits Conf. (CICC)}/' $output_file_name`;

#IEEE Proceedings
`sed -i 's/journal={Proceedings of the IEEE}/journal={Proc. IEEE}/' $output_file_name`;

#To capitalize a set of words in the title

@capitalize_set = ("SRAM", "8T", "CMOS", "VCC", "VLSI", "FPGA", "6T", "Kbit", "9T", "10T", "11T");
@units_set = ("kHz", "MHz", "GHz", "mV", "V", "Kb", "Mb", "mW", "nW", "pW", "nJ", "pJ", "fJ"); # These should have a number before them

@file_contents = `cat $output_file_name`;
open(NEW_FILE,">temp.script.file")||die "Error: Unable to write temp.script.file";

foreach(@file_contents){
        chomp;
        $this_line = $_;
   	if(/\btitle\s*=\s*{/){ #Check if the line contains the string "title={ -- \b is word delimiter
                @line_fields = split(/\btitle\s*=\s*{/, $this_line); #Get the title fields as other fields may be present in the line
                $title = $line_fields[-1]; #Get last field of array
                @line_fields1 = split(/},/, $title); #Remove any other fields in the line - note the comma after '{'
                $title = $line_fields1[0]; #Get the first element
                $old_title = $title; #Store original title to find and replace later
                #capitalize_set
                foreach(@capitalize_set){
                        if(!($title =~ /\{$_\}/)){              # If even one word is already enclosed by curley brackets then do nothing 
                                $title =~ s/\b$_\b/\{$_\}/g;    # as that word is probably already taken care of 
                        }
                }
                #units_set
                foreach(@units_set){
                        if(!($title =~ /[0-9]+\{$_\}/)){         # If even one word is already enclosed by curley brackets then do nothing 
                                $title =~ s/([0-9]+)$_\b/$1\{$_\}/g; # as that word is probably already taken care of 
                        }
                }
                #Check for possible words that may need to be preserved - any word containing more than one capital letters
                my @word_list = split(/ /, $title);
                my @temp_title_words = CheckMulCap(@word_list);
                $title = join(' ' ,@temp_title_words);

                $this_line =~ s/\b\Qtitle={$old_title}\E/title=\{$title\}/;
        }
        print NEW_FILE "$this_line\n";

}#End of foreach
close(NEW_FILE);
`mv temp.script.file $output_file_name`;
print "\n";

# Function definitions:
sub CheckMulCap{
        foreach(@_){
                if((!(/-/)) && (!(/{/)) && (substr($_,0,1) ne "\\")){   # Does not contain hyphen or "{" ( "{" indicates the word is probably already taken care)
                                                                        # and If first character of the word is { or \ - then ignore the word
                        if(/[\p{Uppercase}].*[\p{Uppercase}]/){         # Check for multiple uppercase letters
                                print "\n>> Modified $_";
                                s/\Q$_/\{$_\}/;
                        }
                }elsif($_ eq '-'){ # Just the hyphen character
                        #Do nothing
                }elsif(/-/){
                        my @sub_word_list = split(/-/, $_);
                        my @temp_word = CheckMulCap(@sub_word_list);
                        $_ = join('-', @temp_word);
                }
        }
        return @_;
}

#TODO:
#Take of the case when spaces are present like: title = {

#Features to add
# 1. Frequently wrongly represented terms - such as VMIN to ${V}_{MIN}$
# 2. When there is number space and then the units eg. 1.2 V
# 3. Automatically take the journal names from the IEEE specification and replace correctly!
