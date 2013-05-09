
\begin{wrapfigure}{r}{7cm}
\begin{tikzpicture}[every text node part/.style={align=center, circle}, node
distance=2.4cm, semithick]

    \tikzstyle{every node}=[ellipse,thick,draw=blue!75,fill=blue!5,minimum size=6mm]

    \node  (megatron) [fill=red!%(megatron)d] at (5, 5) {Conglomerate};
    \node  (Mathematics) [fill=blue!%(math)d,above left of=megatron] {Mathematics};
    \node  (Computations) [fill=blue!%(computation)d,above right of=megatron] {Computations};
    \node  (PatternMatching) [fill=blue!%(pattern)d,below left of=megatron] {Pattern\\Matching};
    \node  (GraphSearch) [fill=blue!%(search)d,below right of=megatron] {Algorithm\\Graph Search};

    \tikzstyle{megatron}=[fill=red,draw=none,text=white]

    \foreach \from/\to in
    {Mathematics/megatron, Computations/megatron, PatternMatching/megatron, GraphSearch/megatron}
    \draw (\from) -- (\to);

\end{tikzpicture}
\end{wrapfigure}
