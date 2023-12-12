#!/usr/bin/perl

use warnings;
use strict;

use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(abs_path($0));

use Tools;

my $filename = 'input.txt';
# my $filename = 'example.txt';

open(FH, '<', $filename) or die $!;

my %allowed = (
    "red"   => 12,
    "green" => 13,
    "blue"  => 14,
);
my %indexMap = (
    "red"   => 0,
    "green" => 1,
    "blue"  => 2,
);

my $sum = 0;
line:
while (<FH>) {
    $_ =~ /Game (\d+): (.*)/; # parse out values
    my $id = $1;
    my $results = $2;

    my @pulls = split /;/, $results;
    my $pull;
    my @mins = (0, 0, 0);
    foreach $pull (@pulls) {
        my @colors = split /,/, $pull;
        my $color;
        foreach $color (@colors) {
            $color = Tools::trim($color);
            $color =~ /(\d+) (.*)/;
            my $number = $1;
            my $name = $2;
            my $currentMin = @mins[$indexMap{$name}];
            @mins[$indexMap{$name}] = $number if ($currentMin < $number);
            # next line if($allowed{$name} < $number);
        }
    }
    $sum += $mins[0] * $mins[1] * $mins[2];
}

print $sum, "\n";
