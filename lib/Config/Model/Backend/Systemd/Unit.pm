package Config::Model::Backend::Systemd::Unit ;

use strict;
use warnings;
use 5.010;
use Mouse ;
use Log::Log4perl qw(get_logger :levels);
use Path::Tiny;

extends 'Config::Model::Backend::IniFile';

sub read {
    my $self = shift ;
    my %args = @_ ;

    # args are:
    # root       => './my_test',  # fake root directory, used for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # io_handle  => $io           # IO::File object
    # check      => yes|no|skip

    if ($self->node->instance->layered) {
        # avoid deep recursion in layered mode
        return $self->SUPER::read(@_);
    };

    my $dir = path($args{root}.$args{config_dir});
    die "Unknown directory $dir" unless $dir->is_dir;

    my $app = $self->node->instance->application;
    my @layers ;
    if ($app eq 'systemd-user') {
        @layers = (
            # paths documented by systemd-system.conf man page
            '/etc/systemd/user.conf.d/',
            '/run/systemd/user.conf.d/',
            '/usr/lib/systemd/user.conf.d/',
            # path found on Debian
            '/usr/lib/systemd/user/'
        );
    }

    my @ccn = split '::', $self->node->config_class_name ;
    my $unit_type = lc pop @ccn;

    $self->node->instance->layered_start;
    # load layers
    foreach my $layer (@layers) {
        my $dir = path ($args{root}.$layer);
        next unless $dir->is_dir;

        foreach my $file ($dir->children(qr/\.$unit_type/) ) {
            my $unit_name = $file->basename(qr/\.$unit_type/);
            say "reading default layer from unit $unit_type name $unit_name from $file";
            my $fh = new IO::File;
            $fh->open($file);
            $fh->binmode(":utf8");

            my $res = $self->read(
                io_handle => $fh,
                check => $args{check},
            );
            $fh->close;
            die "failed $file read " unless $res;
        }
    }
    $self->node->instance->layered_stop;

    # mouse super() does not work...
    $self->SUPER::read(@_);
}



no Mouse ;
__PACKAGE__->meta->make_immutable ;
