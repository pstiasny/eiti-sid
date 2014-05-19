PLOTS=circles.eps hyperbolas_ew.eps hyperbolas_ns.eps
DIARIES=fvalopt.log fminopt.log
MATLAB=octave --eval 'graphics_toolkit("gnuplot")'

sprawozdanie.pdf: sprawozdanie.tex $(PLOTS) $(DIARIES)
	xelatex sprawozdanie.tex

$(PLOTS) $(DIARIES): projekt.m
	rm -f $(DIARIES)
	$(MATLAB) projekt.m

clean:
	rm -f sprawozdanie.pdf sprawozdanie.aux sprawozdanie.log $(PLOTS) $(DIARIES)
