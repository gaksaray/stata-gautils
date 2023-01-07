*! version 1.0  07feb2021  Gorkem Aksaray <aksarayg@tcd.ie>
*! Purge (reduce) Stata memory while preserving the dataset

program purge	
	preserve
	quietly query memory
	set segmentsize `r(segmentsize)'
	restore
end
