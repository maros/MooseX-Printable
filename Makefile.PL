# Load the Module::Install bundled in ./inc/
use strict;
use inc::Module::Install;


my $from = 'lib/MooseX/Printable.pm';

# Define metadata
name            'MooseX-Printable';
all_from        $from;
readme_from     $from;
readme_markdown_from $from;

perl_version    '5.010';

# Specific dependencies
requires        'Moose'                 => 0;
requires        'Text::SimpleTable'     => 0;

build_requires  'Test::NoWarnings'      => 0;

author_requires 'Module::Install::ReadmeMarkdownFromPod'=> 0;
author_requires 'Module::Install::ReadmeFromPod'        => 0;

repository 'git://github.com/maros/MooseX-Printable.git';


WriteAll;