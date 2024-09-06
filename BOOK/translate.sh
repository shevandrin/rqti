pwd
cp -r ../vignettes/* .
cp ../pkgdown/index.Rmd intro.Rmd
Rscript -e "bookdown::render_book()"
# remove badges
sed -i '/includesvg{https/d' _main.tex
sed -i 's/figure}/figure*}/' _main.tex
sed -i 's/vignettes\/images/images/' _main.tex
# sed -i 's/{Multiple Choice Exercises}/{Creating exercises, exams and \
#   questionnaires in R with rqti}/' _main.tex
sed -i 's/-\\textgreater{}/\\textrightarrow{}/g' _main.tex
sed -i 's/the article /Chapter /' _main.tex
sed -i 's/the articles/Chapters/' _main.tex
sed -i 's/article /Chapter /' _main.tex
sed -i 's/articles/Chapters/' _main.tex
sed -i 's/\\begin{verbatim}/\\begin{Shaded}\n\\begin{Highlighting}/' _main.tex
sed -i 's/\\end{verbatim}/\\end{Highlighting}\n\\end{Shaded}/' _main.tex
sed -i 's/\\subsection/\\noindent\\textbf/' _main.tex
# sed -i 's/\href{articles\//\hyperref[/' _main.tex
# sed -i 's/\hyperref*(.html})/]/' _main.tex
sed -i 's/\.svg}/\.pdf}/g' _main.tex
sed -i 's/includesvg/includegraphics/g' _main.tex

# sed -i 's/\\begin{Shaded}/\\vspace{2mm}\\noindent\\begin{adjustwidth}{2cm}{2cm}\\begin{Shaded}/' _main.tex
# sed -i 's/\\end{Shaded}/\\end{Shaded}\\end{adjustwidth}\\vspace{2mm}/' _main.tex
sed -i 's/\\textrightarrow{} Question/\\noindent\\textrightarrow{} Question/' _main.tex
sed -i 's/Alternatively, change the knit parameter/\\noindent Alternatively, change the knit parameter/' _main.tex
Rscript -e "tinytex::latexmk('_main.tex')"
