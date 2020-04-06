#!/afs/isis/pkg/perl/bin/perl
#shop 245302 Purchasing Form
# By Dwayne Ayers
use strict;
use warnings;

# Set Variables
#######################

my $ver = "1.0";

my $cgiurl = "index.pl";  #un-rem line for production
# my $cgiurl = "lspurch.pl"; #rem line for production

my $ymd = sub{sprintf '%02d-%02d-%04d',
    $_[4]+1, $_[3], $_[5]+1900, }->(localtime);
	
my $shop = "245302";
my $wonumber;
my $venfile;
#my $allow_html = 0;
my $buffer;
my @pairs;
my $name;
my $value;
my %FORM;
my $err;
my @vendor;
my $ven;
# my $directory = 'C:/\Abyss Web Server/\htdocs/\vendors';
my $directory = '/vendors';
my $file1;
my $file2;
my $file3;
my @vlist;
my $file;
my ($ven0, $ven1, $ven2, $ven3, $ven4, $ven5, $ven6, $ven7, $req, $wonumber1, $wonumber2, $orderby);
my ($qty0, $qty1, $qty2, $qty3, $qty4, $qty5, $qty6, $qty7, $qty8, $qty9);
my ($uom0, $uom1, $uom2, $uom3, $uom4, $uom5, $uom6, $uom7, $uom8, $uom9);
my ($stockno0, $stockno1, $stockno2, $stockno3, $stockno4, $stockno5, $stockno6, $stockno7, $stockno8, $stockno9);
my ($des0, $des1, $des2, $des3, $des4, $des5, $des6, $des7, $des8, $des9);
my ($ucost0, $ucost1, $ucost2, $ucost3, $ucost4, $ucost5, $ucost6, $ucost7, $ucost8, $ucost9);





# $tcost0, $tcost1, $tcost2, $tcost3, $tcost4, $tcost5, $tcost6, $tcost7, $tcost8, $tcost9)

my ($cvf, $bldg, $recipient);
my ($vlist1, $vlist2, $vlist3, $vlist4, $vlist5, $vlist6, $vlist7);
my @newlist;

# Get the input from forms
###########################
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});


#if no form data go to system start
   if (!$buffer) { 
         &begin;
   }

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach my $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

# Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;
   $value =~ s/<([^>]|\n)*>//g;
   
   $FORM{$name} = $value;
}


#Choose form to process
########################

#Vendor choose form
if ($FORM{'hide'} == 0) {

	if (!$FORM{'vendor'}) { # if required information left out
	$err = "NEED VENDOR";
	&error;
	}
$ven = $FORM{'vendor'};


&output; #building purchasing form
}	

#Main purchasing form
if ($FORM{'hide'} == 1) {

		if (!$FORM{'wo1'}) { # if required information left out
		$err = "DID YOU FORGET WORK ORDER NUMBER?";
		&error;
		}
		
		if (!$FORM{'wo2'}) { # if required information left out
		$err = "DID YOU FORGET THE WO PHASE?";
		&error;
		}
		
		if (!$FORM{'bldg'}) { # if required information left out
		$err = "DID YOU FORGET BUILDING?";
		&error;
		}
		
		if (!$FORM{'orderby'}) { # if required information left out
		$err = "DID YOU FORGET ORDERED BY?";
		&error;
		}
		
		if (!$FORM{'recipient'}) { # if required information left out
		$err = "DID YOU FORGET RECIPIENT?";
		&error;
		}
		
		if (!$FORM{'orderby'}) { # if required information left out
		$err = "DID YOU FORGET ORDERED BY?";
		&error;
		}
		
		if (!$FORM{'qty0'}) { # if required information left out
		$err = "DID YOU FORGET QTY?";
		&error;
		}
		
		if (!$FORM{'uom0'}) { # if required information left out
		$err = "DID YOU FORGET UOM?";
		&error;
		}
		
		if (!$FORM{'stockno0'}) { # if required information left out
		$err = "DID YOU FORGET STOCK NUMBER?";
		&error;
		}
		
		if (!$FORM{'des0'}) { # if required information left out
		$err = "DID YOU FORGET DESCRIPTION?";
		&error;
		}
		
		if (!$FORM{'ucost0'}) { # if required information left out
		$err = "DID YOU FORGET UNIT COST?";
		&error;
		}
		
		
$ven0 = $FORM{'vlist0'};
$ven1 = $FORM{'vlist1'};
$ven2 = $FORM{'vlist2'};
$ven3 = $FORM{'vlist3'};
$ven4 = $FORM{'vlist4'};
$ven5 = $FORM{'vlist5'};
$ven6 = $FORM{'vlist6'};
$ven7 = $FORM{'vlist7'};

$req = $FORM{'requested'};
$wonumber1 = $FORM{'wo1'};
$wonumber2 = $FORM{'wo2'};

$qty0 = $FORM{'qty0'};
$qty1 = $FORM{'qty1'};
$qty2 = $FORM{'qty2'};
$qty3 = $FORM{'qty3'};
$qty4 = $FORM{'qty4'};
$qty5 = $FORM{'qty5'};
$qty6 = $FORM{'qty6'};
$qty7 = $FORM{'qty7'};
$qty8 = $FORM{'qty8'};
$qty9 = $FORM{'qty9'};

$uom0 = $FORM{'uom0'};
$uom1 = $FORM{'uom1'};
$uom2 = $FORM{'uom2'};
$uom3 = $FORM{'uom3'};
$uom4 = $FORM{'uom4'};
$uom5 = $FORM{'uom5'};
$uom6 = $FORM{'uom6'};
$uom7 = $FORM{'uom7'};
$uom8 = $FORM{'uom8'};
$uom9 = $FORM{'uom9'};

$stockno0 = $FORM{'stockno0'};
$stockno1 = $FORM{'stockno1'};
$stockno2 = $FORM{'stockno2'};
$stockno3 = $FORM{'stockno3'};
$stockno4 = $FORM{'stockno4'};
$stockno5 = $FORM{'stockno5'};
$stockno6 = $FORM{'stockno6'};
$stockno7 = $FORM{'stockno7'};
$stockno8 = $FORM{'stockno8'};
$stockno9 = $FORM{'stockno9'};

$des0 = $FORM{'des0'};
$des1 = $FORM{'des1'};
$des2 = $FORM{'des2'};
$des3 = $FORM{'des3'};
$des4 = $FORM{'des4'};
$des5 = $FORM{'des5'};
$des6 = $FORM{'des6'};
$des7 = $FORM{'des7'};
$des8 = $FORM{'des8'};
$des9 = $FORM{'des9'};

$ucost0 = $FORM{'ucost0'};
$ucost1 = $FORM{'ucost1'};
$ucost2 = $FORM{'ucost2'};
$ucost3 = $FORM{'ucost3'};
$ucost4 = $FORM{'ucost4'};
$ucost5 = $FORM{'ucost5'};
$ucost6 = $FORM{'ucost6'};
$ucost7 = $FORM{'ucost7'};
$ucost8 = $FORM{'ucost8'};
$ucost9 = $FORM{'ucost9'};

$recipient = $FORM{'recipient'};
$bldg = $FORM{'bldg'};
$orderby = $FORM{'orderby'};

&outputf; #building final purchasing document

}

# Vendor Choose Form - Start
sub begin {
print "Content-type: text/html\n\n";
print "<html><head><title>SHOP 245302 PURCHASING $ver</font></title></head>\n";

print "<body><FONT SIZE = 5><b>SHOP 245302 PURCHASING</b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</b><br><br>\n";
print "</font><br>\n";
print "<form method=POST action= $cgiurl>\n";
print "<input type=hidden id=hide name=hide value=0>";
print "Choose the <b>VENDOR</b>\:\&nbsp\;\&nbsp\;\n";
print  "<select name=vendor>\n";
print  "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        print  "<option value=$file1>$file3</option>\n";
		}
		
    }

print  "</select>\n";

print  "<br><br>";


print "<input type=submit> * <input type=reset><br><br>\n";

#print $file1;

print "</form></body></html>\n";

exit;

}


#Main Purchasing Form - data from vendor choose form
sub output {

$ven =~ tr/_\t/ /s;;

open ($cvf, "<$directory/$ven.txt")  || die "Cannot open vendor file: $!\n";

		@vlist = <$cvf>;
		foreach(@vlist) {
		$_ =~ s/^.*?://;
		$_ =~ tr/ \t/_/s;
		$_ =~ s/^_//;
		push (@newlist, $_);
		}			
close $cvf;		


print "Content-type: text/html\n\n";
print "<html><head><title>SHOP 245302 PURCHASING FORM</title></head>\n";
print "<body><FONT SIZE = 5><b><center>SHOP 245302 PURCHASING FORM </b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</center></b></font><br><br>\n";
print "<form method=POST action= $cgiurl>\n";
print "<input type=hidden id=hide name=hide value=1>";

#Get vendor data from file

print "<input type=hidden id=vlist0 name=vlist0 value=".$newlist[0]. ">";
print "<input type=hidden id=vlist1 name=vlist1 value=".$newlist[1]. ">";
print "<input type=hidden id=vlist2 name=vlist2 value=".$newlist[2]. ">";
print "<input type=hidden id=vlist3 name=vlist3 value=".$newlist[3]. ">";
print "<input type=hidden id=vlist4 name=vlist4 value=".$newlist[4]. ">";
print "<input type=hidden id=vlist5 name=vlist5 value=".$newlist[5]. ">";
print "<input type=hidden id=vlist6 name=vlist6 value=".$newlist[6]. ">";
print "<input type=hidden id=vlist7 name=vlist7 value=".$newlist[7]. ">";


foreach (@newlist) {
	$_ =~ tr/_\t/ /s;
	}

print "<font size=6 color=blue><i><b>$newlist[0]</i></b></font>\n\n";
print "<br><br><font size=4 color=blue>";
print "<label for=wo>Work Order:</label>\n";
print "<input type=text id=wo1 name=wo1 size=5 pattern=\[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]>\n";
print "-\n";
print "<input type=text id=wo2 name=wo2 size=1 pattern=\[0-9][0-9][0-9]>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;<label for=bldg>For Building:</label>\n";
print "<input type=text id=bldg name=bldg SIZE=20>\n";
print "<br><br>";

print "<label for=orderby>Ordered By:</label>\n";
print "<select id=orderby name=orderby>\n";
print  "<option></option>\n";
print  "<option value='Ayers, Dwayne'>Ayers, Dwayne</option>\n";
print  "<option value='Brown, Wes'>Brown, Wes</option>\n";
print  "<option value='Hill, James'>Hill, James</option>\n";
print  "<option value='Miskow, Michael'>Miskow, Michael</option>\n";
print  "<option value='Strickler, William'>Strickler, William</option>\n";
print  "<option value='Thacker, Daniel'>Thacker, Daniel</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";

print "<label for=recipient>Recipient:</label>\n";
print "<select id=recipient name=recipient>\n";
print  "<option></option>\n";
print  "<option value='Generator Shop'>Generator Shop</option>\n";
print  "<option value='Ayers, Dwayne'>Ayers, Dwayne</option>\n";
print  "<option value='Chick, John'>Chick, John</option>\n";
print  "<option value='Coombs, Steven'>Coombs, Steven</option>\n";
print  "<option value='Covington, Travis'>Covington, Travis</option>\n";
print  "<option value='Heidinger, Jason'>Heidinger, Jason</option>\n";
print  "<option value='Hill, James'>Hill, James</option>\n";
print  "<option value='Lipscomb, Steven M'>Lipscomb, Steven M</option>\n";
print  "<option value='Lloyd, Jeremy'>Lloyd, Jeremy</option>\n";
print  "<option value='Miskow, Michael'>Miskow, Michael</option>\n";
print  "<option value='Quigley, Eric'>Quigley, Eric</option>\n";
print  "<option value='Sharpe, David'>Sharpe, David</option>\n";
print  "<option value='Straughn, Kerry'>Straughn, Kerry</option>\n";
print  "<option value='Strickler, William'>Strickler, William</option>\n";
print  "<option value='Thacker, Daniel'>Thacker, Daniel</option>\n";
print  "</select>\n";

print "<br><br>";
my $days = "2-5_days";
print "Needed: ";
print "<select id=requested name=requested>
  <option value=ASAP>ASAP</option>
  <option value=$days>2\-5 days</option>
  </select>\n";
  
print "</font><font size=4 color=red>\&nbsp\;\&nbsp\;\&nbsp\;(Emergency orders should be called into purchasing agent)";
print "</font><br><br><font size=4 color=blue>";
print "<b>ITEM\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;QTY\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;UOM\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;STOCK#\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;DESCRIPTION\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;UNIT COST\n";
print "<br><br>";
print "1\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty0 name=qty0 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom0 name=uom0>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno0 name=stockno0 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des0 name=des0 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost0 name=ucost0 size=4>\n";
print "<br><br>";

print "2\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty1 name=qty1 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom1 name=uom1>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno1 name=stockno1 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des1 name=des1 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost1 name=ucost1 size=4>\n";

print "<br><br>";
print "3\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty2 name=qty2 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom2 name=uom2>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno2 name=stockno2 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des2 name=des2 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost2 name=ucost2 size=4>\n";

print "<br><br>";
print "4\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty3 name=qty3 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom3 name=uom3>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno3 name=stockno3 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des3 name=des3 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost3 name=ucost3 size=4>\n";

print "<br><br>";
print "5\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty4 name=qty4 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom4 name=uom4>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno4 name=stockno4 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des4 name=des4 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost4 name=ucost4 size=4>\n";

print "<br><br>";
print "6\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty5 name=qty5 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom5 name=uom5>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno5 name=stockno5 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des5 name=des5 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost5 name=ucost5 size=4>\n";

print "<br><br>";
print "7\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty6 name=qty6 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom6 name=uom6>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno6 name=stockno6 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des6 name=des6 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost6 name=ucost6 size=4>\n";

print "<br><br>";
print "8\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty7 name=qty7 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom7 name=uom7>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno7 name=stockno7 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des7 name=des7 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost7 name=ucost7 size=4>\n";

print "<br><br>";
print "9\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty8 name=qty8 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom8 name=uom8>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno8 name=stockno8 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des8 name=des8 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost8 name=ucost8 size=4>\n";

print "<br><br>";
print "10\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=qty9 name=qty9 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<select id=uom9 name=uom9>\n";
print  "<option value='EA'>EA</option>\n";
print  "<option value='LOT'>LOT</option>\n";
print  "<option value='KIT'>KIT</option>\n";
print  "<option value='LABOR'>LABOR</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=stockno9 name=stockno9 size=10>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
print "<input type=text id=des9 name=des9 size=15>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\$";
print "<input type=text id=ucost9 name=ucost9 size=4>\n";
print "</font><br><br></b>";
print "<input type=submit> * <input type=reset><br><br><br><br>\n";
print "</form></body></html>\n";
exit;
}


sub outputf { #building final document from purchasing form

my $tcost0 = ($qty0 * $ucost0);
$tcost0 = sprintf("%.2f", $tcost0);
$ucost0 = sprintf("%.2f", $ucost0);

my $tcost1 = ($qty1 * $ucost1);
$tcost1 = sprintf("%.2f", $tcost1);
$ucost1 = sprintf("%.2f", $ucost1);

my $tcost2 = ($qty2 * $ucost2);
$tcost2 = sprintf("%.2f", $tcost2);
$ucost2 = sprintf("%.2f", $ucost2);

my $tcost3 = ($qty3 * $ucost3);
$tcost3 = sprintf("%.2f", $tcost3);
$ucost3 = sprintf("%.2f", $ucost3);

my $tcost4 = ($qty4 * $ucost4);
$tcost4 = sprintf("%.2f", $tcost4);
$ucost4 = sprintf("%.2f", $ucost4);

my $tcost5 = ($qty5 * $ucost5);
$tcost5 = sprintf("%.2f", $tcost5);
$ucost5 = sprintf("%.2f", $ucost5);

my $tcost6 = ($qty6 * $ucost6);
$tcost6 = sprintf("%.2f", $tcost6);
$ucost6 = sprintf("%.2f", $ucost6);

my $tcost7 = ($qty7 * $ucost7);
$tcost7 = sprintf("%.2f", $tcost7);
$ucost7 = sprintf("%.2f", $ucost7);

my $tcost8 = ($qty8 * $ucost8);
$tcost8 = sprintf("%.2f", $tcost8);
$ucost8 = sprintf("%.2f", $ucost8);

my $tcost9 = ($qty9 * $ucost9);
$tcost9 = sprintf("%.2f", $tcost9);
$ucost9 = sprintf("%.2f", $ucost9);

my $sum = $tcost0 + $tcost1 + $tcost2 + $tcost3 + $tcost4 + $tcost5 + $tcost6 + $tcost7 + $tcost8 + $tcost9;
$sum = sprintf("%.2f", $sum);

print "Content-type: text/html\n\n";
print "<html><head><title>LS PURCHASING DOCUMENT</title>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 8px;
}
</style></head>\n";

print "<body><font size=5><i><b><center>PURCHASE REQUISITION</center></i></b></font>";
print  "<br>";
$ven0 =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Vendor: </FONT><b><br><FONT SIZE=3>$ven0</b></FONT>\n"; #vendor name
print  "<br>";

$ven1 =~ tr/_\t/ /s;
print "<FONT SIZE = 2><b>$ven1</b></FONT>\n"; #vendor address
print  "<br><br>";

$ven2 =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Phone: </FONT><FONT SIZE=3><b>$ven2\&nbsp\;\&nbsp\;</b></FONT>\n"; #vendor main phone
$ven3 =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Fax: </FONT><FONT SIZE=3><b>$ven3</b></FONT>\n"; #vendor fax
print  "<br><br>";

$ven5 =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Rep: </FONT><FONT SIZE=3><b>$ven5</b></FONT>\&nbsp\;\&nbsp\;\n"; #vendor rep
$ven6 =~ tr/_\t/ /s;
print " <FONT SIZE=3 color=blue>Rep Phone: </FONT><FONT SIZE=3><b>$ven6</b></FONT>\&nbsp\;\&nbsp\;\n"; #rep phone
$ven7 =~ tr/_\t/ /s;
print " <FONT SIZE=3 color=blue>Rep Email: </FONT><FONT SIZE=3><b>$ven7</b></FONT>\n"; #rep email
print "<br><br>";

$ven4 =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Cust No: </FONT><FONT SIZE=3><b>$ven4</b></FONT>\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\n"; #our cust number
print " <FONT SIZE=3 color=blue>Work Order: </FONT><FONT SIZE=3><b>$wonumber1</b></FONT>\n"; #work order
print "-\n";
print " <FONT SIZE = 3><b>$wonumber2</b></FONT>\n"; #work order phase
my $shop = 245302;
print "<FONT SIZE=3 color=blue>\&nbsp\;\&nbsp\;Shop: </FONT><b><FONT SIZE=3>$shop</b></FONT>\n"; #shop number
print  "<br><br>";

$orderby =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Ordered by: </FONT><FONT SIZE=3><b>$orderby\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</b></FONT>\n"; #ordered by

$recipient =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Recipient: </FONT><FONT SIZE=3><b>$recipient\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</b></FONT>\n"; #recipient

$req =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Requested: </FONT><FONT SIZE=3><b>$req</b></FONT>\n"; #requested del time
print  "<br><br>";
print "<FONT SIZE=3 color=blue>Ship To: </FONT><FONT SIZE=3><b>Dwayne Ayers - UNC-CH, 136L Giles Horney Bldg., 103 Airport Dr Chapel Hill, NC 27599</b></FONT>";
print  "<br><br>";
print "<FONT SIZE=3 color=blue>Reference: </FONT><FONT SIZE=3><b>$wonumber1-$wonumber2 - $ven0 - $recipient</b></FONT>\n";
print  "<br><br>";
print "<table style=width:100\%>";
print "<tr><th><font color=blue>ITEM</font></th><th><font color=blue>QTY</font></th><th><font color=blue>UOM</font></th><th><font color=blue>STOCK#</font></th><th><font color=blue>DESCRIPTION</font></th><th><font color=blue>UNIT COST</font></th><th><font color=blue>TOTAL COST</font></th></tr>";
print "<tr><td>1</td><td>$qty0</td><td>$uom0</td><td>$stockno0</td><td>$des0</td><td>\$$ucost0</td><td>\$$tcost0</td></tr>";
print "<tr><td>2</td><td>$qty1</td><td>$uom1</td><td>$stockno1</td><td>$des1</td><td>\$$ucost1</td><td>\$$tcost1</td></tr>";
print "<tr><td>3</td><td>$qty2</td><td>$uom2</td><td>$stockno2</td><td>$des2</td><td>\$$ucost2</td><td>\$$tcost2</td></tr>";
print "<tr><td>4</td><td>$qty3</td><td>$uom3</td><td>$stockno3</td><td>$des3</td><td>\$$ucost3</td><td>\$$tcost3</td></tr>";
print "<tr><td>5</td><td>$qty4</td><td>$uom4</td><td>$stockno4</td><td>$des4</td><td>\$$ucost4</td><td>\$$tcost4</td></tr>";
print "<tr><td>6</td><td>$qty5</td><td>$uom5</td><td>$stockno5</td><td>$des5</td><td>\$$ucost5</td><td>\$$tcost5</td></tr>";
print "<tr><td>7</td><td>$qty6</td><td>$uom6</td><td>$stockno6</td><td>$des6</td><td>\$$ucost6</td><td>\$$tcost6</td></tr>";
print "<tr><td>8</td><td>$qty7</td><td>$uom7</td><td>$stockno7</td><td>$des7</td><td>\$$ucost7</td><td>\$$tcost7</td></tr>";
print "<tr><td>9</td><td>$qty8</td><td>$uom8</td><td>$stockno8</td><td>$des8</td><td>\$$ucost8</td><td>\$$tcost8</td></tr>";
print "<tr><td>10</td><td>$qty9</td><td>$uom9</td><td>$stockno9</td><td>$des9</td><td>\$$ucost9</td><td>\$$tcost9</td></tr>";
print "<tr><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td align=left><FONT SIZE=4 color=blue>Total Order \= </FONT><b>\$$sum</b></td></tr>";
print "</table>";
print  "<br>";

print "<button onclick=\"goBack()\">Go Back</button>

<script>
function goBack() {
  window.history.back();
}
</script>";

print "<br>";

print "<form action=$cgiurl>
    <input type=\"submit\" value=\"Create New\" >
    <input type=button name=print value=\"Print as PDF\" onClick=\"window\.print()\"> Choose Destination as <b>\"Save as PDF\"</b>
</form>";
print "<font color=red>Copy \"Reference\" above and paste as file name.</font>";

print  "<br><br><br>";

print "</body></html>\n";
exit;

}

sub error {               #Process error messages
print "Content-type: text/html\n\n";
print "<html><head><title>LS PURCHASING ERROR PAGE</title><script>\n";
print "function goBack() { window.history.back()}\n";
print "</script>\n";
print "</head><body>\n";
print "<FONT SIZE = 4 color = black>Error - <b>$err</b></FONT>\n";
print  "<br><br>";
print "<button onclick=goBack()>Go Back</button>\n";
print  "<br><br>";
print "</body></html>\n";
exit;

}









