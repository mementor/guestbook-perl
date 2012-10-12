#!/usr/bin/perl

use DBI;
use Mojolicious::Lite;


sub initDb {
	my $db = DBI->connect("dbi:SQLite:dbname=gb.db","","");
	$db->do("create table msgs (name TEXT, tex TEXT);");
	$db->disconnect;
};

get '/' => sub {
	my $self = shift;

	my $db = DBI->connect("dbi:SQLite:dbname=gb.db","","");
	my $all = $db->selectall_arrayref("SELECT * FROM msgs");
	$db->disconnect;

	$self->render(
		'index',
		messages => $all,
	);
};

post '/add' => sub {
	my $self = shift;
	
	my $name = $self->param('name');
	my $text = $self->param('text');

	my $db = DBI->connect("dbi:SQLite:dbname=gb.db","","");
	my $query = $db->do("INSERT INTO msgs VALUES('$name', '$text')");
	$db->disconnect;
	$query > 0 ? print "$text added\n" : print "$text not added\n";

	$self->redirect_to('/');
};

initDb();
app->start;	