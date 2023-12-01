#!/usr/bin/perl

use warnings;
use strict;

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

print "Hello, World!","\n";

print "1234"+0.567,"\n";

my $filename = 'example.txt';

open(FH, '<', $filename) or die $!;

my $sum = 0;

while(<FH>){
   $_ =~ s/^\s+|\s+$//g;
   print "I saw [$_]", "\n";
   $sum+=$_;
}

print $sum, "\n";

my $text = "Hello, World!";
my $i = 0;

for $i (0..length($text)-1){
    my $char = substr($text, $i, 1);
    print "Index: $i, Text: $char \n";
}
foreach $i(5..10){
    print $i."\n";
}

my $char;
foreach $char (split //, $text) {
  print "$char\n";
}
my @days = qw(Mon Tue Wed Thu Fri Sat Sun);
print("@days" ,"\n");

my @stack = ();

print("push 1 to array\n");

push(@stack,1);

print("push 2 to array\n");
push(@stack,2);

print("push 3 to array\n");
push(@stack,3);

print("@stack", "\n");

my $elem = pop(@stack);
print("element: $elem\n");


my $last = $#days;
print($last," - ",$days[$last], "\n");
