#!/usr/bin/env perl

package Problem; # Part of it anyway

use Type::Tiny;
use Path::Tiny;
use Try::Tiny;
use Scalar::Util qw(blessed);
use Data::Dumper;
use Config::Any;
use LWP::UserAgent;
use URI;
use Moo;
use namespace::clean;

use lib './perl/lib';
use Euler::Schema;

my $PATH = "Type::Tiny"->new(
    name => 'Path',
    constraint => sub { $_->can('path') },
    message    => sub { "$_ doesn't look like a path to me. What's up?" }, 
);

my $URI = "Type::Tiny"->new(
    name => 'URI',
    constraint => sub { $_->can('path') and $_->can('host') },
    message    => sub { "$_ doesn't look like a uri to me. What's up?" }
);

# sub BUILDARGS {
#    print Dumper( \@_ );
#    return \%{$_[0]};
# }

# add something so that if the user select from and to on the command line 
# the problems are retrieved asyncronously
#use HTTP::Async;    #?  which one?
#use AnyEvent::HTTP; #?  So many choices!!

has config => (
    is       => 'ro',
#    isa      => 'HashRef',
    default  => sub {
        Config::Any->load_files(
            {
                files           => ['config.yml'],
                flatten_to_hash => 1,
                use_ext         => 1,
             }
        )->{'config.yml'};
    },
);

# try coercing these from strings /path/to/dir => Path::Tiny obj
has base_dir => (
    is => 'rw',
    required => 0,
    isa => $PATH,
);

has problem_dir => (  # coerce this from a string
    is => 'rw',
    required => 0,
    isa => $PATH,
);

has problem_id => (
    is => 'rw',
);

has language => (
    is => 'rw',
);

has url => (   # seems like you're going to be creating a new problem for each one.
    is => 'rw',  # does that make sense?
);

has content => (
    is => 'rw',
);

has user_agent => (
    is  => 'ro',
    isa => sub {
        my $ua = shift;
        die "Constructor requires a 'LWP::UserAgent'" unless ref($ua) eq 'LWP::UserAgent',
    },
);

has schema => (
    is  => 'ro',
    isa => sub {
        my $schema = shift;
        die "Constructor requires a 'Euler::Schema'" unless ref($schema) eq 'Euler::Schema',
    },
);

sub extension {
    my $self = shift;

    return '.' . $self->config->{languages}{ $self->language };
}

sub comments {
    my $self = shift;

    return $self->config->{comments}{ $self->language };
}

# You're not setting the path to the directory update the driver file to do that
sub make_files {
    my $self = shift;

    my $file = $self->problem_dir . "/problem_" . $self->problem_id . $self->extension;
    open( my $FILE, '>', $file )
            or die "Unable to create problem file for " . $self->language . ' ' . $!;

    my $problem_contents = $self->fetch_problem();
    foreach my $line ( @{ $problem_contents } ) {
        say $FILE $self->comments . $line;
# this oughta be an attribute
        my $result = $self->schema->resultset('Problem');
        my $whathappened = $result->create({
            name => 'entry from Problem',
            text => 'lkjasdlfjasdlkfjalsdjkflasjdflajsdlfkajsdlfkjalskdjflakds',
            solution => '234432',
        });
    }
    close( $FILE );
    return;
}

sub fetch_problem {
    my $self = shift;

    my $params = shift; 
    my $url = "https://projecteuler.net/problem=" . $self->problem_id;

# What not just have a method that gets the content?
    $self->content( $self->user_agent->get($url) );

    return $self->_parse_problem();
}

sub _parse_problem {
    my $self = shift; 

    my $tree = HTML::TreeBuilder->new;
print STDERR Dumper( $self->content );
    $tree->parse( $self->content ); 
    my $problem_title   = $tree->look_down( '_tag' => 'h2' )->as_text;
    
    my $problem_name    = $tree->look_down( 'id' => 'problem_info' )->look_down( '_tag' => 'h3' )->content->[0];
    my $problem_content = $tree->look_down( 'id' => 'problem_info' )
                               ->parent
                               ->look_down( 'class' => 'problem_content' )
                               ->content;

    # the following is only going to work for 'p' attr
    # Y'alls goina need to cycle through everything I guess
    my @problem_text = ();
    foreach my $elem ( @{ $problem_content } ) {
        # if elem isa something do X else do Y
        if( blessed( $elem ) ) {
            for( $elem->tag ) {
# make this work for non p tags
                if( /p/ ) {
                    push @problem_text, $elem->as_text;
                }
                if( /ul/ ) {
                   # call some sub that does stuff
                }
            }
        }
    }
    return \@problem_text;
}

1;

