IEEE_bibtex_fix
===============

This script fixes some of the errors in the bibliography downloaded from IEEE
* Updates journal and conference names:
  * For eg. Original journal name: "Solid-State Circuits, IEEE Journal of" is replaced with "IEEE J. Solid-State Circuits"
 * This is done for a limites set of journals and conferences relevant to VLSI
* Preserves case of a list of keywords
 * The list can be easily appended to extend it
* Preserves case of list of units
 * This is only done if the units are preceded by numbers (space between number and unit is allowed)
* Locates words that contain more than one capital letter and preserves the case
 * These words are listed on the terminal - so that you can easily fix some changes that may be incorrectly changed
 * This features also throws-up some interesting anomalies - which can be fixed manually later


How to Use:
-----------
```sh
./bib_mod.pl input_bib_filname  output_bib_filname
```

Note:
----
* Always compare the input and output by performing a diff (or gvimdiff or tkdiff or meld) to check the changes done by the script.
* Nothing beats a human-eye checking though the entire list of references, as the script is far from being comprehensive.
* The script is conservative, it will frequenctly not replace things that look suspicious.

Things I learned while creating this script:
--------------------------------------------
* IEEE bibtex contains special characters that are frequently incorrectly represented - such as \kappa or \mu or \&
* The hyphen and slash symbols cause multiple issues impeding the creation of a robust script



How to add/update this script:
------------------------------
* Please report bugs/issues - by creating an issue using the git-issue manager
* If you would like me to add journal/conference names to the script (and are unable to do it yourself), please report this as an issue with low priority and label as "enhancement".        
