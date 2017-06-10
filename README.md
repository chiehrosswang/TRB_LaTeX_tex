# TRB_LaTeX_tex

A LaTeX template for Transportation Research Board Annual Meeting papers.

This is a lighter version of the former TRB LaTeX
[template](https://github.com/chiehrosswang/TRB_LaTeX_rnw). The previous
version was built primarily for people using R, Sweave, and LaTeX. A few people
requested a light version because they may not need/know how to use Sweave.
Therefore, this version is created for people just need a straight-forward
LaTeX template for TRB papers.

Some instruction and details about the project can be found inside the
``trb_template.tex``. The document uses external shell commands hence it needs
to be compiles with ``--shell-escape`` option. This is necessary for word count
feature which uses ``texcount`` program.
