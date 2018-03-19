#!/usr/bin/env perl

use strict;
use warnings;

sub dom0_term {
	exec die "dom0 close exec failed\n";
}

sub domU_term {
	my $vm = shift;
	exec ('qvm-shutdown', $vm,) or die "qvm-shutdown failed\n";
}

$_ = `xprop -notype -root _NET_ACTIVE_WINDOW`;
/^_NET_ACTIVE_WINDOW: window id # (?<id>0x[0-9a-f]+), 0x0$/m or die "unable to get active window\n";

$_ = `xprop -id "$+{id}" -notype _QUBES_VMNAME`;
if (/^_QUBES_VMNAME = \"(?<vm>[^\"]+)\"$/m) {
	length $+{vm} or die "empty string VM is invalid\n";
	domU_term $+{vm};
} else {
	dom0_term;
}
