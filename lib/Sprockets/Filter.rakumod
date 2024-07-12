unit module Sprockets::Filters;

sub temporary-filename(Str $prefix) {
  my @range =
  48..57, # num
  65..90, # ALPHA
  97..122 # alpha
  ;

  my $filename = @range.pick((8..16).pick)>>.chr.join;

  "{$prefix ?? "$prefix-" !! ""}$filename"
}

our %filters =
  'coffee' => sub (Str $content) { !!! },
  'pl' => sub (Str $content) { # EVAL-with-capture
    # output buffering... Sigh
    my $filename = temporary-filename('sprockets-filter-pl');
    my $*OUT = open $filename, :w;

    use MONKEY-SEE-NO-EVAL;
    EVAL $content;

    # read content, delete file, return content
    my $new-content = slurp $filename;
    unlink $filename;
    $new-content
  },
  ;

our sub apply-filters(@filters, $content is copy) is export {
  $content = %filters{$_}($content) for @filters;
  $content;
}
