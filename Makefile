all: core/message-parsing.txt

%: %.pl
	perl $< > $@
