#!/afs/isis/pkg/perl/bin/perl

# SEND NEW VENDOR INFO 

use MIME::Lite;
use strict;
use warnings;

my $nr = "no_reply\@email.unc.edu";
my $err = "NO DATA TRY AGAIN";
my $email = "dayers\@fac.unc.edu";
my ($buffer, @pairs, $name, $value, %FORM, $newven);

my $cgiurl = "index.pl";  #un-rem line for production

#my $cgiurl = "lspurch.pl"; #rem line for production

#my $directory = './vendors'; #Rem for production

my $directory = "/opt/app-root/src/vendors"; # Un-rem For production

# Get the input from forms
###########################
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

#if no form data go to system start
   if (!$buffer) { 
         &error;
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

	$FORM{newven} = uc($FORM{newven});

   #email to administrator
	my $msg = MIME::Lite->new(
        From    => $nr,
        To      => $email,
        Subject => 'PLEASE ADD NEW VENDOR',
        Type    =>'multipart/mixed'
		);
		
	$msg->attach(
        Type     => 'TEXT',
        Data     => "Please add\n\n$FORM{newven}\n\nto our list of vendors.\nThank you,\n$FORM{reqstr}\n",
		);

	MIME::Lite->send('smtp','relay.unc.edu',Debug=>0);	
	$msg->send();
 # opendir (DIR, $directory) or die $!;	
	open ($newven, ">>", "$directory/$FORM{newven}\.txt")  || die "Cannot create new vendor file: $!\n";
			print $newven "vendor: $FORM{newven}\n";
			print $newven "address:\n";
			print $newven "phone:\n";
            print $newven "fax:\n";
            print $newven "cust:\n";
            print $newven "rep:\n";
            print $newven "cell:\n";
            print $newven "email:\n";
    close $newven;
	#close DIR;

   # Vendor add request sent
   
   print "Content-type: text/html\n\n";
   print "<html><head><title>Request sent</title><script>\n";
   print "function goBack() { window.history.back()}\n";
   print "</script></head>\n";
   print "<body><FONT SIZE = 5><b>Request for adding vendor sent,<br>";
   print "Hit Go back buttom below, vendor should be in list.<br>";
   print "Thank you!</b></FONT><br><br>";
   print "<form action=$cgiurl>
    <input type=\"submit\" value=\"Go Back\" >
    </form>";
   print  "<br><br>";
   print "</body></html>\n";
   exit;
   
sub error {               #Process error messages
print "Content-type: text/html\n\n";
print "<html><head><title>NEW VENDOR SUBMIT ERROR</title><script>\n";
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
