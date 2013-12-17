#!/usr/bin/perl
# Author: Lucas Thoresen
# Rochester Institute of Technology 2013
# License: MIT (Free and Open!)

use strict;
use warnings;
use Term::ANSIColor;

# Introdution and useage
print "Initializing Overheard Daemon [Verbose Mode]\n";
sleep(2);

# Simple check for the number of arguments
if (@ARGV == 2) {

    # Configure based on arguments
    my $hostRange     = $ARGV[0];
    my $sweepInterval = $ARGV[1];

    # Main program loop begins here
    while (1) {
        print "Conducting Host Discovery on <$hostRange>\n";

        # Conduct the sweep
        my @hostList = sweep_subnet($hostRange);

        # Only bother to do anything if hosts were found
        if (@hostList) {
            # Loop through the list of hosts and conduct test
            foreach (@hostList) {
                my $currentHost = $_;
                chomp($currentHost);
                print "Found: $currentHost\n";
                print "Conducting Promiscuous Mode Test On $currentHost\n";

                if (test_host($currentHost)) {
                    # A host is sniffing! Print this with terminal colors on!
                    print color "bold red";
                    print "[WARN] $currentHost has dropped into promiscuous mode!!\n";
                    print color "reset";
                }
            }
        } else {
            print "No New Hosts Discovered\n";
        }

        # Wait before conducting each test again
        sleep $sweepInterval;
    }

    # Loop through the list of hosts and test each one


} else {
    print "Correct usage: ./overheard.pl <subnet mask> <scan interval>\n\n";
    print "Example: ./overheard.pl 192.168.1.0/24 3\n\n";
    exit(1);
}

# This subroutine is responsible for host discovery by
# conducting a ping sweep of the entire subnet
# parameters: $hostRange
# returns: %hostList
sub sweep_subnet {
    my @hostList;
    my $hostRange = $_[0];
    my @output = `nmap -sP $hostRange | grep 'Nmap scan report'`;

    # Loop an remove junk from NMAP
    while (my ($i, $host) = each @output) {
        $host =~ s/Nmap scan report for //g;
        $hostList[$i] = $host;
    }

    # Return the completed list of hosts
    return @hostList;
}

# This subroutine is responsible for the testing of individual
# hosts on the network to see if they might be sniffing
# parameters: $host (scalar IP address)
# return: scalar (bool sniffing or not)
sub test_host {
    my $target = $_[0];
    my @output = `nmap -script=sniffer-detect.nse $target`;

    # Do a regex match to see if the host is in promiscuous mode
    foreach (@output) {
        my $line = $_;
        if ($line =~ /Likely in promiscuous mode/) {
            return 1;
        }
    }
}