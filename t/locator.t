use lib './t/', './lib';
use Test;
use lib::testhelper;
use Sprockets;

my $locator = get-locator;
sub file-path($path, $ext) {
	$locator.find-file($path, $ext) andthen .realpath.subst('\\', '/', :g);
}

plan 6;

is-deeply split-filename('foo.bar.js.bat.baz'), ('foo.bar', 'js', ('baz', 'bat').Seq),
  "The extension is properly recognized and filters are in the correct order";

is file-path('a', 'js'), 't/data/themes/default/javascripts/a.js', "Can find a file in a 'shallow' structure";
is file-path('file.min', 'js'), 't/data/themes/_shared/javascripts/file.min.js', "Can find a file with dots in its name";
is file-path('multi', 'js'), 't/data/lib/javascripts/multi.js.pl.pl', "Can find a file with multiple extensions in its name";
is file-path('i', 'png'), 't/data/themes/_shared/images/i.png', "Finds the correct prefix";

is file-path('components/main', 'js'), 't/data/themes/default/javascripts/components/main.js', "Can find a file in directories";