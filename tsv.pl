#!/bin/perl
$lineno =0 ;
while (<>) {
	$lineno++ ;
	if ($_ =~ /^[ \t]*\r*$/ ){ 
		$lineno--;
	}
	else {
		@record0=@record;
		s/\r\n$//;
		s/\t/EF\t/g ;
		s/$/EF/ ;     # so empty fields at the end of a records will not be dropped by split function
		@record = split /\t/;
		for($i=0; $i <= $#record; $i++) {
			$record[$i] =~ s/,//g if ( $record[$i] =~ /^[0-9,.]*EF$/ );  # remove comma in numbers


			# fill header horizontally
			if ( $lineno == 1 && $i>0 && ( $record[$i] eq 'EF' ) ) {
				$record[$i] =  $record[$i-1] ; 
			}
		}
		if ($record[0] eq 'EF') { $record[0] = $record0[0]} # fill header verticly

		# fill empty cell
		if ($lineno == 1) 	{ @header_h0 = @record }
		elsif ($lineno == 3) 	{ @header_h1 = @record }
		elsif  ($lineno > 3) { 
			for ($c=2; $c<=$#record; $c++ ) {
				if ( $record[$c] =~ /^[0-9,.]+EF$/ ) { 
			
					$cell = join("\t", ($record[0], $record[1], $header_h0[$c], $header_h1[$c], $record[$c] ));
					$cell =~ s/EF\t/\t/g ;
					$cell =~ s/EF$//g ;
					print $cell, "\n" ;
				}
			}
		}

		
		#$record = join('|', ( @record) ) . "|" ;
		#$record =~ s/ \|/|/g;
		#print $record, "\n" ;
	}
}

