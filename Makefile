all: core/parse-sexp.txt

%: %.pl
	perl $< > $@
