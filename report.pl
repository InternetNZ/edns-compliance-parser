#!/usr/bin/perl
#
# Process results file from ednscomp tool
# Expected input format:
#   DOMAIN @IP (NSNAME.): dns=RESULT[,RESULT] edns=RESULT[,RESULT] edns1=RESULT[,RESULT] edns@512=RESULT[,RESULT] ednsopt=RESULT[,RESULT] edns1opt=RESULT[,RESULT] do=RESULT[,RESULT] ednsflags=RESULT[,RESULT] optlist=RESULT[,RESULT] signed=RESULT[,RESULT] ednstcp=RESULT[,RESULT]
#
# Author: Hugo Salgado hsalgado@nic.cl
#
use strict;
use warnings;

my @E = ('edns', 'edns1', 'edns@512', 'ednsopt', 'edns1opt', 'do', 'ednsflags', 'optlist', 'signed', 'ednstcp');

my %er;
while (<>) {
    my @f = split / /;
    next unless $f[3];
    if ($f[3] eq 'dns=ok') {
        for (my $i=4; $i <= 13; $i++) {
            my $c = $f[$i];
            $c =~ s/^$E[$i-4]=//;
            my @ch = split /,/, $c;
            foreach my $e (@ch) {
                chomp $e;
                $er{$E[$i-4]}{$e}++;
            }
        }
    }
}

foreach my $k (@E) {
    print $k, "\n";
    foreach my $l (sort {$er{$k}{$a} <=> $er{$k}{$b}} keys $er{$k}) {
        print "\t$l: ", $er{$k}{$l}, "\n";
    }
}

