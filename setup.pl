#!/usr/bin/env perl

use warnings;
use strict;
use File::Copy 'move';

# set environment
my $homedir         =   $ENV{'HOME'};
my $backupdir       =   "$homedir/dotbackup";
my $url_ohmyzsh     =   "git://github.com/robbyrussell/oh-my-zsh.git";
my $url_neobundle   =   "git://github.com/Shougo/neobundle.vim.git";
my $date            =   `date +%Y%m%d`;

# check command
sub chkcommand {
    my $path = `which $_[0]`;
    chomp($path);
    if (!-e $path) {
        print "you need a command : $_[0]", "\n";
        exit;
    }
}

# ckeck and backup
sub chkbackup {
	if (-e "$homedir/$_[0]") {
        move ("$homedir/$_[0]", "$backupdir/$_[0]");
    }
}

sub link {
    symlink ("$homedir/dotfiles/$_[0]", "$homedir/$_[0]");
}

# main function
&chkcommand ("git");

unless (-d $backupdir) {
    umask (0);
    mkdir ("$backupdir", 0755);
}

system ("rm -rf $backupdir/.*");

&chkbackup (".oh-my-zsh");
&chkbackup (".emacs");
&chkbackup (".emacs.d");
&chkbackup (".mew-theme.el");
&chkbackup (".conkyrc");
&chkbackup (".Xresources");
&chkbackup (".twmrc");
&chkbackup (".zshrc");
&chkbackup (".vimrc");
&chkbackup (".vim");
&chkbackup (".screenrc");
&chkbackup (".xinitrc");
&chkbackup (".gtkrc-2.0");
&chkbackup (".dir_colors");
&chkbackup (".tmux.conf");

system ("git clone $url_ohmyzsh ~/.oh-my-zsh");

&link (".oh-my-zsh/custom/custom-aliases.zsh");
&link (".oh-my-zsh/custom/custom-env.zsh");
&link (".emacs");
&link (".emacs.d");
&link (".mew-theme.el");
&link (".conkyrc");
&link (".Xresources");
&link (".twmrc");
&link (".zshrc");
&link (".vimrc");
&link (".vim");
&link (".screenrc");
&link (".xinitrc");
&link (".gtkrc-2.0");
&link (".dir_colors");
&link (".tmux.conf");

system ("git clone $url_neobundle $homedir/.vim/bundle/neobundle.vim");
