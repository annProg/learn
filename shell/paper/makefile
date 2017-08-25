pdf:
	cd markdown/ && make
	cd ../
	cd latex/ && make
	cd ../
doc:
	cd markdown/ && make doc
	cd ../
cl:
	cd latex/ && rm -f *.aux *.log *.bbl *.blg *.out
	cd latex/src/ && rm -f *
	cd ../../