
\begin{tikzpicture}[every text node part/.style={align=center, circle}, node
distance=2.8cm, semithick]


    \node  (megatron) at (5, 5) {megatron};
    \node  (Mathematics) [above left of=megatron] {Mathematics};
    \node  (Computations) [above right of=megatron] {Computations};
    \node  (PatternMatching) [below left of=megatron] {Pattern\\Matching};
    \node  (GraphSearch) [below right of=megatron]       {Graph\\Search};

    \tikzstyle{megatron}=[fill=red,draw=none,text=white]

    \foreach \from/\to in
    {Mathematics/megatron, Computations/megatron, PatternMatching/megatron, GraphSearch/megatron}
    \draw (\from) -- (\to);

\end{tikzpicture}

