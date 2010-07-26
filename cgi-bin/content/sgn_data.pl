use strict;
use warnings;

use CXGN::Page;
use CXGN::Chado::Organism;
use CXGN::DB::DBICFactory;
our $c;

print "Content-type: text/html\n\n";

# Script to display the major data content of sgn
# Naama Menda, April 2010
#


my $page = CXGN::Page->new("SGN data overview page", "Naama");

my $schema = CXGN::DB::DBICFactory
    ->open_schema( 'Bio::Chado::Schema',
	search_path => ['public'],
);



my $type = 'web visible'; # we want only the leaf organisms with 'web visible' organismprop


my %sol;
my %rub;
my %planta;

my $organisms = $schema->resultset("Cv::Cvterm")
                       ->search({ name => 'web visible' })
                       ->search_related('organismprops')
                       ->search_related('organism');

while( my $organism = $organisms->next ) {
    my $organism_id = $organism->get_column('organism_id');
    my $root_tax = CXGN::Chado::Organism
                          ->new($schema, $organism_id)
                          ->get_organism_by_tax('family');
    if( $root_tax ) {
        my $species  = $organism->species;
        my $family   = $root_tax->species;
        $sol{$species}   = $organism_id if $family eq 'Solanaceae' ;
        $rub{$species}   = $organism_id if $family eq  'Rubiaceae' ;
        $planta{$species}= $organism_id if $family eq  'Plantaginaceae' ;
    }
}


##########

$c->forward_to_mason_view( "/content/sgn_data.mas",
    schema => $schema,
    sol    => \%sol,
    rub    => \%rub,
    planta => \%planta,
   );

	
