#!/afs/isis/pkg/perl/bin/perl
#shop 245302 Purchase Request Form
# By Dwayne Ayers
use strict;
use warnings;
#use CGI;

# Set Variables
#######################

my $ver = "1.7";

#for testing
#my $cgiurl = "lspurchX.pl"; #Rem line for production
#my $directory = "\vendors"; #Rem for production
#my $qdir = "\quotes"; #Rem for production


#for production
my $qdir = "/opt/app-root/src/quotes"; # Un-rem For production
my $directory = "/opt/app-root/src/vendors"; # Un-rem For production
my $cgiurl = "index.pl";  #Un-rem line for production


my $vensend = "venmail.pl";
my $ymd = sub{sprintf '%02d-%02d-%04d',
    $_[4]+1, $_[3], $_[5]+1900, }->(localtime);
my ($sec,$min,$hour) = localtime(time);
my $shop = "245302";
my $title = "SHOP $shop - PURCHASING / REPAIR / CUSTOMER QUOTE";
my $wonumber;
my $venfile;
my $buffer;
my @pairs;
my $name;
my $value;
my %FORM;
my $err;
my @vendor;
my $ven;
my $file1;
my $file2;
my $file3;
my @vlist;
my $file;
my $quote;
my $vquote;
my ($ven0, $ven1, $ven2, $ven3, $ven4, $ven5, $ven6, $ven7, $req, $wonumber1, $wonumber2, $orderby, $prtype);
my ($qty0, $qty1, $qty2, $qty3, $qty4, $qty5, $qty6, $qty7, $qty8, $qty9);
my ($uom0, $uom1, $uom2, $uom3, $uom4, $uom5, $uom6, $uom7, $uom8, $uom9);
my ($stockno0, $stockno1, $stockno2, $stockno3, $stockno4, $stockno5, $stockno6, $stockno7, $stockno8, $stockno9);
my ($des0, $des1, $des2, $des3, $des4, $des5, $des6, $des7, $des8, $des9);
my ($ucost0, $ucost1, $ucost2, $ucost3, $ucost4, $ucost5, $ucost6, $ucost7, $ucost8, $ucost9);
my ($vendor0, $vendor1, $vendor2, $vendor3, $vendor4, $vendor5, $vendor6, $vendor7, $vendor8, $vendor9,); 

# $tcost0, $tcost1, $tcost2, $tcost3, $tcost4, $tcost5, $tcost6, $tcost7, $tcost8, $tcost9)

my ($cvf, $bldg, $recipient);
my ($vlist1, $vlist2, $vlist3, $vlist4, $vlist5, $vlist6, $vlist7);
my @newlist;
my $qprtype;
my $findq;
my @newqlist;
my (@item1, @item2, @item3, @item4, @item5, @item6, @item7, @item8, @item9, @item10);
my ($item1, $item2, $item3, $item4, $item5, $item6, $item7, $item8, $item9, $item10);
my @firstreq;
my @secondreq;
my @thirdreq;
my @forthreq;
my @fifthreq;
my @sixthreq;
my @seventhreq;
my @eigthreq;
my @ninthreq;
my @tenthreq;
my $reqform;
my $venreq;
my $count1;

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

if ($FORM{'hide'} == 3) {
	$findq = $FORM{'findq'};
	&createreq;
}

#if ($FORM{'hide'} == 4) {
	#$findq = $FORM{'findq'};
	#&createreq;
#}


#Vendor choose form
if ($FORM{'hide'} == 0) {

	if (!$FORM{'vendor'}) { # if required information left out
	$err = "NEED VENDOR";
	&error;
	}
$ven = $FORM{'vendor'};

	
&output; #creating purchasing form
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
}	
	

if ($FORM{'hide'} == 1 or 2) {


	
$ven0 = $FORM{'vlist0'};
$ven1 = $FORM{'vlist1'};
$ven2 = $FORM{'vlist2'};
$ven3 = $FORM{'vlist3'};
$ven4 = $FORM{'vlist4'};
$ven5 = $FORM{'vlist5'};
$ven6 = $FORM{'vlist6'};
$ven7 = $FORM{'vlist7'};

$prtype = $FORM{'prtype'};
$quote = $FORM{'quote'};
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

$vendor0 = $FORM{'vendor0'};
$vendor1 = $FORM{'vendor1'};
$vendor2 = $FORM{'vendor2'};
$vendor3 = $FORM{'vendor3'};
$vendor4 = $FORM{'vendor4'};
$vendor5 = $FORM{'vendor5'};
$vendor6 = $FORM{'vendor6'};
$vendor7 = $FORM{'vendor7'};
$vendor8 = $FORM{'vendor8'};
$vendor9 = $FORM{'vendor9'};

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
$ucost0 =~ s/,//g;
$ucost1 = $FORM{'ucost1'};
$ucost1 =~ s/,//g;
$ucost2 = $FORM{'ucost2'};
$ucost2 =~ s/,//g;
$ucost3 = $FORM{'ucost3'};
$ucost3 =~ s/,//g;
$ucost4 = $FORM{'ucost4'};
$ucost4 =~ s/,//g;
$ucost5 = $FORM{'ucost5'};
$ucost5 =~ s/,//g;
$ucost6 = $FORM{'ucost6'};
$ucost6 =~ s/,//g;
$ucost7 = $FORM{'ucost7'};
$ucost7 =~ s/,//g;
$ucost8 = $FORM{'ucost8'};
$ucost8 =~ s/,//g;
$ucost9 = $FORM{'ucost9'};
$ucost9 =~ s/,//g;

$recipient = $FORM{'recipient'};
$bldg = uc($FORM{'bldg'});
$orderby = $FORM{'orderby'};

}

if ($FORM{'hide'} == 1) {

&outputf; #building final purchasing document

}

if ($FORM{'hide'} == 2) {

$qprtype = $FORM{'qprtype'};
&outputqf; #building final quote document

}

# Vendor Choose Form - Start
sub begin {
print "Content-type: text/html\n\n";
print "<html><head><title>$title</title></head>\n";
print "<body><FONT SIZE = 5 color=blue><b>$title</b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</b><br><br>\n";
print "</font><br>\n";
print "<form method=POST action= $cgiurl>\n";
print "<input type=hidden id=hide name=hide value=0>";
print "Choose the <b>VENDOR</b> or <b>\"QUOTE FOR CUSTOMER\"</b>\:\&nbsp\;\&nbsp\;\n";
print  "<br><br><select name=vendor>\n";
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
print "<input type=submit> * <input type=reset><br><br></form>\n";

#If vendor not in first list form

print "<font size=5 color=blue>If Vendor Not In List</font><br><br>\n";
print "<form method=POST action=$vensend>\n";
print "Enter new vendor name:<br><br>\n";
print "<input type=text id=newven name=newven size=40>";
print "<br><br>";
print "Enter your name:<br><br>\n";
print "<input type=text id=reqstr name=reqstr size=40><br><br>";
print "<input type=submit> * <input type=reset><br><br></form>\n";
print "<br>";

#Search for previous quote form

print "<font size=5 color=blue>Turn Previous Customer Quote Into Requisition(s)</font><br><br>\n";
print "<form method=POST action=$cgiurl>\n";
print "Choose quote file:<br><br>\n";
print "<input type=hidden id=hide name=hide value=3>";

#open and pick quote name from quote directory list

print  "<select name=findq>\n";
print  "<option></option>\n";



opendir (DIR, $qdir) or die $!;
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




#print "<input type=text id=findq name=findq size=20>";
print "<br><br>";
print "<input type=submit> * <input type=reset><br><br></form>\n";
print "</body></html>\n";
exit;

}

#Main Purchasing Form - data from vendor choose form
sub output {

$ven =~ tr/_\t/ /s;

open ($cvf, "<$directory/$ven.txt")  || die "Cannot open vendor file: $!\n";

		@vlist = <$cvf>;
		foreach(@vlist) {
		$_ =~ s/^.*?://;
		$_ =~ tr/ \t/_/s;
		$_ =~ s/^_//;
		push (@newlist, $_);
		}			
close $cvf;		

$title = "SHOP $shop - PURCHASING / REPAIR <br>REQUISITION";

if ($newlist[0] =~ m/QUOTE/) {
	$title = "SHOP $shop - QUOTE FOR CUSTOMER";
		
	}

print "Content-type: text/html\n\n";
print "<html><head><title>$title</title></head>\n";
print "<body><FONT SIZE = 5><b><center>$title</b></FONT><FONT SIZE = 2 color = red>\&nbsp\;\&nbsp\;<b>$ver</center></b></font><br><br>\n";
print "<form method=POST action= $cgiurl>\n";
#print "<input type=hidden id=hide name=hide value=1>";

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
	
	
	if ($newlist[0] =~ m/QUOTE/) {
	$vquote = $newlist[0];
	
	&cquote;
	}
	
	
	
	
	
print "<input type=hidden id=hide name=hide value=1>";	
print "<font size=6 color=blue><i><b>$newlist[0]</i></b></font>\n\n";
print "<br><br><font size=4 color=blue>";
print "Request Type: ";
print "<select id=prtype name=prtype>
  <option value='Material Only'>Material Only</option>
  <option value='Labor Only'>Labor Only</option>
  <option value='Material and Labor'>Material and Labor</option>
  </select>\n";

print "\&nbsp\;\&nbsp\;\&nbsp\;";
print "Vendor Quote Number: "; 
print "<input type=text id=quote name=quote size=20>\n";
  
print "<br><br>";
print "<label for=wo>Work Order:</label>\n";
print "<input type=text id=wo1 name=wo1 size=5>\n";
print "-\n";
print "<input type=text id=wo2 name=wo2 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;<label for=bldg>For Building:</label>\n";
print "<input type=text id=bldg name=bldg SIZE=20>\n";
print "<br><br>";

print "<label for=orderby>Ordered By:</label>\n";
print "<select id=orderby name=orderby>\n";
print  "<option></option>\n";
print  "<option value='Ayers, Dwayne'>Ayers, Dwayne</option>\n";
print  "<option value='Brown, Wes'>Brown, Wes</option>\n";
print  "<option value='Hill, James'>Hill, James</option>\n";
#print  "<option value='Miskow, Michael'>Miskow, Michael</option>\n";
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
#print  "<option value='Miskow, Michael'>Miskow, Michael</option>\n";
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
print  "</select>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;";
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
print "<input type=submit> * <input type=reset><br>\n";
print "</form>";
print "<form action=$cgiurl>
    <input type=\"submit\" value=\"Go Home\" >
    </form>";
print "<br><br><br>";
print "</body></html>\n";
exit;
}

#Quote for customer form
sub cquote {
print "<input type=hidden id=hide name=hide value=2>";
#print "<font size=6 color=blue><i><b>$newlist[0]</i></b></font>\n\n";
print "<br><br><font size=4 color=blue>";
print "Quote Type: ";
print "<select id=qprtype name=qprtype>
  <option value='Material Only'>Material Only</option>
  <option value='Labor Only'>Labor Only</option>
  <option value='Material and Labor'>Material and Labor</option>
  </select>\n";

print "\&nbsp\;\&nbsp\;\&nbsp\;";
print "Customer: "; 
print "<input type=text id=quote name=quote size=20>\n";
  
print "<br><br>";
print "<label for=qwo>Work Order (if available):</label>\n";
print "<input type=text id=wo1 name=wo1 size=5>\n";
print "-\n";
print "<input type=text id=wo2 name=wo2 size=1>\n";
print "\&nbsp\;\&nbsp\;\&nbsp\;<label for=bldg>Project Type:</label>\n";
print "<input type=text id=bldg name=bldg SIZE=20>\n";
print "<br><br>";

print "<label for=qorderby>Quote Created By:</label>\n";
print "<select id=orderby name=orderby>\n";
print  "<option></option>\n";
print  "<option value='Ayers, Dwayne'>Ayers, Dwayne</option>\n";
print  "<option value='Brown, Wes'>Brown, Wes</option>\n";
print  "<option value='Hill, James'>Hill, James</option>\n";
#print  "<option value='Miskow, Michael'>Miskow, Michael</option>\n";
print  "<option value='Thacker, Daniel'>Thacker, Daniel</option>\n";
print  "</select>\&nbsp\;\&nbsp\;\&nbsp\;\n";
print "<br><br>";
print "</font>";

print "<font color=red size=4><b><i>* If vendor not in list click \"Go Home\" at bottom and use \"If Vendor Not In List\" </font></b></i>\n";
print "<br><br>";

#line headers
print "<table style=width:85\%>";

print "<tr><th style=text-align:left><font color=blue>ITEM</font></th><th style=text-align:left><font color=blue>QTY</font></th><th style=text-align:left><font color=blue>UOM</font></th><th style=text-align:left><font color=blue>VENDOR</font></th><th style=text-align:left><font color=blue>STOCK#</font></th><th style=text-align:left><font color=blue>DESCRIPTION</font></th><th style=text-align:left><font color=blue>UNIT COST</font></th></tr>";

#line 1
print "<tr><td style=text-align:center>";
print "1";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty0 name=qty0 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom0 name=uom0>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor0>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
			unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno0 name=stockno0 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des0 name=des0 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost0 name=ucost0 size=4>\n";
print "</td>";
print "</tr>";

#line 2
print "<tr><td style=text-align:center>";
print "2";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty1 name=qty1 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom1 name=uom1>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor1>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno1 name=stockno1 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des1 name=des1 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost1 name=ucost1 size=4>\n";
print "</td>";
print "</tr>";

#line 3
print "<tr><td style=text-align:center>";
print "3";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty2 name=qty2 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom2 name=uom2>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor2>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno2 name=stockno2 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des2 name=des2 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost2 name=ucost2 size=4>\n";
print "</td>";
print "</tr>";

#line 4
print "<tr><td style=text-align:center>";
print "4";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty3 name=qty3 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom3 name=uom3>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor3>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno3 name=stockno3 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des3 name=des3 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost3 name=ucost3 size=4>\n";
print "</td>";
print "</tr>";

#line 5
print "<tr><td style=text-align:center>";
print "5";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty4 name=qty4 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom4 name=uom4>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor4>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno4 name=stockno4 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des4 name=des4 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost4 name=ucost4 size=4>\n";
print "</td>";
print "</tr>";


#line 6
print "<tr><td style=text-align:center>";
print "6";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty5 name=qty5 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom5 name=uom5>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor5>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno5 name=stockno5 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des5 name=des5 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost5 name=ucost5 size=4>\n";
print "</td>";
print "</tr>";


#line 7
print "<tr><td style=text-align:center>";
print "7";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty6 name=qty6 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom6 name=uom6>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor6>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno6 name=stockno6 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des6 name=des6 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost6 name=ucost6 size=4>\n";
print "</td>";
print "</tr>";


#line 8
print "<tr><td style=text-align:center>";
print "8";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty7 name=qty7 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom7 name=uom7>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor7>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno7 name=stockno7 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des7 name=des7 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost7 name=ucost7 size=4>\n";
print "</td>";
print "</tr>";

#line 9
print "<tr><td style=text-align:center>";
print "9";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty8 name=qty8 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom8 name=uom8>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor8>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno8 name=stockno8 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des8 name=des8 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost8 name=ucost8 size=4>\n";
print "</td>";
print "</tr>";


#line 10
print "<tr><td style=text-align:center>";
print "10";
print "</td>";
print "<td style=text-align:left>";
print "<input type=text id=qty9 name=qty9 size=1>\n";
print "</td>";
print "<td>";
print "<select id=uom9 name=uom9>\n";
print "<option value='EA'>EA</option>\n";
print "<option value='LOT'>LOT</option>\n";
print "<option value='KIT'>KIT</option>\n";
print "<option value='LABOR'>LABOR</option>\n";
print "</select>\n";
print "</td>";
print "<td>";
print "<select name=vendor9>\n";
print "<option></option>\n";

opendir (DIR, $directory) or die $!;
while ($file = readdir(DIR)) {

		$venfile = $file;

		($file1, $file2) = split /\./, $file;
		
		if ($file2 eq "txt") {
		$file3 = $file1;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;
		
        unless($file1 =~ m/QUOTE/) {
		
				print  "<option value=$file1>$file3</option>\n";
			}
		}
		
    }

print  "</select>\n";
print "<td>";
print "<input type=text id=stockno9 name=stockno9 size=10>\n";
print "</td>";
print "<td>";
print "<input type=text id=des9 name=des9 size=15>\n";
print "</td>";
print "<td>";
print "\$<input type=text id=ucost9 name=ucost9 size=4>\n";
print "</td>";
print "</tr>";
print "</table>";

#submit form
print "<br><br></b>";
print "<input type=submit> * <input type=reset><br>\n";
print "</form>";
print "<form action=$cgiurl>
    <input type=\"submit\" value=\"Go Home\" >
    </form>";
print "<br><br><br>";
print "</body></html>\n";
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
print "<html><head><title>$wonumber1-$wonumber2 - $bldg - $recipient</title>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 8px;
}
</style></head>\n";

print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
	</script>";

$title = "SHOP $shop - PURCHASING / REPAIR <br>REQUISITION";
print "<body><div id='printMe'><font size=5 color=blue><i><b><center>$title</center></i></b></font>";
print  "<br>";

#$prtype =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>For: </FONT><b><br><FONT SIZE=3>$prtype</b></FONT>\n"; #type of request
print  "<br><br>";

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

print "<FONT SIZE=3 color=blue>Quote number: </FONT><FONT SIZE=3><b>$quote</b></FONT>\n"; #vendor Quote number
print "<br><br>";

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
#my $shop = 245302;
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
print "<FONT SIZE=3 color=blue>Reference: </FONT><FONT SIZE=3><b>$wonumber1-$wonumber2 - $bldg - $recipient</b></FONT>\n";
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
print  "<br></div>";

print "<font size=4 color=blue><b>\"Reference:\" </font><font size=4 color=black>above becomes file name.</b></font><br><br>";

print "<form action=$cgiurl>    
    <input type=button name=print style=background-color:#C42F47 value=\"Print as PDF\" onClick=printDiv('printMe')>\&nbsp\;Choose Destination as <b>\"Save as PDF\" and send file for approval.</b><br><br>
    <input type=\"submit\" value=\"Go Home\" >
</form>";

print "<button onclick=\"goBack()\">Go Back</button>

<script>
function goBack() {
  window.history.back();
}
</script>";

print "<br><br>";




print  "<br><br><br>";

print "</body></html>\n";
exit;

}

sub outputqf { #final document quote form

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

#Quote number generator
my @chars = ("A".."Z", "0".."9");
my $mid;
$mid .= $chars[rand @chars] for 1..12;

print "Content-type: text/html\n\n";
print "<html><head><title>Q-$mid</title>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 8px;
}
</style></head>\n";

print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
	</script>";


print "<body><div id='printMe'>"; #setup for printing, see script above
print  "<br>";

$ven0 =~ tr/_\t/ /s;
print "<FONT SIZE=5 color=#5133FF><i><b><center>Shop $shop - $ven0</center></FONT></i></b>"; #header
print  "<br><br><br>";

print "<FONT SIZE=3 color=blue>Customer: </FONT><FONT SIZE=3><b>$quote</b></FONT>\n"; #Customer
print "<br><br>";

$qprtype =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Type: </FONT><FONT SIZE=3><b>$qprtype\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</b></FONT>\n"; #Type of quote
print "<br><br>";

$bldg =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Project Type: </FONT><FONT SIZE=3><b>$bldg\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</b></FONT>\n"; #Project type
print "<br><br>";

print " <FONT SIZE=3 color=blue>Work Order (if available): </FONT><FONT SIZE=3><b>$wonumber1</b></FONT>\n"; #work order
print "-\n";
print " <FONT SIZE = 3><b>$wonumber2</b></FONT>\n"; #work order phase
print  "<br><br>";

$orderby =~ tr/_\t/ /s;
print "<FONT SIZE=3 color=blue>Quote Created By: </FONT><FONT SIZE=3><b>$orderby\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;</b></FONT>\n"; #created by

$vendor0 =~ tr/_\t/ /s;
$vendor1 =~ tr/_\t/ /s;
$vendor2 =~ tr/_\t/ /s;
$vendor3 =~ tr/_\t/ /s;
$vendor4 =~ tr/_\t/ /s;
$vendor5 =~ tr/_\t/ /s;
$vendor6 =~ tr/_\t/ /s;
$vendor7 =~ tr/_\t/ /s;
$vendor8 =~ tr/_\t/ /s;
$vendor9 =~ tr/_\t/ /s;

print  "<br><br>";
print "<FONT SIZE=3 color=blue>Reference: </FONT><FONT SIZE=3><b>Q-$mid</b></FONT>\n";
print  "<br><br><br>";
print "<table style=width:100\%>";
print "<tr><th><font color=blue>ITEM</font></th><th><font color=blue>QTY</font></th><th><font color=blue>UOM</font></th><th><font color=blue>VENDOR</font></th><th><font color=blue>STOCK#</font></th><th><font color=blue>DESCRIPTION</font></th><th><font color=blue>UNIT COST</font></th><th><font color=blue>TOTAL COST</font></th></tr>";
print "<tr><td>1</td><td>$qty0</td><td>$uom0</td><td>$vendor0</td><td>$stockno0</td><td>$des0</td><td>\$$ucost0</td><td>\$$tcost0</td></tr>";
print "<tr><td>2</td><td>$qty1</td><td>$uom1</td><td>$vendor1</td><td>$stockno1</td><td>$des1</td><td>\$$ucost1</td><td>\$$tcost1</td></tr>";
print "<tr><td>3</td><td>$qty2</td><td>$uom2</td><td>$vendor2</td><td>$stockno2</td><td>$des2</td><td>\$$ucost2</td><td>\$$tcost2</td></tr>";
print "<tr><td>4</td><td>$qty3</td><td>$uom3</td><td>$vendor3</td><td>$stockno3</td><td>$des3</td><td>\$$ucost3</td><td>\$$tcost3</td></tr>";
print "<tr><td>5</td><td>$qty4</td><td>$uom4</td><td>$vendor4</td><td>$stockno4</td><td>$des4</td><td>\$$ucost4</td><td>\$$tcost4</td></tr>";
print "<tr><td>6</td><td>$qty5</td><td>$uom5</td><td>$vendor5</td><td>$stockno5</td><td>$des5</td><td>\$$ucost5</td><td>\$$tcost5</td></tr>";
print "<tr><td>7</td><td>$qty6</td><td>$uom6</td><td>$vendor6</td><td>$stockno6</td><td>$des6</td><td>\$$ucost6</td><td>\$$tcost6</td></tr>";
print "<tr><td>8</td><td>$qty7</td><td>$uom7</td><td>$vendor7</td><td>$stockno7</td><td>$des7</td><td>\$$ucost7</td><td>\$$tcost7</td></tr>";
print "<tr><td>9</td><td>$qty8</td><td>$uom8</td><td>$vendor8</td><td>$stockno8</td><td>$des8</td><td>\$$ucost8</td><td>\$$tcost8</td></tr>";
print "<tr><td>10</td><td>$qty9</td><td>$uom9</td><td>$vendor9</td><td>$stockno9</td><td>$des9</td><td>\$$ucost9</td><td>\$$tcost9</td></tr>";
print "<tr><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td align=left><FONT SIZE=4 color=blue>Total Quote \= </FONT><b>\$$sum</b></td></tr>";
print "</table>";
print  "<br></div>";

print "<font size=4 color=blue><b>\"Reference:\" </font><font size=4 color=black>above becomes file name.</b></font><br><br>";

print "<form action=$cgiurl>    
    <input type=button name=print style=background-color:#C42F47 value=\"Print as PDF\" onClick=printDiv('printMe')>\&nbsp\;Choose Destination as <b>\"Save as PDF\" and send file for approval.</b><br><br>
    <input type=\"submit\" value=\"Go Home\" >
</form>";

print "<button onclick=\"goBack()\">Go Back</button>

<script>
function goBack() {
  window.history.back();
}
</script>";

print "<br><br>";




print  "<br><br><br>";

print "</body></html>\n";



##Create flat file for quote to requisition

my $qtor = "$qdir/Q-$mid\.txt";

	open (QTR, ">>", $qtor)  || die "Cannot open quote file: $!\n";
		print QTR "$quote\n";
		print QTR "$qprtype\n";
		print QTR "$bldg\n";
		print QTR "$wonumber1-$wonumber2\n";
		print QTR "$orderby\n";
		print QTR "Q-$mid\n";
		print QTR "$qty0\n";
		print QTR "$uom0\n";
		print QTR "$vendor0\n";
		print QTR "$stockno0\n";
		print QTR "$des0\n";
		print QTR "$ucost0\n";
		print QTR "$tcost0\n";
		print QTR "$qty1\n";
		print QTR "$uom1\n";
		print QTR "$vendor1\n";
		print QTR "$stockno1\n";
		print QTR "$des1\n";
		print QTR "$ucost1\n";
		print QTR "$tcost1\n";
		print QTR "$qty2\n";
		print QTR "$uom2\n";
		print QTR "$vendor2\n";
		print QTR "$stockno2\n";
		print QTR "$des2\n";
		print QTR "$ucost2\n";
		print QTR "$tcost2\n";
		print QTR "$qty3\n";
		print QTR "$uom3\n";
		print QTR "$vendor3\n";
		print QTR "$stockno3\n";
		print QTR "$des3\n";
		print QTR "$ucost3\n";
		print QTR "$tcost3\n";
		print QTR "$qty4\n";
		print QTR "$uom4\n";
		print QTR "$vendor4\n";
		print QTR "$stockno4\n";
		print QTR "$des4\n";
		print QTR "$ucost4\n";
		print QTR "$tcost4\n";
		print QTR "$qty5\n";
		print QTR "$uom5\n";
		print QTR "$vendor5\n";
		print QTR "$stockno5\n";
		print QTR "$des5\n";
		print QTR "$ucost5\n";
		print QTR "$tcost5\n";
		print QTR "$qty6\n";
		print QTR "$uom6\n";
		print QTR "$vendor6\n";
		print QTR "$stockno6\n";
		print QTR "$des6\n";
		print QTR "$ucost6\n";
		print QTR "$tcost6\n";
		print QTR "$qty7\n";
		print QTR "$uom7\n";
		print QTR "$vendor7\n";
		print QTR "$stockno7\n";
		print QTR "$des7\n";
		print QTR "$ucost7\n";
		print QTR "$tcost7\n";
		print QTR "$qty8\n";
		print QTR "$uom8\n";
		print QTR "$vendor8\n";
		print QTR "$stockno8\n";
		print QTR "$des8\n";
		print QTR "$ucost8\n";
		print QTR "$tcost8\n";
		print QTR "$qty9\n";
		print QTR "$uom9\n";
		print QTR "$vendor9\n";
		print QTR "$stockno9\n";
		print QTR "$des9\n";
		print QTR "$ucost9\n";
		print QTR "$tcost9\n";
		print QTR $sum;
	close QTR;


exit;

}


sub createreq {  #Lookup and create requisition(s) from quote file

opendir (DIR, $qdir) or die $!;
	while ($file = readdir(DIR)) {

		($file1, $file2) = split /\./, $file;
		$file1 =~ s/^.*?://;
		$file1 =~ tr/ \t/_/s;
		$file1 =~ s/^_//;

		if ($file1 eq $findq) {
			
			open (QUO, "<$qdir/$file")  || die "Cannot open quote file: $!\n";
			my @qlist = <QUO>;
			close QUO;
				foreach (@qlist) {
					$_ =~ s/^.*?://;
					$_ =~ tr/ \t/_/s;
					$_ =~ s/^_//;
					$_ =~ tr/_/ /;
					push (@newqlist, $_);
				}
			
		}
				
	}
				
				
				@item1 = splice @newqlist, 6, 7;
				@item2 = splice @newqlist, 6, 7;
				@item3 = splice @newqlist, 6, 7;
				@item4 = splice @newqlist, 6, 7;
				@item5 = splice @newqlist, 6, 7;
				@item6 = splice @newqlist, 6, 7;
				@item7 = splice @newqlist, 6, 7;
				@item8 = splice @newqlist, 6, 7;
				@item9 = splice @newqlist, 6, 7;
				@item10 = splice @newqlist, 6, 7;
				
#@item1 check			
					if ($item1[2] eq $item2[2]) {
							push (@item1, @item2);
							splice (@item2, 0,7, (''));
					}
					if ($item1[2] eq $item3[2]) {
							push (@item1, @item3);
							splice (@item3, 0,7, (''));
					}
					if ($item1[2] eq $item4[2]) {
							push (@item1, @item4);
							splice (@item4, 0,7, (''));
					}
					if ($item1[2] eq $item5[2]) {
							push (@item1, @item5);
							splice (@item5, 0,7, (''));
					}
					if ($item1[2] eq $item6[2]) {
							push (@item1, @item6);
							splice (@item6, 0,7, (''));
					}
					if ($item1[2] eq $item7[2]) {
							push (@item1, @item7);
							splice (@item7, 0,7, (''));
					}
					if ($item1[2] eq $item8[2]) {
							push (@item1, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item1[2] eq $item9[2]) {
							push (@item1, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item1[2] eq $item10[2]) {
							push (@item1, @item10);
							splice (@item10, 0,7, (''));
					}
					
#@item2 check
					if ($item2[2] eq $item3[2]) {
							push (@item2, @item3);
							splice (@item3, 0,7, (''));
					}
					if ($item2[2] eq $item4[2]) {
							push (@item2, @item4);
							splice (@item4, 0,7, (''));
					}
					if ($item2[2] eq $item5[2]) {
							push (@item2, @item5);
							splice (@item5, 0,7, (''));
					}
					if ($item2[2] eq $item6[2]) {
							push (@item2, @item6);
							splice (@item6, 0,7, (''));
					}
					if ($item2[2] eq $item7[2]) {
							push (@item2, @item7);
							splice (@item7, 0,7, (''));
					}
					if ($item2[2] eq $item8[2]) {
							push (@item2, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item2[2] eq $item9[2]) {
							push (@item2, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item2[2] eq $item10[2]) {
							push (@item2, @item10);
							splice (@item10, 0,7, (''));
					}					
#@item3 check				
					
					if ($item3[2] eq $item4[2]) {
							push (@item3, @item4);
							splice (@item4, 0,7, (''));
					}
					if ($item3[2] eq $item5[2]) {
							push (@item3, @item5);
							splice (@item5, 0,7, (''));
					}
					if ($item3[2] eq $item6[2]) {
							push (@item3, @item6);
							splice (@item6, 0,7, (''));
					}
					if ($item3[2] eq $item7[2]) {
							push (@item3, @item7);
							splice (@item7, 0,7, (''));
					}
					if ($item3[2] eq $item8[2]) {
							push (@item3, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item3[2] eq $item9[2]) {
							push (@item3, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item3[2] eq $item10[2]) {
							push (@item3, @item10);
							splice (@item10, 0,7, (''));
					}
#@item4 check

					if ($item4[2] eq $item5[2]) {
							push (@item4, @item5);
							splice (@item5, 0,7, (''));
					}
					if ($item4[2] eq $item6[2]) {
							push (@item4, @item6);
							splice (@item6, 0,7, (''));
					}
					if ($item4[2] eq $item7[2]) {
							push (@item4, @item7);
							splice (@item7, 0,7, (''));
					}
					if ($item4[2] eq $item8[2]) {
							push (@item4, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item4[2] eq $item9[2]) {
							push (@item4, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item4[2] eq $item10[2]) {
							push (@item4, @item10);
							splice (@item10, 0,7, (''));
					}
#@item 5 check

					if ($item5[2] eq $item6[2]) {
							push (@item5, @item6);
							splice (@item6, 0,7, (''));
					}
					if ($item5[2] eq $item7[2]) {
							push (@item5, @item7);
							splice (@item7, 0,7, (''));
					}
					if ($item5[2] eq $item8[2]) {
							push (@item5, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item5[2] eq $item9[2]) {
							push (@item5, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item5[2] eq $item10[2]) {
							push (@item5, @item10);
							splice (@item10, 0,7, (''));
					}
#@item 6 check
					if ($item6[2] eq $item7[2]) {
							push (@item6, @item7);
							splice (@item7, 0,7, (''));
					}
					if ($item6[2] eq $item8[2]) {
							push (@item6, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item6[2] eq $item9[2]) {
							push (@item6, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item6[2] eq $item10[2]) {
							push (@item6, @item10);
							splice (@item10, 0,7, (''));
					}
#@item 7 check
					if ($item7[2] eq $item8[2]) {
							push (@item7, @item8);
							splice (@item8, 0,7, (''));
					}
					if ($item7[2] eq $item9[2]) {
							push (@item7, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item7[2] eq $item10[2]) {
							push (@item7, @item10);
							splice (@item10, 0,7, (''));
					}
#@item 8 check	
					if ($item8[2] eq $item9[2]) {
							push (@item8, @item9);
							splice (@item9, 0,7, (''));
					}
					if ($item8[2] eq $item10[2]) {
							push (@item8, @item10);
							splice (@item10, 0,7, (''));
					}
#@item 9 check
					if ($item9[2] eq $item10[2]) {
							push (@item9, @item10);
							splice (@item10, 0,7, (''));
					}
		
			chomp(@firstreq = @item1[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@secondreq = @item2[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@thirdreq = @item3[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@forthreq = @item4[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@fifthreq = @item5[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@sixthreq = @item6[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@seventhreq = @item7[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@eigthreq = @item8[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@ninthreq = @item9[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);
			chomp(@tenthreq = @item10[0,1,3,4,5,6,7,8,10,11,12,13,14,15,17,18,19,20,21,22,24,25,26,27,28,29,31,32,33,34,35,36,38,39,40,41,42,43,45,46,47,48,49,50,52,53,54,55,56,57,59,60,61,62,63,64,66,67,68,69]);

		print "Content-type: text/html\n\n";
		
		
		print "<script>
		function printDiv(divName){
			var printContents = document.getElementById(divName).innerHTML;
			var originalContents = document.body.innerHTML;

			document.body.innerHTML = printContents;

			window.print();

			document.body.innerHTML = originalContents;

		}
		</script>";
		print "<html><head><title>$newqlist[3] - </title>";
		
		LOOP:
		
		chomp(@newqlist);
		print "		
		<style>
		table, th, td {
		border: 1px solid black;
		border-collapse: collapse;
		}
		th, td {
		padding: 8px;
		}
		</style></head>\n";

		$title = "SHOP 245302 - PURCHASING / REPAIR <br>REQUISITION";
		
		$count1++;
		if($count1 == 1){
			$venreq = $item1[2];
		}
		
		if($count1 == 2){
			$venreq = $item2[2];
			@firstreq = @secondreq;
		}
		
		if($count1 == 3){
			$venreq = $item3[2];
			@firstreq = @thirdreq;
		}
		
		if($count1 == 4){
			$venreq = $item4[2];
			@firstreq = @forthreq;
		}
				
		if($count1 == 5){
			$venreq = $item5[2];
			@firstreq = @fifthreq;
		}
		
		if($count1 == 6){
			$venreq = $item6[2];
			@firstreq = @sixthreq;
		}
		
		if($count1 == 7){
			$venreq = $item7[2];
			@firstreq = @seventhreq;
		}
		
		if($count1 == 8){
			$venreq = $item8[2];
			@firstreq = @eigthreq;
		}
		
		if($count1 == 9){
			$venreq = $item9[2];
			@firstreq = @ninthreq;
		}
		
		if($count1 == 10){
			$venreq = $item10[2];
			@firstreq = @tenthreq;
		}
	
		if($venreq lt " ") {
			goto THEEND;
		}
		
		print "<div id=$count1>";
		print "<body><font size=5 color=blue><i><b><center>$title</center></i></b></font>";
		
		print  "<br>";
		
		chomp($venreq);
		$venreq =~ s/\s+$//;
		
		my $nextven = "$directory/$venreq.txt";
		
#print $nextven;	

		open (NEW, "<", $nextven) || die "Cannot open vendor file: $!\n";
			@newlist = ();
			@vlist = <NEW>;
			foreach(@vlist) {
			$_ =~ s/^.*?://;
			$_ =~ s/^_//;
			$_ =~ s/^\s+//;
			push (@newlist, $_);
			}	
		close NEW;

	
		
		chomp(@newlist);
			
		print "<FONT SIZE=3 color=blue>Vendor: </FONT><b><br><FONT SIZE=3>$newlist[0]</b></FONT>\n"; #vendor name
		print  "<br>";

		print "<FONT SIZE = 2><b>$newlist[1]</b></FONT>\n"; #vendor address
		print  "<br><br>";
		print "<FONT SIZE=3 color=blue>Cust No: </FONT><FONT SIZE=3><b>$newlist[4]</b></FONT><br><br>\n"; #our cust number
		print "<FONT SIZE=3 color=blue>Phone: </FONT><FONT SIZE=3><b>$newlist[2]\&nbsp\;\&nbsp\;</b></FONT>\n"; #vendor main phone
		print "<FONT SIZE=3 color=blue>Fax: </FONT><FONT SIZE=3><b>$newlist[3]</b></FONT>\n"; #vendor fax
		print  "<br><br>";
		print "<FONT SIZE=3 color=blue>Rep: </FONT><FONT SIZE=3><b>$newlist[5]</b></FONT>\&nbsp\;\&nbsp\;\n"; #vendor rep
		print " <FONT SIZE=3 color=blue>Rep Phone: </FONT><FONT SIZE=3><b>$newlist[6]</b></FONT>\&nbsp\;\&nbsp\;\n"; #rep phone
		print " <FONT SIZE=3 color=blue>Rep Email: </FONT><FONT SIZE=3><b>$newlist[7]</b></FONT>\n"; #rep email
		print "<br><br>";
		print " <FONT SIZE=3 color=blue>Work Order: </FONT><FONT SIZE=3><b>$newqlist[3]</b></FONT>\n"; #work order
		print "<FONT SIZE=3 color=blue>\&nbsp\;\&nbsp\;Shop: </FONT><b><FONT SIZE=3>$shop</b></FONT>\n"; #shop number
		print  "<br><br>";
		print "<FONT SIZE=3 color=blue>Ship To: </FONT><FONT SIZE=3><b>Dwayne Ayers - UNC-CH, 136L Giles Horney Bldg., 103 Airport Dr Chapel Hill, NC 27599</b></FONT>";
		print  "<br><br>";
		print "<FONT SIZE=3 color=blue>Reference: </FONT><FONT SIZE=3><b>$newqlist[3] - $newlist[0]</b></FONT>\n";
		print  "<br><br>";
		print "<table style=width:100\%>";
		print "<tr><th><font color=blue>ITEM</font></th><th><font color=blue>QTY</font></th><th><font color=blue>UOM</font></th><th><font color=blue>STOCK#</font></th><th><font color=blue>DESCRIPTION</font></th><th><font color=blue>UNIT COST</font></th><th><font color=blue>TOTAL COST</font></th></tr>";
		print "<tr><td>1</td><td>$firstreq[0]</td><td>$firstreq[1]</td><td>$firstreq[2]</td><td>$firstreq[3]</td><td>\$$firstreq[4]</td><td>\$$firstreq[5]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[6]</td><td>$firstreq[7]</td><td>$firstreq[8]</td><td>$firstreq[9]</td><td>\$$firstreq[10]</td><td>\$$firstreq[11]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[12]</td><td>$firstreq[13]</td><td>$firstreq[14]</td><td>$firstreq[15]</td><td>\$$firstreq[16]</td><td>\$$firstreq[17]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[18]</td><td>$firstreq[19]</td><td>$firstreq[20]</td><td>$firstreq[21]</td><td>\$$firstreq[22]</td><td>\$$firstreq[23]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[24]</td><td>$firstreq[25]</td><td>$firstreq[26]</td><td>$firstreq[27]</td><td>\$$firstreq[28]</td><td>\$$firstreq[29]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[30]</td><td>$firstreq[31]</td><td>$firstreq[32]</td><td>$firstreq[33]</td><td>\$$firstreq[34]</td><td>\$$firstreq[35]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[36]</td><td>$firstreq[37]</td><td>$firstreq[38]</td><td>$firstreq[39]</td><td>\$$firstreq[40]</td><td>\$$firstreq[41]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[42]</td><td>$firstreq[43]</td><td>$firstreq[44]</td><td>$firstreq[45]</td><td>\$$firstreq[46]</td><td>\$$firstreq[47]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[48]</td><td>$firstreq[49]</td><td>$firstreq[50]</td><td>$firstreq[51]</td><td>\$$firstreq[52]</td><td>\$$firstreq[53]</td></tr>";
		print "<tr><td>1</td><td>$firstreq[54]</td><td>$firstreq[55]</td><td>$firstreq[56]</td><td>$firstreq[57]</td><td>\$$firstreq[58]</td><td>\$$firstreq[59]</td></tr>";

		my $sum = $firstreq[5] + $firstreq[11] + $firstreq[17] + $firstreq[23] + $firstreq[29] + $firstreq[35] + $firstreq[41] + $firstreq[47] + $firstreq[53] + $firstreq[59];
		print "<tr><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td bgcolor=black></td><td align=left><FONT SIZE=4 color=blue>Total Order \= </FONT><b>\$$sum</b></td></tr>";
		print "</table>";
		print  "<br>";

		
		
		print  "</div>";
		print "<p style=\"page-break-before: always\">";
		print "<input type=button style=background-color:#C42F47 name=print value=\"Print as PDF\" onClick=printDiv($count1)>\&nbsp\;\&nbsp\;\&nbsp\;Choose Destination as <b>\"Save as PDF\" </b>add vendor to file name and send file for approval.";
		print "<hr class=\"rounded\">";
		print "<br><br>";
		if($count1 == 10){
			goto THEEND;
		}
		goto LOOP;
			
	THEEND:
		print "<form action=$cgiurl>
		<input type=\"submit\" value=\"Go Home\" >
		</form>";
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









