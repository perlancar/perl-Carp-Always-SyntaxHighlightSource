package Carp::Always::SyntaxHighlightSource;

use 5.010001;
use strict;
use warnings;
use Carp::SyntaxHighlightSource;

# VERSION

our %options;

sub import {
    my $class = shift;
    %options = @_;
}

sub _warn {
    if ($_[-1] =~ /\n$/s) {
        my $arg = pop @_;
        $arg =~ s/ at .*? line .*?\n$//s;
        push @_, $arg;
    }
    $Carp::SyntaxHighlightSource::CarpLevel = 1;
    warn Carp::SyntaxHighlightSource::longmess_heavy(join('', grep { defined } @_), %options);
}

sub _die {
    if ($_[-1] =~ /\n$/s) {
        my $arg = pop @_;
        $arg =~ s/ at .*? line .*?\n$//s;
        push @_, $arg;
    }
    $Carp::SyntaxHighlightSource::CarpLevel = 1;
    die Carp::SyntaxHighlightSource::longmess_heavy(join('', grep { defined } @_), %options);
}

my %OLD_SIG;

BEGIN {
    @OLD_SIG{qw(__DIE__ __WARN__)} = @SIG{qw(__DIE__ __WARN__)};
    $SIG{__DIE__} = \&_die;
    $SIG{__WARN__} = \&_warn;
}

END {
    no warnings 'uninitialized';
    @SIG{qw(__DIE__ __WARN__)} = @OLD_SIG{qw(__DIE__ __WARN__)};
}

1;
#ABSTRACT: Carp::Always, but show syntax-highlighted source code context

=head1 SYNOPSIS

 % perl -MCarp::Always::SyntaxHighlightSource script.pl

Or, for less carpal tunnel syndrome:

 % perl -MCarp::Always::SHS script.pl


=head1 DESCRIPTION


=head1 CREDITS

Modified from L<Carp::Source::Always>.


=head1 SEE ALSO

L<Carp::Always>

L<Carp::Source> and L<Carp::Source::Always>

L<carpa>

L<Devel::Confess>

=cut
