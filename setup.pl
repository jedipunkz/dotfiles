#!/usr/bin/env perl

use warnings;
use strict;
use File::Copy 'move';

# set environment
my $homedir         =   $ENV{'HOME'};
my $backupdir       =   "$homedir/dotbackup";
my $url_ohmyzsh     =   "git://github.com/robbyrussell/oh-my-zsh.git";
my $url_neobundle   =   "git://github.com/Shougo/neobundle.vim.git";
my $url_rbenv       =   "git://github.com/sstephenson/rbenv.git";
my $url_ruby_build  =   "git://github.com/sstephenson/ruby-build.git";
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

unless (-d "$backupdir/gitwork") {
    umask (0);
    mkdir ("$backupdir/gitwork", 0755);
}

system ("rm -rf $backupdir/.*");

&chkbackup (".oh-my-zsh");
#&chkbackup (".emacs");
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
&chkbackup (".stumpwmrc");
&chkbackup ("gitwork/tmux-colors-solarized.git");
&chkbackup ("gitwork/tmux-powerline");
&chkbackup ("jedipunkz.zsh-theme");
&chkbackup ("jedipunkz2.zsh-theme");
&chkbackup ("jedipunkz3.zsh-theme");


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
&link (".stumpwmrc");
&link (".i3");

system ("pip install powerline-status");
system ("git clone $url_neobundle $homedir/.vim/bundle/neobundle.vim");
system ("mkdir ~/gitwork");
system ("git clone https://github.com/seebi/tmux-colors-solarized.git ~/gitwork/tmux-colors-solarized.git");
system ("git clone git://github.com/erikw/tmux-powerline.git ~/gitwork/tmux-powerline");
system ("ln -s ~/dotfiles/jedipunkz.zsh-theme ~/.oh-my-zsh/themes/jedipunkz.zsh-theme");
system ("ln -s ~/dotfiles/jedipunkz2.zsh-theme ~/.oh-my-zsh/themes/jedipunkz2.zsh-theme");
system ("ln -s ~/dotfiles/jedipunkz3.zsh-theme ~/.oh-my-zsh/themes/jedipunkz3.zsh-theme");

unless (-d "$homedir/.rbenv") {
    system ("git clone $url_rbenv $homedir/.rbenv");
    system ("git clone $url_ruby_build $homedir/.rbenv/plugins/ruby-build");
}
