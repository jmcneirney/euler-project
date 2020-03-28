#!/usr//env perl

use strict;
use warnings;
use v5.30;  # why are you requiring this

use Data::Dumper;
use LWP::Simple qw(get);     # hows bout using http::tiny or at least look into using something
use HTML::TreeBuilder;       # that allows you to use dependency injection. So the module can 
use Scalar::Util qw(blessed);# use AnyEvent::Http or http::tiny of something like that.
use Pod::Usage;              # Note that doing this is just to do it not because it's the best way. 
use Readonly;                # AnyEvent::HTTP isn't oop either ...
use Cwd qw(abs_path getcwd);
use Getopt::Long;
use Carp;
use Try::Tiny;
use Role::Tiny::With;
use open ':std', ':encoding(UTF-8)';
use Config::Any;
use lib './perl/lib';
use Problem;
use Euler::Schema;
use LWP::Simple;

# add some logging use a nosql DB for logging
# and mysql for something else
# 
# throw some database stuff in this project too
# record results and some other stuff
# id int(5) not null,
# result text not null, -- not sure what values to expect -- maybe a json string
# date_completed datetime default now,
# other stuff ... 
# This ^ should probably go in a role.  use DBIx::Class
=head2 SYNOPSIS

  perl project_setup.pl [--options]
  
  $ perl project_setup.pl --problem_id=22

  $ perl project_setup.pl --problems --from=3 --to=9

  $ perl project_setup.pl --problem_id=44 --where=/path/to/file

=cut

my ($problem_id, $problems, $from, $to, $update, $where);
GetOptions(
    "problem_id=i" => \$problem_id,  # problem id
    "problems"  => \$problems, # bool suggesting to from and to are required (a range) Change the name
    "from=i"    => \$from,     # start problem id
    "to=i"      => \$to,       # end problem id
    "update"    => \$update,   # get the most recent ones or something
    "where=s"   => \$where,    # /path/to/base_dir
) or die pod2usage( verbose => 2, section => 'SYNOPSIS' );

# Chief! you gotta set some defaults before doing this
#if( !$problem_id || ( $where and not ( $problem_id or $problems ) ) ) {
#    say "What do you want to put in $where?\n";
#    die pod2usage( verbose => 2, section => 'SYNOPSIS' );
#}

my $config = Config::Any->load_files(
    {
        files           => ['config.yml'],
        flatten_to_hash => 1,
        use_ext         => 1,
     }
)->{'config.yml'};


# 1) result checker -not in this file
# Add a result checker that would require you to login to euler-project.org(com|net) and check the result
# Look into it.

# 2)
# how's bout making this a git repo from the start - so only in the last else block
# use some kinda perl module Git::DoStuff::Dot::Com::Net::This maybe
# Idea being that once this is built then it's ready to use.


Readonly my %languages => %{ $config->{languages} };
Readonly my $base_dir => './euler-project';  # You've got this in the $problem. Why is it here?
Readonly my %comments_prefixes => %{ $config->{comments} };

my $problem = Problem->new({
    base_dir   => Path::Tiny->new( $base_dir ),
    uri        => URI->new("https://projecteuler.net/problem="),
    problem_id => $problem_id,
    schema     => ( -e 'euler.db' ) ?
        Euler::Schema->connect('dbi:SQLite:dbname=' . abs_path() . '/euler.db') : (),
    user_agent => LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 }),
});

my $cur_dir = getcwd();
# Check if the file exists and bail out if it does
# have a config with the directory sturcture and check to see if
# any of the files have been created first. If they have then skip
# and go to the next.
# base directory == 'euler-project'
if( -d "$cur_dir") {
    say 'Project exists';
    my $problem_dir = "$cur_dir/p" . $problem->problem_id;
    if( -d $problem_dir ) {
        say "problem exists";
        my $problem_contents = $problem->fetch_problem();
        chdir( $problem_dir );
# There's some repetition here and in the else block			# !!! figure out what the difference is and pass in an anon sub{}
# that you need in the second else block                                # create_problem( languages => \%languages, id => prob_id, how => sub { } );
# scoop it out and reuse it.                                            # or something like that
        my $too_many_failures = 0;                                      # this is going into the Problem module?
        foreach my $lang ( keys %languages ) {
            my $problem_dir_lang = "$problem_dir/$lang";                # make logging a service so everything use the same thing for logging
            chdir( $problem_dir_lang );                                 # 
            if( -e "$problem_dir/$lang/problem_$problem_id.$languages{$lang}" ) {
                say "$problem_dir/$lang/problem_$problem_id.$languages{$lang} already exists";
                next;
            } else {
                try {
                    $problem->language($lang);
                    $problem->make_files({
                        path       => "$problem_dir/$lang",
                        problem_id => $problem_id,
                    });
                } catch {
                    carp "Error making $lang file for problem $problem_id\n";
                    $too_many_failures++;
                }
#                finally {
#                    if( $too_many_failures > scalar( @{ keys %languages }) ) {
#                        croak "Unable to create files.\n Aborting ...\n";
#                    }
#                };
            }
        }
    } else {
        say "Problem doesn't exist";

        if( $problem->schema ) {
            my $result = $problem->schema->resultset('Problem');
            my $insert = $result->create({
               name => 'Problem ' . $problem->problem_id,
               text => 'lkjasdlfjasdlkfjalsdjkflasjdflajsdlfkajsdlfkjalskdjflakds',
               solution => '234432',
            });
        }

        my $problem_dir = "$cur_dir/p$problem_id";
        mkdir( $problem_dir );
        chdir( $problem_dir );
        my $too_many_failures = 0;
        foreach my $lang ( keys %languages ) {
            my $problem_dir_lang = "$problem_dir/$lang";
            $problem->problem_dir( Path::Tiny->new($problem_dir_lang) );
            mkdir( $problem_dir_lang );
            chdir( $problem_dir_lang );
            try { 
                $problem->language($lang);
                $problem->make_files();
            } catch {
                carp "Error making $lang file for problem $problem_id\n" . Dumper( $_ );
                $too_many_failures++;
#            } finally {
#                if( $too_many_failures > scalar( @{ keys %languages }) ) {
#                    croak "Unable to create files.\n Aborting ...\n";
#                }
            };
            chdir('..');
        }
    }
} else {
    # Starting a new project ...
    say "Project doesn't exist";
    say "Do you want to start now? y or n";
    # read in a line y || n
    my $answer = lc(<>);
    say $answer;
    if( $answer eq 'n' ) {
        say "What's up bro?!?!? You gotta problem?!?!?!";
        exit;
    } else {
        mkdir( $base_dir );
        chdir( $base_dir );
############ same as up there ^ ####################
my $problem_dir;
        foreach my $lang ( keys %languages ) {
            my $problem_dir_lang = "$problem_dir/$lang";
            mkdir( $problem_dir_lang );
            chdir( $problem_dir_lang );
            # Make_files
            $problem->language($lang);
            $problem->make_files();
            chdir('..');
        }
####################################################

        if( $problem->schema ) {
            my $result = $problem->schema->resultset('Problem');
            my $insert = $result->create({
               name => 'Problem ' . $problem->problem_id,
               text => 'lkjasdlfjasdlkfjalsdjkflasjdflajsdlfkajsdlfkjalskdjflakds',
               solution => '234432',
            });
        }

    }
}

