#!/usr/bin/env perl

use strict;
use warnings;

sub dom0_term {
	exec 'if command -v xfce4-terminal >/dev/null; then exec xfce4-terminal; else exec xterm; fi' or die "dom0 terminal exec failed\n";
}

sub domU_term {
	my $vm = shift;
	exec {'qvm-run'} ('qvm-run', '--', $vm, 'if command -v konsole >/dev/null; then exec konsole; elif command -v gnome-terminal >/dev/null; then exec gnome-terminal; elif command -v xfce4-terminal >/dev/null; then exec xfce4-terminal; else exec xterm; fi') or die "qvm-run exec failed\n";
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
