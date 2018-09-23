#!/bin/perl

use strict;
use warnings;

use 5.010;

use File::Basename qw(fileparse);
use JSON;
use Method::Signatures;
use YAML::Any;

func action_json(...)
{
    actions();
    say '';
    say 'called json';
}

func action_yaml(...)
{
    actions();
    say '';
    say 'called yaml';
}

func actions()
{
    my @actions = grep { /^action_/ } keys %main::;
    s/^action_// for @actions;

    say 'Available actions:';
    say '  ' . $_ for sort @actions;
}

func run()
{
    unless (@ARGV > 0)
    {
        my ($filename, $dirs, $suffix) = fileparse($0);
        say 'Usage: ' . $filename . ' <action>';
        say '';
        actions();
        return;
    }

    my $action   = $ARGV[0];
    my $sub_name = 'action_' . $action;
    my $sub      = main->can($sub_name);
    
    if ($sub)
    {
        $sub->([ @ARGV[1 .. $#ARGV] ]);
    }
    else
    {
        # calling can vivifies the namespace entry
        delete $main::{$sub_name};

        say 'Not an action: ' . $action;
        say '';
        actions();
    }

    return;
}

run();

