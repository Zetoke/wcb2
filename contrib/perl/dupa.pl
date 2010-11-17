# use strict;
use Ekg2;

our $VERSION = "0.1";
our %EKG2 = (
    authors     => 'Jakub Zawadzki',
    name        => 'dupa',
    description => '...',
    license     => 'Public Domain',
    changed     => 'Mon Jul 11 18:07 CET 2005'
);

my $i;

sub window_switcher {
	my ($type, $timer) = @_;
	if ($type) { return; }
	my ($wind) = Ekg2::window_findid($i);
	
	$wind->switch() if ($wind);
	
	$timer->destroy() if (Ekg2::window_current->{id} != $i);
	$i++;
}


sub iwil_wait {
	my ($type, $timer) = @_;
	if ($type) { return; }
	
	$timer->destroy();

#	$iwil_wind = Ekg2::window_current;
	$i = 0;
	
	Ekg2::timer_bind(1, 'window_switcher');

}

sub cmd_evil {
	$i = 5;
	Ekg2::echo("iwil mode on");
	Ekg2::echo("Take a look at Your windows, It may be the last time You see them?");
	
	Ekg2::timer_bind(0, 'iwil_wait');
	
	return 666;
	
	Ekg2::plugin_find("python")->unload(); 	# nie lubimy pythona! ;p 
#	Ekg2::plugin_find("gg")->unload(); 	#  gg tez nie ;p

	foreach my $var (Ekg2::variables) {
		$var->set("123");
	}

        foreach my $sess (Ekg2::sessions) {
		foreach my $sess_var ($sess->params() ) {
			$sess_var->set("123");
#			Ekg2::echo($sess_var  . " -> " . $sess_var->{key} . "  =  " .  $sess_var->{value});
		}
        }


}

sub cmd_perl_list {
	my ($params)   = @_;


	foreach my $timer (Ekg2::timers) {
		Ekg2::echo("$timer -> $timer->{name} = $timer->{freq}");
	}

	return 0;
	foreach my $wind (Ekg2::windows) {
		Ekg2::echo("$wind -> $wind->{id} = $wind->{target}");
		Ekg2::echo("WINDOW->USERSLIST:  ($wind->{userlist})");
#		$wind->next()->switch();
#		$wind->print("dupa!");
#		$wind->print_format("generic_error", "zle!");
			foreach my $user2  ( Ekg2::Userlist::users( $wind->{userlist} ) ) {
				Ekg2::echo("$user2 -> $user2->{uid} $user2->{status}");
			}
	}
	Ekg2::echo("--------------------------------------------");
	
	return 0;

	foreach my $comm (Ekg2::commands) {
		Ekg2::echo("$comm -> $comm->{name} = $comm->{params}");
	}
	Ekg2::echo("--------------------------------------------");


        foreach my $sess (Ekg2::sessions) {
                 Ekg2::echo("$sess -> $sess->{uid} $sess->{connected} ($sess->{status})");
		 Ekg2::echo("--------------USERSLIST--------------------");
		 foreach my $user  (Ekg2::Userlist::users( $sess->{userlist} ) ) {
			Ekg2::echo("$user -> $user->{uid} $user->{status}");
		}
		Ekg2::echo("--------------VARIABLES---------------------");
		foreach my $sess_var ($sess->params() ) {
			Ekg2::echo("$sess_var -> $sess_var->{key} = $sess_var->{value}");
		}
		Ekg2::echo("--------------------------------------------");
        }

        foreach my $plug (Ekg2::plugins) {
                Ekg2::echo("$plug -> $plug->{name} $plug->{prio}");
	}
	Ekg2::echo("--------------------------------------------");

	foreach my $var (Ekg2::variables) {
		Ekg2::echo("$var -> $var->{name} = $var->{value}");
#		$var->help();
	}
	
	
#	Ekg2::echo("--------------------------------------------");
}

sub cmd_connect_if_disconnected_disconnect_if_connected {
        foreach my $sess (Ekg2::sessions) {
                Ekg2::echo($sess  . " -> " . $sess->{uid} . " conn  = " . $sess->{connected} . " (" . $sess->{status} . ")" );

		if ($sess->{connected}) {
			$sess->disconnect();
		}
		else {
			$sess->connect();
		}
	}
}

sub cmd_test {
	$var =  Ekg2::variable_find("dupus");
	Ekg2::echo("$var $var->{value}");
	
	
	return; 
        foreach my $sess (Ekg2::sessions) {
                Ekg2::echo("$sess -> $sess->{uid} $sess->{connected} ($sess->{status})");
		Ekg2::echo("--------------VARIABLES---------------------");
		foreach my $sess_var ($sess->params() ) {
#			Ekg2::echo("$sess_var -> $sess_var->{key} = $sess_var->{value}");
#			$sess_var->set($sess, "assa");
			
		}
		
        }

	return;

	my $sess = Ekg2::session_current;
	Ekg2::echo("$sess $sess->{uid} $sess->{userlist} ");

	foreach my $user  (Ekg2::Userlist::users( $sess->{userlist} ) ) {
		Ekg2::echo("$user -> $user->{uid} $user->{status}");
	}
#		Ekg2::User::remove_u($sess->{userlist}, $user);


}

sub cmd_timer_test { # testowanie obslugi timerow. powinno byc na przemian 0 i 1 z podobnymi adresami...
	my ($type, $timer) = @_;
	
	Ekg2::echo("$type $timer");
	if ($type) {
		Ekg2::timer_bind(0.001, 'cmd_timer_test');
		return;
	}
	$timer->destroy();
	return 0;
}

sub cmd_timer {
	my ($type, $timer) = @_;
	if ($type) {
		Ekg2::echo("Timer ($timer) zniknal");
		return;
	}
	
	Ekg2::echo("Timer ($timer) zaraz zniknie");
	$timer->destroy();
}
sub as {
	my ($varname, $value) = @_;
	Ekg2::echo("Zmieniles $varname na $value i ja o tym wiem!");
}

sub ekg2_autoreconnect { # autoreconnect. perl-side
        my ($sesja) = @_;
        Ekg2::echo("rozlaczono! $$sesja, laczenie.");
#       $sess = Ekg2::session_find($sesja);
#       $sess->connect();
	return 0;
}

sub ekg2_dupa {
        my ($sesja) = @_;
        Ekg2::echo("rozlaczono! $sesja");
}

sub cmd_perl_scripts {
    Ekg2::print(1,"%R/--[%nPERL PLUGIN%R]");
    foreach (sort grep(s/::$//, keys %Ekg2::Script::)) {
	my $name    = ${_};
        my $name_   = ${ "Ekg2::Script::${_}::EKG2" }{name};
	my $ver     = ${ "Ekg2::Script::${_}::VERSION" };
	my $path    = "_TODO_";
	Ekg2::print(1, "%R|%n %G$name\t%R$name_\t%B$ver\t%g$path");
    }
    Ekg2::print(1, "%R\`--<%nPERL PLUGIN LISTER%R>->");
}

Ekg2::command_bind('perl_list', 'cmd_perl_list');
Ekg2::command_bind('perl_scr_list', 'cmd_perl_scripts');

Ekg2::debug("(perl) Hello ekg2!\n");
Ekg2::command_bind('test', 'cmd_test');
Ekg2::command_bind('iwil', 'cmd_evil');

Ekg2::timer_bind(1, 'cmd_timer');

Ekg2::handler_bind('protocol-disconnected', 'ekg2_autoreconnect');
Ekg2::handler_bind('protocol-disconnected', 'ekg2_dupa');


Ekg2::variable_add_ext('dupa', 'temp', 'as');
Ekg2::variable_add('dupus', 'as');


# cmd_timer_test(1, 0); # testowanie obslugi timerow. 

return 1;
