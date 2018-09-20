--- 
title: "STAT 771: My notes"
author: "Ralph Møller Trane"
date: "Fall 2018 (compiled 2018-09-20)"
site: bookdown::bookdown_site
documentclass: book
link-citations: yes
description: "This is my collection of notes for the STAT 771 class taught at UW-Madison."
---

\newcommand{\R}{\mathbb{R}}
\newcommand{\N}{\mathbb{N}}

\newcommand{\norm}[1]{\left \vert \left \vert #1 \right \vert \right \vert}

\newcommand{\argmin}{\text{argmin}}
\newcommand{\argmax}{\text{argmax}}

# Intro {-}

<!--chapter:end:index.Rmd-->

# Lecture Notes

## Lecture 1: 9/6 {-}

Goals for the first few lectures:

1. Develop basic understanding of floating point numbers (*fp* numbers)
2. Develop some basic notions of errors and their consequences

References:

i. David Goldberg (1991)
ii. John D. Cook (2009)
iii. Hingham (2002)

## Positional numeral system

We assume we have a decimal representation of numbers. I.e. that it exists. It is not within the scope of this class to prove this. 

Now, this is NOT the optimal way for a computer to represent numbers. For various reasons, there are more desirable ways to store numbers. So we need a different way of representing the numbers. 

Ingredients for different representation:

i. A base, refered to as $\beta$. It holds that $\beta \in {2,3,4,...}$
ii. A significand: a sequence of digits: $d_0.d_1d_2d_3d_4...$, where $d_j \in \{0, 1,...,\beta-1\}$
iii. An exponent: $e \in \mathbb{Z}$.

The representation $d_0.d_1d_2... \times \beta^e$ means $\left(d_0 + d_1\cdot \beta^{-1} + ... + d_{p-1}\beta^{-(p-1)}\right)\cdot \beta^e$.

## Floating Point Format

\BeginKnitrBlock{definition}<div class="definition"><span class="definition" id="def:unnamed-chunk-1"><strong>(\#def:unnamed-chunk-1) </strong></span>A fp is one that can be represented in a base $\beta$ with a fixed digit $p$ (precision), and whose exponent is between $e_{min}$ and $e_{max}$. </div>\EndKnitrBlock{definition}


\BeginKnitrBlock{example}<div class="example"><span class="example" id="exm:unnamed-chunk-2"><strong>(\#exm:unnamed-chunk-2) </strong></span>Let $\beta = 10, p = 3, e_{min} = -1, e_{max} = 1$. Want to represent $0.1$. Several options:

i. Let d_0=0, d_1 = 0, d_2 = 1, e = 1.
ii. Let d_0=0, d_1 = 1, d_2 = 0, e = 0.
iii. d_0 = 1, d_1 = 0, d_2 = 0, e = -1. 

If we fill into the equation above, we get 0.1:

\begin{align*}
  i:  & \left(0 + 0\cdot 10^{-1} + 1\cdot 10^{-2}\right)\cdot 10^{1} \\
  ii: & \left(0 + 1\cdot 10^{-1} + 1\cdot 10^{-2}\right)\cdot 10^{0} \\
  iii:& \left(1 + 0\cdot 10^{-1} + 1\cdot 10^{-2}\right)\cdot 10^{-1}
\end{align*}</div>\EndKnitrBlock{example}


\BeginKnitrBlock{definition}<div class="definition"><span class="definition" id="def:unnamed-chunk-3"><strong>(\#def:unnamed-chunk-3) </strong></span>A fp number is said to be *normalized* if $d_0 \neq 0$. </div>\EndKnitrBlock{definition}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:unnamed-chunk-4"><strong>(\#exr:unnamed-chunk-4) </strong></span>What is the total number of values that can be represented in the normalized fp format with base $\beta, p, e_{min}, e_{max}$?

We count the different values each of the elements of a *fp* can take:

* $d_0$ can be from 1 to $\beta-1$, so $\beta-1$ different values.
* $d_1,...,d_{p-1}$ each takes a value in $\{0,1,...,\beta-1\}$. Hence, we can choose the digits $d_1,...,d_{p-1}$ in $\beta^{p-1}$ different ways. 
* $e$ can take $e_{max} - e_{min} + 1$ different values (all integers from $e_{min}$ to $e_{max}$, both included, hence the $+1$).

So, in total, there are $(\beta-1)\cdot \beta^{p-1}\cdot (e_{max} - e_{min} + 1)$ different values that can be represented in the normalized fp format with base $\beta$, precision $p$, and $e_{min}, e_{max}$ given. </div>\EndKnitrBlock{exercise}


## IEEE Standards

IEEE have standards for how to deal with approximations and errors.

For our purposes, a bit is a single unit of storage on a computer, which can either be 0 or 1. Hence, we'll be focusing on fp formats where $\beta = 2$. 

### The 16 bit standard (half precision standard).

The 16 bits of storage are used in the following way, when following the 16 bit standard:

* 1 bit for the sign
    * 0 = positive
    * 1 = negative
* 5 bits for the exponent 
    * 00000 is reserved for 0 
    * 11111 is reserved for $\infty$
    * 30 exponents left: $2^5 - 2 = 30$
    * the 16 bit standard dictates that the used exponents are $-14,...,15$. 
        * **Note**: $0$ is also included in this list of 30 exponents. This is because the $00000$ representation is reserved for integers, while $01111$ is used with non-integers. 
* 11 bit for the significand. 
    * 10 are actually stored -- we always work with normalized FP numbers, i.e. $\beta_0 = 1$. 



**Question:** What are smallest and largest positive numbers that can be represented? 

**Answer:** Smallest non-normalized number would be the one with the smallest possible exponent, and all digits of the significand are 0 except the very last one. So, the smallest non-normalized FP number in the 16 bit standard would be

$$
\left(0 + 0\cdot 2^{-1} + ... + 0\cdot 2^{-9} + 1\cdot 2^{-10}\right)\cdot 2^{-14} = 2^{-24} \approx 5.96\cdot 10^{-8}
$$

The smallest normalized number is the one with all digits $0$ (except for the leading digit, of course, which has to be $1$ for it to be normalized), and $e = -14$. So the smallest normalized FP number: 

$$
\left(1 + 0\cdot 2^{-1} + ... + 0\cdot 2^{-10}\right)\cdot 2^{-14} = 2^{-14} \approx 6.10\cdot 10^{-5}
$$
Finally, the largest (finite) FP number in the 16 bit standard is the one where the exponent is as large as possible ($e = 15$), and all digits are $1$. So

$$
\left(1 + 1\cdot 2^{-1} + ... + 1\cdot 2^{-10}\right)\cdot 2^{15} = 65504
$$



## Lecture 2: 9/11 {-}

### The 32 bit standard (single precision)

The 32 bits of storage are used in the following way, when following the 32 bit standard:

* 1 bit for the sign
    * 0 = positive
    * 1 = negative
* 8 bits for the exponent 
    * 00000000 is reserved for 0 
    * 11111111 is reserved for $\infty$
    * exponents left: $2^8 - 2 = 254$
    * the 32 bit standard dictates that the used exponents are $-126,...,127$. 
        * **Note**: $0$ is also included in this list of the 254 exponents. This is because the $00000000$ representation is reserved for integers, while $01111111$ (I think this is the representation for $0$ here...) is used with non-integers. 
* 24 bit for the significand. 
    * 23 are actually stored -- we always work with normalized FP numbers, i.e. $\beta_0 = 1$. 



**Question:** What are smallest and largest positive numbers that can be represented in the 32 bit standard? 

**Answer:** Smallest non-normalized number would be the one with the smallest possible exponent, and all digits of the significand are 0 except the very last one. So, the smallest non-normalized FP number in the 32 bit standard would be

$$
\left(0 + 0\cdot 2^{-1} + ... + 0\cdot 2^{-22} + 1\cdot 2^{-23}\right)\cdot 2^{-126} = 2^{-149} \approx 1.40\cdot 10^{-45}
$$

The smallest normalized number is the one with all digits $0$ (except for the leading digit, of course, which has to be $1$ for it to be normalized), and $e = -126$. So the smallest normalized FP number: 

$$
\left(1 + 0\cdot 2^{-1} + ... + 0\cdot 2^{-23}\right)\cdot 2^{-126} = 2^{-126} \approx 1.18\cdot 10^{-38}
$$
Finally, the largest (finite) FP number in the 32 bit standard is the one where the exponent is as large as possible ($e = 127$), and all digits are $1$. So

$$
\left(1 + 1\cdot 2^{-1} + ... + 1\cdot 2^{-126}\right)\cdot 2^{127} = 3.40\cdot 10^{38}
$$



### The 64 bit standard (double precision)

The 64 bits of storage are used in the following way, when following the 64 bit standard:

* 1 bit for the sign
    * 0 = positive
    * 1 = negative
* 11 bits for the exponent 
    * 00000000 is reserved for 0 
    * 11111111 is reserved for $\infty$
    * exponents left: $2^11 - 2 = 2046$
    * the 64 bit standard dictates that the used exponents are $-1024,...,1023$. 
        * **Note**: $0$ is also included in this list of the 254 exponents. This is because the $00000000$ representation is reserved for integers, while $01111111$ (I think this is the representation for $0$ here...) is used with non-integers. 
* 53 bit for the significand. 
    * 52 are actually stored -- we always work with normalized FP numbers, i.e. $\beta_0 = 1$. 

## Errors

### Units in the Last Place (ULP)

### Absolute and Relative Error

Let $fl: \mathbb{R}_{\geq 0} \rightarrow \mathcal{S}$ be a function that takes a real value and return a FP number. Then we define the absolute and relative error as follows:



\BeginKnitrBlock{definition}<div class="definition"><span class="definition" id="def:unnamed-chunk-5"><strong>(\#def:unnamed-chunk-5) </strong></span>Let $z \in \mathbb{R}_{\geq 0}$. The *absolute error* is defined as

$$
\left | fl(z) - z \right | .
$$

The *relative error* is defined as 

$$
\left | \frac{fl(z)-z}{z} \right |
$$</div>\EndKnitrBlock{definition}

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:lem1"><strong>(\#lem:lem1) </strong></span>If $z$ has exponent $e$, then the maximum absolute error is $\frac{\beta^{e-p+1}}{2}$.</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}</div>\EndKnitrBlock{proof}

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:unnamed-chunk-7"><strong>(\#lem:unnamed-chunk-7) </strong></span>If $z$ has exponent $e$, then the maximum relative error is $\frac{\beta^{1-p}}{2}$.</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}If $z$ has exponent $e$, then $\beta^{e}\leq z$. Using this with \@ref(lem:lem1), we get that 


$$
\left | \frac{fl(z)-z}{z} \right | \leq \frac{\beta^{e-p+1}}{2\beta^e} = \frac{\beta^{1-p}}{2}.
$$</div>\EndKnitrBlock{proof}


**Note:** the upper bound of the relative error is called the *machine epsilon*. This can be obtained in Julia using the function `eps`. 

#### The Fundamental Axiom

... is that for any of the four arithmetic operations ($+, -, \cdot, /$), we have the following error bound:

$$
fl(x \text{op} y) = (x \text{op} y)(1+\delta),
$$

with $|\delta| \leq u$, where $u$ is commonly $2\cdot \epsilon$. (**NOTE: NEED TO CLARIFY IF THE ABOVE IS CORRECT!**)



**Example:* Matrix storage. Let $A \in \mathbb{R}^{m\times n}$. Then:

$$
\left| fl(A) - A \right | \leq u \left | A \right |
$$



**Example:** Dot product. Let $x,y \in \mathbb{R}^{n}$. Recall that the dot product of $x$ and $y$ is definted as $x'y = \sum_{i=1}^{n} x_i \cdot y_i$. This can be calculated in the following way:


```julia
fl = function(x,y)
  # Get length of x
  n = length(x)
  # Check that length of y is equal to length of x. If not, throw error.
  if(length(y) != n)
    return "ERROR: y does not have same dimension as x"
  end
  
  # s will be the result of the dot product calculation
  s = 0
  
  for i = 1:n
    s += x[i]*y[i]
  end
  
  return(s)
  
end
```



Next we want to prove the following lemma:

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:unnamed-chunk-10"><strong>(\#lem:unnamed-chunk-10) </strong></span>Let $x,y \in \mathbb{R}^n$, and $n\cdot u \leq 0.01$. Then 

$$
\left | fl(x'y) - x'y \right | \leq 1.01 \cdot n\cdot u \cdot \left|x\right|'\left|y\right|
$$</div>\EndKnitrBlock{lemma}

## Lecture 3: 9/13 {-}

To prove the lemma above, we will need another lemma...

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:lemForProof"><strong>(\#lem:lemForProof) </strong></span>If $|\delta_i| \leq u, \forall i=1,\ldots,n$ s.t. $n\cdot u < 2$. Let $1 + \eta = \prod_{i=1}^{n}(1 + \delta_i)$. Then

$$ 
|\eta | \leq \frac{n\cdot u}{1-\tfrac{n\cdot u}{2}}
$$</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}Using the definition of $\nu$, we can rewrite it to get 

$$
| \eta | = \left | \prod_{i=1}^n (1 + \delta_i) - 1 \right |. 
$$

By induction, we will show that the expression above is less than or equal to $(1 + u)^n - 1$. [TO BE COMPLETED!]

Since $1+u \leq e^{u}$ for all $u \in \R$, we have that 

\begin{align*}
  | \eta | &\leq e^{n\cdot u} - 1 \\
          &\leq n\cdot u + \frac{(n\cdot u)^2}{2!} + \frac{(n\cdot u)^3}{3!} + \ldots \text{(used the Taylor expansion)}\\
          &\leq n\cdot u + \frac{(n\cdot u)^2}{2^1} + \frac{(n\cdot u)^3}{2^2} + \frac{(n\cdot u)^4}{2^3} + \ldots (\text{used that } x! > 2^{x-1} \text{ for } x > 1) \\
          &= \sum_{k=0}^{\infty} n\cdot u \left(\frac{n\cdot u}{2}\right)^k \text{\small (identify this as a geometric series with } r = \tfrac{n\cdot u}{2} \text{, \small which is less than 1 by assumption)} \\
          &= \frac{n\cdot u}{1-\tfrac{n\cdot u}{2}},
\end{align*}

which is exactly what we wanted.</div>\EndKnitrBlock{proof}



With this in hand, we will prove the previously stated lemma.

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}Let $s_p$ denote the value of $s$ after the $p$'th iteration of the algorithm described above. Then, since we're assuming the Fundamental Axiom, we have that $s_1 = fl(x_1y_y) = x_1 y_1 (1 + \delta_1)$, where $|\delta_1| \leq u$. We can similarly find $s_p$ as 

\begin{align*}
s_p &= fl(s_{p-1} + fl(x_p y_p)) \\
    &= (s_{p-1} + fl(x_p y_p))(1 + \epsilon_p) (\text{where } |\epsilon_p| \leq u) \\
    &= (s_{p-1} + x_py_p(1 + \delta_p))(1 + \epsilon_p) (\text{where } |\delta_p| \leq u).
\end{align*}

Let $\epsilon_1 = 0$. $s_p$ is a recursive formula, and can be rewritten as follows:

$$
s_p = \sum_{i=1}^p x_iy_i (1 + \delta_i)\prod_{j=1}^p (1 + \epsilon_j).
$$

So,

\begin{align*}
  | s_n - x^\prime y |  &= \left | \sum_{i=1}^n (x_i y_i)(1 + \delta_i)\prod_{j=1}^p (1 + \epsilon_j) - \sum_{i=1}^{n}x_iy_i\right | \\
                        &= \left | \sum_{i=1}^n (x_i y_i)\left((1 + \delta_i)\prod_{j=1}^p (1 + \epsilon_j) - 1 \right) \right | \\
                        &\leq \sum_{i=1}^n \left |x_i y_i \right |\left | (1 + \delta_i)\prod_{j=1}^p (1 + \epsilon_j) - 1 \right| .
\end{align*}

We now use \@ref(lem:lemForProof) to get:

\begin{align*}
\sum_{i=1}^n \left |x_i y_i \right |\left | (1 + \delta_i)\prod_{j=1}^p (1 + \epsilon_j) - 1 \right| &\leq  \frac{nu}{1-\tfrac{nu}{2}} \sum_{i=1}^n \left |x_i y_i \right | \\
&\leq \frac{nu}{0.995} \sum_{i=1}^n |x_i| |y_i | \\
&\leq 1.01 \cdot nu \cdot |x|^\prime |y|
\end{align*}
</div>\EndKnitrBlock{proof}

## Square Linear Systems

In the following, let $A \in \R^{n \times m}$ be an invertible matrix, and assume $Ax = b$ for a $b \neq 0$. This implies that $x = A^{-1}b$.

\BeginKnitrBlock{theorem}<div class="theorem"><span class="theorem" id="thm:unnamed-chunk-13"><strong>(\#thm:unnamed-chunk-13) </strong></span>Let $\kappa_\infty = \norm{A}_\infty \norm{A^{-1}}_\infty$. Assume we can store $A$ with precision $E$ (i.e. as $A+E$), where $\norm{E}_\infty \leq u \norm{A}_\infty$, and $b$ with precision $e$ (i.e. as $b+e$), where $\norm{e}_\infty \leq u \norm{b}_\infty$. 

If $\norm{A+E}\hat{x} = b+e$ and $u\cdot \kappa_\infty < 1$, then 

$$
  \frac{\norm{x-\hat{x}}_\infty}{\norm{x}} \leq \frac{2\cdot u \cdot \kappa_\infty}{1-u\cdot \kappa_\infty}
$$</div>\EndKnitrBlock{theorem}

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:proofHW"><strong>(\#lem:proofHW) </strong></span>Let $I\in \R^{n \times n}$ be the identity matrix, and $F \in \R^{n\times n}$ s.t. $\norm{F}_p < 1$ for some $p \in [1,\infty]$. Then $I-F$ is invertible, and 

$$
  \norm{(I-F)^{-1}}_p \leq \frac{1}{1-\norm{F}_p}
$$</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}**HOMEWORK**</div>\EndKnitrBlock{proof}


\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:unnamed-chunk-15"><strong>(\#lem:unnamed-chunk-15) </strong></span>Suppose $\exists \epsilon > 0$ s.t. $\norm{\Delta A} \leq \epsilon \norm{A}$ and $\norm{\Delta b} \leq \epsilon \norm{b}$, and $y$ s.t. $(A+\Delta A)y = b+\Delta b$. 

If $\epsilon \norm{A}\norm{A^{-1}} = r < 1$, then $A+\Delta A$ is invertible and $$\frac{\norm{y}}{\norm{x}} \leq \frac{1+r}{1-r}.$$</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}Note that $A+\Delta A = A\left (I + A^{-1}\Delta A\right ) = A\left (I - \left(- A^{-1}\Delta A\right)\right)$. Since $\norm{-A^{-1}\Delta A} = \norm{A^{-1}\Delta A} \leq \epsilon \norm{A^{-1}}\cdot \norm{A} < 1$ (by assumptions), Lemma \@ref(lem:proofHW) gives us that $I + A^{-1}\Delta A$ is invertible. Since $A$ is also invertible (again, by assumption), $A+\Delta A$ is invertible (product of two invertible matrices is invertible). 

Performing some linear algebra:

\begin{align*}
  (A + \Delta A) &=  b + \Delta b \Leftrightarrow \\
  A(I + A^{-1} \Delta A) y &= b + \Delta b \Leftrightarrow \\
  (I + A^{-1} \Delta A) y &= A^{-1}b + A^{-1}\Delta b \Leftrightarrow \\
  y &= (I + A^{-1} \Delta A)^{-1} A^{-1}b + A^{-1}\Delta b.
\end{align*}
  
Remember that $A^{-1}b = x$. From the definition of $r$ we have that $\norm{A^{-1}} = \frac{r}{\norm{A}}$. These two identities with the assumption that $\norm{\Delta b} \leq \epsilon b$ gives us 

$$
\begin{aligned}
  \norm{y} &\leq \norm{(I + A^{-1}\Delta A)^{-1}} \left( \norm{x} + \norm{A^{-1}\Delta b}\right) \\
  &\leq \frac{1}{1-\norm{A^{-1}\Delta A}} \left( \norm{x} + \frac{r}{\epsilon \norm{A}} \cdot \norm{\Delta b} \right) \\
  &\leq \frac{1}{1-r} \left( \norm{x} + \frac{r}{\epsilon \norm{A}} \cdot \epsilon \norm{b} \right) \\
  &= \frac{1}{1-r} \left( \norm{x} + \frac{r \cdot \norm{b}}{\norm{A}} \right).
\end{aligned}
$$
  
Finally, recall that $Ax=b$, hence $\norm{A}\cdot\norm{x} \geq \norm{b}$, so $\norm{x} \geq \frac{\norm{b}}{\norm{A}}$. So,
  
$$
\begin{aligned}
  \norm{y} \leq \frac{1}{1-r}  \left( \norm{x} + r \cdot \norm{x} \right) \Leftrightarrow \\
  \frac{\norm{y}}{\norm{x}} \leq \frac{1+r}{1-r}.
\end{aligned}
$$
</div>\EndKnitrBlock{proof}

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:unnamed-chunk-17"><strong>(\#lem:unnamed-chunk-17) </strong></span>$$\frac{\norm{y - x}}{\norm{x}} \leq \frac{2\epsilon \norm{A^{-1}}\cdot \norm{A}}{1-r}.$$</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}
$$
\begin{aligned}
  \left(A+\Delta A\right)y &= b + \Delta b \Leftrightarrow \\
  Ay - b &= \Delta b - \Delta Ay \Leftrightarrow \\
  y - A^{-1}b &= A^{-1} \Delta b - A^{-1}\Delta A y \Leftrightarrow \\
  y - x &= A^{-1} \Delta b - A^{-1}\Delta A y \Leftrightarrow \\
  \norm{y - x} &\leq \norm{A^{-1}} \norm{\Delta b} + \norm{A^{-1}} \norm{\Delta A}\norm{y} \\ %\Leftrightarrow \\
  &\leq \norm{A^{-1}} \epsilon \norm{b} + \norm{A^{-1}} \epsilon\norm{A}\norm{y} \\ %\Leftrightarrow \\
  &\leq \epsilon \norm{A^{-1}} \norm{A}\norm{x} + \epsilon\norm{A^{-1}}\norm{A}\norm{y} \\ % \Leftrightarrow \\
  &\leq \epsilon \norm{A^{-1}} \norm{A}\left(\norm{x} + \norm{y}\right) \\
  &= \epsilon \norm{A^{-1}} \norm{A}\left(\norm{x} + \frac{1+r}{1-r}\norm{x}\right) \Leftrightarrow \\
\frac{\norm{y-x}}{\norm{x}} &\leq \epsilon \norm{A^{-1}} \norm{A} \left(\frac{1-r}{1-r} + \frac{1+r}{1-r}\right) \\
  &= 2\epsilon \norm{A^{-1}} \norm{A} \frac{1}{1-r}
\end{aligned}
$$
</div>\EndKnitrBlock{proof}

## Orthogonalization

Goals

1) Introduce and prove the existence of QR decomposition
2) Overview of the algorithm to perfor QR decomposition
3) Solve least squares problems
4) "Large" data problems

Outline

1) Motivating problems and solutions with QR
2) Gram-Schmidt procedure, existence of QR
3) Householder, Givens
4) "Large" least squares problems datadown

### Motivating problems

\BeginKnitrBlock{example}\iffalse{-91-77-111-116-105-118-97-116-105-110-103-32-80-114-111-98-108-101-109-32-49-32-40-67-111-110-115-105-115-116-101-110-116-32-76-105-110-101-97-114-32-83-121-115-116-101-109-41-93-}\fi{}<div class="example"><span class="example" id="exm:linear-system"><strong>(\#exm:linear-system)  \iffalse (Motivating Problem 1 (Consistent Linear System)) \fi{} </strong></span>Assume $A \in \R^{n\times m}, n \geq m, \text{rank}(A) = m$, and $b \in \text{range}(A) \subset R^m$. Find $x \in \R^m$ s.t. $Ax = b$.</div>\EndKnitrBlock{example}


\BeginKnitrBlock{example}\iffalse{-91-77-111-116-105-118-97-116-105-110-103-32-80-114-111-98-108-101-109-32-50-32-40-76-101-97-115-116-32-83-113-117-97-114-101-115-32-82-101-103-114-101-115-115-105-111-110-41-93-}\fi{}<div class="example"><span class="example" id="exm:least-squares"><strong>(\#exm:least-squares)  \iffalse (Motivating Problem 2 (Least Squares Regression)) \fi{} </strong></span>Assume $A \in \R^{n\times m}, n \geq m, \text{rank}(A) = m$, and $b \in R^n$. Find $x \in \R^m$ s.t. $$x \in \argmin_{y \in \R^m} \norm{Ay-b}_2.$$</div>\EndKnitrBlock{example}


\BeginKnitrBlock{example}\iffalse{-91-77-111-116-105-118-97-116-105-110-103-32-80-114-111-98-108-101-109-32-51-32-40-85-110-100-101-114-100-101-116-101-114-109-105-110-101-100-32-76-105-110-101-97-114-32-83-121-115-116-101-109-93-}\fi{}<div class="example"><span class="example" id="exm:und-linear-system"><strong>(\#exm:und-linear-system)  \iffalse (Motivating Problem 3 (Underdetermined Linear System) \fi{} </strong></span>Assume $A \in \R^{n\times m}, n \geq m, \text{rank}(A) < m$, and $b \in \text{range}(A)$. Find $x \in \R^m$ s.t. 

$$x \in \argmin_{y \in \R^m} \left\{ \norm{y}_2 \left | Ay = b \right\} \right . .$$</div>\EndKnitrBlock{example}

\BeginKnitrBlock{example}\iffalse{-91-77-111-116-105-118-97-116-105-110-103-32-80-114-111-98-108-101-109-32-52-32-40-85-110-100-101-114-100-101-116-101-114-109-105-110-101-100-32-76-101-97-115-116-32-83-113-117-97-114-101-115-32-82-101-103-114-101-115-115-105-111-110-41-93-}\fi{}<div class="example"><span class="example" id="exm:und-least-squares"><strong>(\#exm:und-least-squares)  \iffalse (Motivating Problem 4 (Underdetermined Least Squares Regression)) \fi{} </strong></span>Assume $A \in \R^{n\times m}, n \geq m, \text{rank}(A) < m$, and $b \in \R^n$. Find $x \in \R^m$ s.t. 

$$x \in \argmin_{z \in \R^m} \left\{ \norm{z}_2 \left | \norm{Ay - b}_2 = \min_{y \in \R^m} \norm{Ay-b}_2 \right\} \right . .$$</div>\EndKnitrBlock{example}

\BeginKnitrBlock{example}\iffalse{-91-77-111-116-105-118-97-116-105-110-103-32-80-114-111-98-108-101-109-32-53-32-40-67-111-110-115-116-114-97-105-110-101-100-32-76-101-97-115-116-32-83-113-117-97-114-101-115-32-82-101-103-114-101-115-115-105-111-110-41-93-}\fi{}<div class="example"><span class="example" id="exm:constrained-least-squares"><strong>(\#exm:constrained-least-squares)  \iffalse (Motivating Problem 5 (Constrained Least Squares Regression)) \fi{} </strong></span>Assume $A \in \R^{n\times m}, n \geq m, \text{rank}(A) < m$, and $b \in \R^n$. Let $C \in \R^{p\times m}, \text{C} = p$, and $d \in \R^{p}$. Find $x \in \R^m$ s.t. 

$$x = \argmin_{y \in \R^m} \norm{Ay - b}_2\quad \text{s.t.} \quad Cy = d.$$</div>\EndKnitrBlock{example}

Before we take a crack at solving these problems, we will need to get some definitions down.

\BeginKnitrBlock{definition}\iffalse{-91-80-101-114-109-117-116-97-116-105-111-110-32-77-97-116-114-105-120-93-}\fi{}<div class="definition"><span class="definition" id="def:perm-matrix"><strong>(\#def:perm-matrix)  \iffalse (Permutation Matrix) \fi{} </strong></span>A permutation matrix is a square matrix such that each column has exactly one element that is $1$, the rest are $0$. </div>\EndKnitrBlock{definition}

\BeginKnitrBlock{example}<div class="example"><span class="example" id="exm:unnamed-chunk-19"><strong>(\#exm:unnamed-chunk-19) </strong></span>The following is a permutation matrix:
  
$$
  \begin{bmatrix}
    0 & 1 \\
    1 & 0
  \end{bmatrix}
$$
      </div>\EndKnitrBlock{example}

\BeginKnitrBlock{definition}\iffalse{-91-79-114-116-104-111-103-111-110-97-108-32-77-97-116-114-105-120-93-}\fi{}<div class="definition"><span class="definition" id="def:unnamed-chunk-20"><strong>(\#def:unnamed-chunk-20)  \iffalse (Orthogonal Matrix) \fi{} </strong></span>A matrix $Q$ is said to be an *orthogonal matrix* if $Q^T Q = Q Q^T = I$.</div>\EndKnitrBlock{definition}

Note: for an orthogonal matrix $Q \in \R^{n\times m}$, it holds that $\norm{Q_{i*}}_2 = 1$ for all $i=1,\ldots,n$, and $\norm{Q_{*j}}_2 = 1$ for all $j = 1,\ldots, m$.^[Here we use the notion $Q_{i*}$ to mean the $i$'th row, and $Q_{*j}$ to mean the $j$'th column of $Q$.]

\BeginKnitrBlock{definition}\iffalse{-91-85-112-112-101-114-32-84-114-105-97-110-103-117-108-97-114-32-77-97-116-114-105-120-93-}\fi{}<div class="definition"><span class="definition" id="def:unnamed-chunk-21"><strong>(\#def:unnamed-chunk-21)  \iffalse (Upper Triangular Matrix) \fi{} </strong></span>A matrix $R$ is an *upper triangular matrix* if $R_{ij} = 0$ for all $i>j$. </div>\EndKnitrBlock{definition}

## Lecture 4: 9/18 {-}

### QR Decomposition

In order to actually solve the problems listed above, we need the QR Decomposition:

\BeginKnitrBlock{theorem}\iffalse{-91-69-120-105-115-116-101-110-99-101-32-111-102-32-81-82-32-68-101-99-111-109-112-111-115-105-116-105-111-110-93-}\fi{}<div class="theorem"><span class="theorem" id="thm:qr-decomposition"><strong>(\#thm:qr-decomposition)  \iffalse (Existence of QR Decomposition) \fi{} </strong></span>Let $A \in \R^{n \times m}$ and let $r = rank(A)$. Then there exists:
  
1) an $m\times m$ permutation matrix $\Pi$,
2) an $n \times n$ orthogonal matrix $Q$,
3) an $r \times r$ upper triangular matrix $R$, with non-zero diagonal elements (i.e. invertible)
4) an $r \times (m-r)$ matrix S (if $m > r$),

such that 

$$
  A = Q \begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix} \Pi^T.
$$  
    </div>\EndKnitrBlock{theorem}




With this in hand, we can solve the motivating problems stated above.

\BeginKnitrBlock{solution}\iffalse{-91-69-120-97-109-112-108-101-32-92-64-114-101-102-40-101-120-109-58-108-105-110-101-97-114-45-115-121-115-116-101-109-41-93-}\fi{}<div class="solution">\iffalse{} <span class="solution"><em>Solution</em> (Example \@ref(exm:linear-system)). </span>  \fi{}
We want to find $x$ such that $Ax = b$. 

We use theorem \@ref(thm:qr-decomposition) to rewrite this as $Q \begin{bmatrix} R \\ 0 \end{bmatrix} \Pi^T x = b$. Note that since $\text{rank}(A) = m$, there is no $S$ matrix. 

Now, since $Q$ is an orthogonal matrix, we know that $Q^{-1} = Q^T$, so 

\begin{equation}
  \begin{bmatrix} R \\ 0 \end{bmatrix} \Pi^T x = Q^T b = c = \begin{bmatrix} c_1 \\ 0 \end{bmatrix}. (\#eq:sol-linear-system)
\end{equation}

So now the equation we are trying to solve becomes 

$$
  R \Pi^T x = c_1.
$$
  
Since $R$ is an upper triangular matrix with non-zero diagonal elements, it is invertible. Since $\Pi$ is a permutation matrix, $\Pi^{-1} = \Pi^T$. Using this we can find the solution:
  
$$
  x = \Pi R^{-1} c_1.
$$
</div>\EndKnitrBlock{solution}


\BeginKnitrBlock{solution}\iffalse{-91-69-120-97-109-112-108-101-32-92-114-101-102-64-40-101-120-109-58-108-101-97-115-116-45-115-113-117-97-114-101-115-93-}\fi{}<div class="solution">\iffalse{} <span class="solution"><em>Solution</em> (Example \ref@(exm:least-squares). </span>  \fi{}We want to find $x$ such that $x \in \argmin_{y \in \R^m}\norm{Ay-b}_2$. 

Once again, $\text{rank}(A) = m$, so using theorem \@ref(thm:qr-decomposition), we can rewrite the expression we are trying to minimize as

$$
  \min \norm{Q \begin{bmatrix} R \\ 0 \end{bmatrix}\Pi^T y - b}_2. (\#eq:least-squares-eq1)
$$
  
Since $Q^T = Q^{-1}$ is orthogonal, $\norm{Q^T x}_2 = \norm{x}_2$ for all $x$ (homework exercise \@ref(exr:q402)). So, we get that \@ref(eq:least-squares-eq1) is the same as 

$$
  \min\norm{\begin{bmatrix} R \\ 0 \end{bmatrix} \Pi^T y - Q^T b}_2.
$$
  
Now let $c = Q^T b$. Then, $c$ is of the form $\begin{bmatrix} c_1 \\ c_2 \end{bmatrix}$, where $c_2$ is the last $n-r$ rows (i.e. corresponding to the $0$ rows of $\begin{bmatrix} R \\ 0 \end{bmatrix}$). Then

$$
  \min\norm{\begin{bmatrix} R \Pi^T y - c_1 \\ -c_2 \end{bmatrix}}_2 = \min \sqrt{\norm{R \Pi^T y - c_1}_2^2 + \norm{c_2}_2^2}.
$$
  
Now this is minimized by $\argmin_y \norm{R \Pi^T y - c_1}_2^2$. As before, $R^{-1}$ exists since $R$ is upper triangular with non-zero diagonal elements, $\Pi^T = \Pi^{-1}$ since $\Pi$ is a permutation matrix, so 

$$
  \begin{aligned}
    x &= \argmin_y \norm{R \Pi^T y - c_1}_2^2 \Leftrightarrow \\
    R \Pi^T x &= c_1 \Leftrightarrow \\
    x &= \Pi R^{-1} c_1.
  \end{aligned}
$$
  </div>\EndKnitrBlock{solution}

\BeginKnitrBlock{solution}\iffalse{-91-69-120-97-109-112-108-101-32-92-64-114-101-102-40-101-120-109-58-117-110-100-45-108-105-110-101-97-114-45-115-121-115-116-101-109-41-93-}\fi{}<div class="solution">\iffalse{} <span class="solution"><em>Solution</em> (Example \@ref(exm:und-linear-system)). </span>  \fi{}
In this scenario, $\text{rank}(A) = r < m$. We are looking for $x \in \argmin_{y}\left\{\norm{y}_2 \left | Ay = b\right\}\right .$. Using theorem \@ref(thm:qr-decomposition), we can rewrite this as $\argmin_y\left\{\norm{y}_2 | Q\begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix} y = b \right\}$, and multiplying by $Q^T$, $\argmin_y\left\{\norm{y}_2 \left | \begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix} y = Q^T b \right\} \right .$. We introduce the vector $c$ such that $Q^T b = \begin{bmatrix} c & 0 \end{bmatrix}^T$ ($0$ entries correspond to $0$ rows in $\begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix}$). If we furthermore write $\Pi^T y$ as $\begin{bmatrix} z_1 & z_2 \end{bmatrix}^T$. 

Then, since $\norm{y}_2 = \norm{z}_2$, our problem becomes 

$$
  \begin{aligned}
    x &\in \argmin_z \left\{\norm{z}_2 \left | R z_1 + S z_2 = c \right\}\right. \\
    x &\in \argmin_z \left\{\norm{z}_2 \left | z_1 = R^{-1} c - R^{-1} S z_2 \right\}\right. \\
    x &\in \argmin_z \sqrt{\norm{R^{-1}c - R^{-1} S z_2}_2^2 + \norm{z_2}_2^2} \\
    x &\in \argmin_z \left\{\norm{R^{-1}c - R^{-1} S z_2}_2^2 + \norm{z_2}_2^2\right\},
  \end{aligned}
$$  

where the last equality is a consequence of the result proved in homework \@ref{exr:q403}. Now, let $d = R^{-1}c$ and $p = R^{-1}Sz_2$. Then we can find the minimum of the above expression by differentiating and setting equal to zero:
      

\begin{align}
  0 &= -P^Td + (P^TP + I)z_2 \rightarrow
  z_2 &= (P^T P + I)^{-1}P^Td.
\end{align}
</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{solution}\iffalse{-91-69-120-97-109-112-108-101-32-92-64-114-101-102-40-101-120-109-58-117-110-100-45-108-101-97-115-116-45-115-113-117-97-114-101-115-41-93-}\fi{}<div class="solution">\iffalse{} <span class="solution"><em>Solution</em> (Example \@ref(exm:und-least-squares)). </span>  \fi{}
We want to find $\min_z \left\{ \norm{z}_2 \left \vert z \in \argmin_y \norm{Ay - b}_2\right\} \right .$ Use theorem \@ref(thm:qr-decomposition):
  
$$\begin{aligned}
  \min_z \left\{ \norm{z}_2 \left \vert z \in \argmin_y \norm{Ay - b}_2\right\} \right . &= \left\{ \norm{z}_2 \left \vert z \in \argmin_y \norm{\begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix} \Pi^T y - Q^T b}_2\right\} \right . \\
  &= \left\{ \norm{w}_2 \left \vert w \in \argmin_y \norm{\begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix}  y - Q^T b}_2\right\} \right .,
\end{aligned}$$
  
since $\norm{y}_2 = \norm{\Pi^T y}_2$. This is exactly the problem solved in example \@ref(exm:und-linear-system). In conclusion,

$$
  w = \begin{bmatrix} R^{-1}(c_1 - Sy_y) \\ y_2 \end{bmatrix}.
$$
</div>\EndKnitrBlock{solution}


\BeginKnitrBlock{solution}\iffalse{-91-69-120-97-109-112-108-101-32-92-64-114-101-102-40-101-120-109-58-99-111-110-115-116-114-97-105-110-101-100-45-108-101-97-115-116-45-115-113-117-97-114-101-115-93-}\fi{}<div class="solution">\iffalse{} <span class="solution"><em>Solution</em> (Example \@ref(exm:constrained-least-squares). </span>  \fi{}</div>\EndKnitrBlock{solution}


### Existence of QR-decomposition.

To prove the existence of the QR-decomposition, we need the Gram-Schmidt process.

\BeginKnitrBlock{lemma}\iffalse{-91-84-104-101-32-71-114-97-109-45-83-99-104-109-105-100-116-32-80-114-111-99-101-115-115-93-}\fi{}<div class="lemma"><span class="lemma" id="lem:gsp"><strong>(\#lem:gsp)  \iffalse (The Gram-Schmidt Process) \fi{} </strong></span>Let $r \in \N$. Given a set of linearly independent vectors $\{a_1, \ldots, a_r\}$, there exists a set of orthonormal vectors $\{q_1, \ldots, q_r\}$ such that $\text{span} \{q_1, \ldots, q_r\} = \text{span}\{a_1, \ldots, a_r\}$. 

The $q_i$'s are given by...
</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}We will prove this by induction. For $i=1$: let $R_{11} = \norm{a_1}_2$, $q_1 = \frac{1}{R_11}a_1$. Notice that $\norm{q_1} = 1$. 

(At this point, it might be beneficial to check out the intuitive side note (\@ref(cnj:gram-schmidt-remark)))

Define $q^r$ in the following way: let $R_{ir} = q_i^\prime a_r$, $\tilde{q}_r = a_r - \sum_{i=1}^{r-1} R_{ir}q_i$, and $R_rr = \norm{\tilde{q}_r}_2$. Then $q_r = \frac{\tilde{q}_r}{R_{rr}}$. (Note: $\tilde{q}_r \neq 0$ since the $a_i$s are linearly independent, and $q_i$ is given as a linear combination of $a_1, \ldots, a_i$.)

Assume the result holds for $i \le r-1$. I.e. we have vectors $q_1, \ldots, q_{r-1}$ given as above, and that

i) $\text{span}\{q_1, \ldots, q_{r-1}\} = \text{span}\{a_1, \ldots, a_{r-1}\}$,
ii) $q_i \cdot q_j$ for all $i,j = 1, \ldots, r-1$ with $i \neq j$,
iii) $q_i^\prime \cdot q_i = 1$ for all $i = 1, \ldots, r-1$. 

Now, we want to show that we can construct a $q_r$ such that

a) $\text{span}\{q_1, \ldots, q_r\} = \text{span}\{a_1, \ldots, a_r\}$,
b) $q_r \cdot q_j = 0$ for all $j = 1, \ldots, r-1$,
c) $q_r^\prime \cdot q_r = 1$.

We start from below.

c) By definition of $q_r$: $q_r^\prime q_r = \frac{\tilde{q}_r^\prime \tilde{q}_r}{R_{rr}^2} = \frac{\norm{\tilde{q}_r}^2}{R_{rr}^2} = 1$. 
b) Let $i < r$. Then 

$$\begin{aligned}
  q_i^{\prime} \tilde{q}_r &= q_i^\prime a_r - \sum_{j=1}^{r-1} R_{jr} q_i^\prime q_j \\
                           &= q_i^\prime a_r - R_{ir} q_i^\prime q_i \\
                           &= q_i^\prime a_r - R_{ir} = 0 \text{ (by definition of } R_{ir}\text{)}.
\end{aligned}$$

a) We need to show that $a_r$ can be written as a linear combination of $q_i$s. 

$$\begin{aligned}
  \sum_{i=1}^r R_{ir} q_i &= \sum_{i=1}^{r-1} R_{ir} q_i + R_{rr} q_r \\
                          &= \sum_{i=1}^{r-1} R_{ir} q_i + R_{rr} \frac{1}{R_{rr}} \tilde{q}_r \\
                          &= \sum_{i=1}^{r-1} R_{ir} q_i + R_{rr} \frac{1}{R_{rr}} \left(a_r - \sum_{i=1}^{r-1} R_{ir}q_i \right) \\
                          &= \sum_{i=1}^{r-1} R_{ir} q_i + a_r - \sum_{i=1}^{r-1} R_{ir}q_i \\
                          &= a_r.
\end{aligned}$$
                            </div>\EndKnitrBlock{proof}

\BeginKnitrBlock{conjecture}\iffalse{-91-73-110-116-117-105-116-105-118-101-32-115-105-100-101-32-110-111-116-101-93-}\fi{}<div class="conjecture"><span class="conjecture" id="cnj:gram-schmidt-remark"><strong>(\#cnj:gram-schmidt-remark)  \iffalse (Intuitive side note) \fi{} </strong></span>It is fairly easy to find $q_2$. We want to find it such that $a_2 = R_{12}q_1 + R_{22} q_2$, and $\norm{q_2}_2 = 1$ and $q_1 \perp q_2$, i.e. $q_1 \cdot q_2 = 0$. So, if we multiply the equation by $q_1$, we get that $q_1 a_2 = R_{12}$. Substituting this into the first equation, $q_2 = \frac{a_2 - R_{12} q_1}{R_{22}}$. 

Note that this is a circular argument, and hence not a formal way of doing this.</div>\EndKnitrBlock{conjecture}

## Lecture 5: 9/20 {-}

(Finished up proof of The Gram-Schmidt Process (\@ref(lem:gsp)))


\BeginKnitrBlock{conjecture}\iffalse{-91-71-114-97-109-45-83-99-104-109-105-100-116-32-105-110-32-77-97-116-114-105-120-32-70-111-114-109-93-}\fi{}<div class="conjecture"><span class="conjecture" id="cnj:unnamed-chunk-28"><strong>(\#cnj:unnamed-chunk-28)  \iffalse (Gram-Schmidt in Matrix Form) \fi{} </strong></span>If we write up $a_1, \ldots, a_r$ in a matrix, we see that 

$$
  \begin{bmatrix} 
    a_1 & \dots & a_r 
  \end{bmatrix} = 
      \begin{bmatrix}
        q_1 & \dots & q_r
      \end{bmatrix} 
        \begin{bmatrix}
          R_{11} & R_{12} & \dots & R_{1r} \\
          0      & R_{22} & \dots & R_{2r} \\
          \vdots & \ddots & \ddots &  \vdots \\
          0 & \ldots & 0 & R_{rr}
        \end{bmatrix}
$$
            
This is quite similar to the result we are after (the QR-decomposition \@ref(thm:qr-decomposition)). </div>\EndKnitrBlock{conjecture}

\BeginKnitrBlock{proof}\iffalse{-91-80-114-111-111-102-32-111-102-32-116-104-101-111-114-101-109-32-92-64-114-101-102-40-116-104-109-58-113-114-45-100-101-99-111-109-112-111-115-105-116-105-111-110-41-93-}\fi{}<div class="proof">\iffalse{} <span class="proof"><em>Proof</em> (Proof of theorem \@ref(thm:qr-decomposition)). </span>  \fi{}Since $\text{rank}(A) = r$, $A$ has $r$ linearly independent columns. Hence, there exists a permutation matrix $\Pi$ such that 

$$
  A \Pi = \begin{bmatrix} a_1 & \dots & a_r & a_{r+1} \dots a_m \end{bmatrix},
$$
  
where $a_1, \ldots, a_r$ are linearly independent, and $a_{r+1}, \ldots, a_m$ are linearly dependent on the first $r$ columns. 

Using Gram-Schmidt (lemma \@ref(lem:gsp)), we know that there exists $\tilde{Q} \in \R^{n \times r}, R \in \R^{r \times r}$ such that $A\Pi = \tilde{Q} R$. Since $\text{span}\{\tilde{q}_1, \ldots, \tilde{q}_r\}$ (columns of $\tilde{Q}$) is equal to $\text{span}\{a_1, \ldots, a_r\}$, there exists an $s_{k(j-r+2)}$ for any $j \in \{r+1, \ldots, m\}$ and $k \in \{1, \ldots, r\}$ such that $a_j = \sum_{k=1}^r s_{k(j-r+2)}q_k$. So, 

$$
  A\Pi = \tilde{Q} \begin{bmatrix} R & S \end{bmatrix}.
$$
  
This is almost the form we want, BUT $\tilde{Q}$ is not orthonormal (it is not square). However, we know that we can pick $n-r$ vectors from $\R^n$ such that adding these as columns to $\tilde{Q}$ we get a set of $n$ linearly independent columns. Now, use Gram-Schmidt to normalize. Since the first $r$ columns are already normalized, these will stay the same. The result is a matrix $Q$, where the columns are all length $1$, and they are all linearly independent. I.e. $Q^TQ = I$. So, $A\Pi = Q \begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix}$, hence

$$
  A = Q \begin{bmatrix} R & S \\ 0 & 0 \end{bmatrix} \Pi^T.
$$
</div>\EndKnitrBlock{proof}


Basically, this gives us a way to perform QR decomposition. However, using the Gram-Schmidt procedure is NOT numerical stable. I.e. we might end up with matrices $Q, R$, and $S$ from which we CANNOT recover $A$. To overcome this, there is a different method called the *Modified Gram-Schmidt Procedure*. 

\BeginKnitrBlock{lemma}\iffalse{-91-84-104-101-32-77-111-100-105-102-105-101-100-32-71-114-97-109-45-83-99-104-109-105-100-116-32-80-114-111-99-101-100-117-114-101-93-}\fi{}<div class="lemma"><span class="lemma" id="lem:mod-gsp"><strong>(\#lem:mod-gsp)  \iffalse (The Modified Gram-Schmidt Procedure) \fi{} </strong></span>**HOMEWORK**</div>\EndKnitrBlock{lemma}

### Householder

\BeginKnitrBlock{definition}\iffalse{-91-72-111-117-115-101-104-111-108-100-101-114-32-82-101-102-108-101-99-116-105-111-110-115-93-}\fi{}<div class="definition"><span class="definition" id="def:unnamed-chunk-30"><strong>(\#def:unnamed-chunk-30)  \iffalse (Householder Reflections) \fi{} </strong></span>A matrix $H = I - 2vv^\prime$, where $\norm{v}_2 = 1$, is called a *Householder Reflection*. </div>\EndKnitrBlock{definition}

A Householder reflection takes any vector and reflects it over $\{tv: t \in \R\}$. 

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:unnamed-chunk-31"><strong>(\#lem:unnamed-chunk-31) </strong></span>Householder reflections are orthogonal matrices.</div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}*HOMEWORK*</div>\EndKnitrBlock{proof}

\BeginKnitrBlock{lemma}<div class="lemma"><span class="lemma" id="lem:unnamed-chunk-33"><strong>(\#lem:unnamed-chunk-33) </strong></span>There exists Householder refelctions $H_1, \ldots, H_r$ such that $H_r \dots H_1 A\Pi = R$. </div>\EndKnitrBlock{lemma}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}Let $A\Pi = \begin{bmatrix} a_1 \dots a_r \end{bmatrix}$. Choose $H_1$ s.t. $H_1 a_1 = R_{11} e_1 = a_1 - 2v_1v_1^\prime a_1$ (last equality due to definition of Householder reflections). This is equivalent to $v_1(2v_1^\prime a_1) = a_1 - R_{11}e_1$. 

Now, let $v_1 = \frac{a_1 - R_{11}e_1}{\norm{a_1 - R_{11}e_2}_2}$. Plug this into the equation for $R_{11}e_1$ above to get 

$$
  R_{11}e_1 = a_1 - \frac{(a_1 - R_{11}e_1)}{\norm{a_1 - R_{11}e_1}_2}\frac{a_1^\prime a_1 - R_{11} a_1^\prime e_1}{\norm{a_1 - R_{11}e_1}_2}.
$$
  
If we multiply this by $e_1^\prime$ from the right, we get

$$
  R_{11} = \pm \norm{a_1}_2, v_1 = \frac{a_1 - \norm{a_1}e_1}{\norm{a_1 - \norm{a_1}_2 e_1}_2}.
$$
  
$$ 
  H_1 = I - \frac{a_1 - \norm{a_1}_2e_1)(a_1 - \norm{a_1}_2 e_1)}{\norm{a_1 - \norm{a_1}_2 e_1}_2^2}
$$
    </div>\EndKnitrBlock{proof}

### Givens Rotations

\BeginKnitrBlock{definition}\iffalse{-91-71-105-118-101-110-115-32-82-111-116-97-116-105-111-110-115-93-}\fi{}<div class="definition"><span class="definition" id="def:givens"><strong>(\#def:givens)  \iffalse (Givens Rotations) \fi{} </strong></span>A *Givens Rotation* is a matrix $G^{(i,j)}$ with entries $(g_{ij})$ such that 

i) $g_{ii} = g_{jj} = \lambda$ (the $i$th and $j$th elements of the diagonal are $\lambda$). 
ii) $g_{kk} = 1$ for all $k \notin \{i,j\}$. (all other diagonal elements are $1$)
iii) $g_{ij} = g_{ji} = \sigma$
iv) $g_{ij} = 0$ for all other pairs of $i,j$. 

In words: $G^{(i,j)}$ is the identity matrix with the $i$th and $j$th diagonal elements made $\lambda$, and the entries at $(i,j)$ and $(j,i)$ are $\sigma$. 
</div>\EndKnitrBlock{definition}


<!--chapter:end:01-lecture_notes.Rmd-->

# Homework Assignments

## Homework 1

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q101"><strong>(\#exr:q101) </strong></span>Can all nonnegative real numbers be represented in such a manner (i.e. as a fp number) for an arbitrary base $\beta \in \{2,3,...\}$? </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}No. For any given $\beta$ and a largest exponent $e_{max}$, any decimal larger than $\beta\cdot\beta^{e_{max}}$ is larger than the largest number possibly representated. </div>\EndKnitrBlock{solution}


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q102"><strong>(\#exr:q102) </strong></span>Suppose $e = -1$, what are the range of numbers that can be represented for an arbitrary base $\beta \in \{2,3,...\}$?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}The smallest number that can be represented for an arbitrary base must be $(0+0\cdot \beta^{-1} + ... + 0\cdot\beta^{-(p-1)})\cdot\beta^{-1}$. 

Since $0 \leq d_i < \beta, \forall i$, the largest value must be attained when $d_i = \beta - 1$ for all $i$. I.e. the largest value must be

\begin{align*}
  MAX &= (\beta-1 + (\beta-1)\beta^{-1} + ... + (\beta-1)\beta^{-(p-1)})\cdot\beta^{-1}\\
      &= (1+\beta^{-1}+...+\beta^{-(p-1)})(\beta-1)\cdot\beta^{-1} \\
      &= (1+\beta^{-1}+...+\beta^{-(p-1)})\cdot(1-\beta^{-1}) \\
      &= (1+\beta^{-1}+...+\beta^{-(p-1)})\cdot(1-\beta^{-1})
\end{align*}</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q103"><strong>(\#exr:q103) </strong></span>Characterize the numbers that have a unique representation in a base $\beta \in \{2,3,...\}$.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}Let 

$$f = \left(d_1\cdot\beta^{-1} + \ldots + d_{p-1}\cdot\beta^{-(p-1)}\right)\cdot\beta^{e},$$ 

i.e. $f$ is not normarlized. Then, 

$$
f = \left(d_1+d_2\beta^{-1} + \ldots + d_{p-1}\cdot\beta^{-p} + 0\cdot \beta^{-(p-1)}\right)\cdot\beta^{e-1}.
$$

So, non-normalized fp numbers are NOT unique. 

Now, let $f$ be a normalized fp number. I.e.

$$
f = \left(d_0 + d_1\cdot\beta^{-1} + \ldots + d_{p-1}\cdot\beta^{-(p-1)} \right)\cdot\beta^e,
$$
where $d_0 \neq 0$. If we let $e_n < e$, then 

$$
f > \left(d_0 + d_1\cdot\beta^{-1} + \ldots + d_{p-1}\cdot\beta^{-(p-1)} \right)\cdot\beta^{e_n},
$$

and if $e_n > e$, then

$$
f < \left(d_0 + d_1\cdot\beta^{-1} + \ldots + d_{p-1}\cdot\beta^{-(p-1)} \right)\cdot\beta^{e_n}
$$

If we let $$d_i^\prime \neq d_i$$ for some number of $i$'s, then

$$
f \neq \left(d_0^\prime + d_1\prime\cdot\beta^{-1} + \ldots + d_{p-1}\prime\cdot\beta^{-(p-1)} \right)\cdot\beta^e.
$$

Hence, normalized FP numbers are unique.</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q104"><strong>(\#exr:q104) </strong></span>Write a function that takes a decimal number, base, and precision, and returns the closest normalized FP representation. I.e. a vector of digits and the exponent.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}The function provided in class is actually the solution (?). This is guarenteed to give a normalized FP representation. Using this algorithm gives $d_0 = \lfloor \frac{N}{\beta^{\lfloor log_{\beta}\left(N\right) \rfloor}}\rfloor$. It holds that $\lfloor log_{\beta}\left(N\right) \rfloor \le log_\beta\left(N\right)$, which implies that $\beta^{\lfloor log_{\beta}\left(N\right) \rfloor} \le \beta^{log_\beta\left(N\right)} = N$ (remember, $\beta \geq 2$). Hence, $d_0 > 0$.</div>\EndKnitrBlock{solution}


```julia
get_normalized_FP = function(number::Float64, base::Int64, prec::Int64)
    #number = 4; base = float(10); prec = 2
    si=sign(number)
    base = float(base)
    e = floor(Int64,log(base,abs(number)))
    d = zeros(Int64,prec)
    num = abs(number)/(base^e)
    
    for j = 1:prec
        d[j] = floor(Int64,num)
        num = (num - d[j])*base
    end

    return "The sign is $si, the exponent is $e, and the vector with d is $d"
end
```

```
## #11 (generic function with 1 method)
```

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q105"><strong>(\#exr:q105) </strong></span>List all normalized fp numbers that can be representated given base, precision, $e_{min}$, and $e_{max}$. </div>\EndKnitrBlock{exercise}


```julia
all_normalized_fp = function(base::Int64, prec::Int64, emin::Int64, emax::Int64)
    ## Number of possible values for each e:
    N = (base-1)*base^(prec-1)#*(emax-emin+1)

    out=zeros(Int64, N, prec, emax-emin+1)

    es = emin:emax

    for e=1:length(es)
        for b0=1:(base-1)
            for i=1:(base^(prec-1))
                out[(b0-1)*(base^(prec-1))+i,1,e] = b0
                for j=1:(prec-1)
                    out[(b0-1)*(base^(prec-1))+i,prec-j+1,e] = floor((i-1)/base^(j-1))%base
                end
            end
        end
    end

    return(out)
end
```

```
## #13 (generic function with 1 method)
```

```julia

```


## Homework 2

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q201"><strong>(\#exr:q201) </strong></span>Lookup the 64 bit standard to find allowed exponents.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}According to [Wikipedia](https://en.wikipedia.org/wiki/Double-precision_floating-point_format), the allowed exponents for the 64 bit standard are $-1022,\ldots, 1023$. </div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q202"><strong>(\#exr:q202) </strong></span>What is the smallest non-normalized positive value for the 64 bit standard?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}The smallest non-normalized positive value is 

$$
  \left(0 + 0\cdot 2^{-1} + \ldots + 0\cdot 2^{-51} + 1\cdot 2^{-52} \right )\cdot 2^{-1022} = 2^{-1074} \approx 4.94\cdot 10^{324}
$$</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q203"><strong>(\#exr:q203) </strong></span>What is the smallest normalized positive value?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}The smallest normalized positive value is 

$$
  \left(1 + 0\cdot 2^{-1} + \ldots + 0\cdot 2^{-52} \right )\cdot 2^{-1022} = 2^{-1022} \approx 2.23 \cdot 10^{308}
$$</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q204"><strong>(\#exr:q204) </strong></span>What is the largest normalized positive value?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}The largest normalized finite value is

$$
  \left(1 + 1\cdot 2^{-1} + \ldots + 1\cdot 2^{-52} \right )\cdot 2^{-1022} \approx 1.80\cdot 10^{308}.
$$</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q205"><strong>(\#exr:q205) </strong></span>Is there a general formula for determining the largest positive value for a given base $\beta$, precision $p$, and largest exponent $e_{max}$? </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}The largest positive, finite value is 

$$
  \left(\sum_{i=0}^{p-1} (\beta-1)\beta^{-i}\right)\cdot \beta^{e_{max}}.
$$</div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q206"><strong>(\#exr:q206) </strong></span>Verify the smallest non-normalized, positive number that can be represented.</div>\EndKnitrBlock{exercise}


```julia
nextfloat(Float64(0)) == 2^(-1074)
```

```
## true
```

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q207"><strong>(\#exr:q207) </strong></span>Verify the smallest normalized, positive number that can be represented.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q208"><strong>(\#exr:q208) </strong></span>Verify the largest, finite number that can be represented.</div>\EndKnitrBlock{exercise}


```julia
prevfloat(Float64(Inf))
```

```
## 1.7976931348623157e308
```

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q209"><strong>(\#exr:q209) </strong></span>Proof lemma (bound of relative error). </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q210"><strong>(\#exr:q210) </strong></span>What happens with lemmas (bounds of absolute and relative error) if we consider negative numbers?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}They still hold. Let $z^\prime = -z$. Then $fl(z^\prime) = -fl(z)$. Hence,

$$
  \left| fl(z^\prime) - z^\prime \right | = \left | -fl(z) + z \right | = \left | fl(z) - z \right |,
$$

hence the bounds still hold. </div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q211"><strong>(\#exr:q211) </strong></span>Show that $\left|\left| A \right|\right|_1 =$ max of the $l^1$ norms of the columns of $A$.</div>\EndKnitrBlock{exercise}

\begin{solution} \label{s211}
By definition, $\norm{A}_1 = \max_{x\neq 0}\frac{\norm{Ax}_1}{\norm{x}_1}$. Let $A \in \R^{m\times n}$ and $x \in \R^n$ s.t. $\norm{x}_1 = 1$. 

Recall that 

$$Ax = \sum_{j=1}^n x_j A_{*,j},$$

where $A_{*,j}$ is the $j^\prime$th column of $A$. So

\begin{align*}
  \norm{Ax}_1 = \sum_{i=1}^m \sum_{j=1}^n | x_j A_{i,j} | \\
              &\leq \sum_{i=1}^m \sum_{j=1}^n | x_j | \cdot | A_{i,j} | \\
              &= \sum_{j=1}^n | x_j | \left\{\sum_{i=1}^m | A_{i,j} | \right \} \\
              &= \sum_{j=1}^n | x_j | \norm{A_{*,j}} \\
              &\leq \sum_{j=1}^n | x_j | \max_{j \in \{1,\ldots, n\}} \norm{A_{*,j}} \\
              &= \max_{j \in \{1,\ldots, n\}} \norm{A_{*,j}}
\end{align*}

Since $\max_{j \in \{1, \ldots, n\}}\norm{A_{*,j}} = \norm{A\cdot \mathbf{1}_i}$ for $i = \argmax \norm{A_{*,j}}_1$. Here, we let $1_i = (x_j)_{j=1}^n$ be defined as 

$$x_j = \left\{ \begin{array}{rl} 1, & \text{ if } j = i \\ 0, & \text{ otherwise}\end{array} \right .$$
\end{solution}


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q212"><strong>(\#exr:q212) </strong></span>Show that $\left|\left| A \right|\right|_\infty =$ max of the $l^1$ norms of the rows of $A$.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q213"><strong>(\#exr:q213) </strong></span>Assume the Fundamental Axiom. Show the following:
  
$$\left|\left| fl(A)-A \right|\right|_p \leq u \left|\left|A\right|\right|_p$$</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}\begin{align*}
  \left | \left | fl(A) - A \right | \right |_p &= \left|\left| \left [ fl(a_{ij}) - a_{ij} \right ] \right|\right|_p \\
    &\leq \left|\left| \left[u\cdot a_{ij}\right]\right|\right|_p \\
    &= \left|\left| u\cdot A\right|\right|_p = u\left|\left|A\right|\right|
\end{align*}</div>\EndKnitrBlock{solution}

\begin{solution}
\begin{align*}
  \left | \left | fl(A) - A \right | \right |_p &= \left|\left| \left [ fl(a_{ij}) - a_{ij} \right ] \right|\right|_p \\
                                                &\leq \left|\left| \left[u\cdot a_{ij}\right]\right|\right|_p \\
                                                &= \norm{u\cdot A}_p = u\left|\left|A\right|\right|
\end{align*}
\end{solution}


## Homework 3

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q301"><strong>(\#exr:q301) </strong></span>Prove lemma \@ref(lem:proofHW). </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{proof}<div class="proof">\iffalse{} <span class="proof"><em>Proof. </em></span>  \fi{}Recall that a matrix $A$ is invertible if and only if $Ax = 0$ implies that $x = 0$. So to check that $I-F$ is invertible, we check this:
  
$$
  (I-F)x = x-Fx \Rightarrow x = Fx \Rightarrow \norm{x}_p \leq \norm{F}_p \norm{x}_p.
$$
  
Since $\norm{F}_p < 1$ by assumption, the only solution to the inequality above is $x = 0$. So, $I-F$ is invertible. 


  </div>\EndKnitrBlock{proof}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q302"><strong>(\#exr:q302) </strong></span>Consider Theorem and Lemmas under "Square Linear Systems". What happens if we use $l^{1}$-norm instead?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q303"><strong>(\#exr:q303) </strong></span>Generate examples that show the bound in ??? is too conservative.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q304"><strong>(\#exr:q304) </strong></span>Generate examples that show the bound is nearly achieved</div>\EndKnitrBlock{exercise}


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q305"><strong>(\#exr:q305) </strong></span>For motivating problems 1-5, when is $x$ unique?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q306"><strong>(\#exr:q306) </strong></span>For motivating problem 5, what happens if $p\geq m$? Explore the case where $m >> n$.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q307"><strong>(\#exr:q307) </strong></span>Suppose $R \in \R^{m\times m}$ is an upper triangular matrix with $R_{ii} \neq 0$ for all $i = 1,\ldots, n$. Is $R$ invertible?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}Since $R$ is an upper triangular matrix, $\det(R) = \prod_{i=1}^{m} R_{ii} > 0$. Hence, $R$ is invertible. </div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q308"><strong>(\#exr:q308) </strong></span>Assume $R$ is an invertible upper triangular matrix. Implement a solution to invert $R$. </div>\EndKnitrBlock{exercise}

## Homework 4

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q401"><strong>(\#exr:q401) </strong></span>In the solution to \@ref(exm:linear-system), why do $0$ rows on the left-hand side of \@ref(eq:sol-linear-system) correspond to $0$ entries of the $c$ vector on the right-hand side. </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q402"><strong>(\#exr:q402) </strong></span>Let $Q$ be an orthogonal matrix. Show that $\norm{Qx}_2 = \norm{x}_2$. </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q403"><strong>(\#exr:q403) </strong></span>Let f be a vector-valued function over $\R^d$. When is $$\min_x \norm{f(x)}_2 = \min_x \norm{f(x)}_2^2.$$</div>\EndKnitrBlock{exercise}


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q404"><strong>(\#exr:q404) </strong></span>Prove that $P^T P + I$ from solution to example \@ref(exm:und-linear-system) is invertible. </div>\EndKnitrBlock{exercise}


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q405"><strong>(\#exr:q405) </strong></span>Write out the solution to example \@ref(exm:constrained-least-squares). Also consider the case where $p \ge m$.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q406"><strong>(\#exr:q406) </strong></span>For all motivating problems, implement solutions. </div>\EndKnitrBlock{exercise}

For the following, assume $A \in \R^{n\times m}$ with $\text{rank}(A) = m$, and $b \in \R^n$. Let $C = \begin{bmatrix} A b \end{bmatrix}$. 


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q407"><strong>(\#exr:q407) </strong></span>What does the last column of $R$ (from the QR decomposition of $C$) represent?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q408"><strong>(\#exr:q408) </strong></span>What does the last entry of last column of $R$ (from the QR decomposition of $C$) represent?</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q409"><strong>(\#exr:q409) </strong></span>How can this be used in computation?</div>\EndKnitrBlock{exercise}

## Homework 5

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q501"><strong>(\#exr:q501) </strong></span>Implement the Gram-Schmidt procedure for matrices $A \in \R^{n \times m}$ assuming $A$ has full column rank.

Create examples to show that the function works (well enough).</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q502"><strong>(\#exr:q502) </strong></span>Find examples where Gram-Schmidt fails, i.e. where either $Q R \neq A$ or $Q^TQ \neq I$. </div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q503"><strong>(\#exr:q503) </strong></span>Look up the modified Gram-Schmidt Procedure and implement it (again assuming $A$ has full column rank). </div>\EndKnitrBlock{exercise}


\BeginKnitrBlock{exercise}\iffalse{-91-80-105-118-111-116-105-110-103-32-40-42-79-80-84-73-79-78-65-76-42-41-93-}\fi{}<div class="exercise"><span class="exercise" id="exr:q504"><strong>(\#exr:q504)  \iffalse (Pivoting (*OPTIONAL*)) \fi{} </strong></span>References:
  
  1. Businger, Galub: Linear Least Squares by Householder Transformation (1965)
  2. Engler: The Behavior of QR-factorization algorithm with column pivoting (1997)
  
Implement modified Gram-Schmidt with column pivoting. 

Find example where the modified Gram-Schmidt fails, but the modified Gram-Schmidt with column pivoting does not.
  </div>\EndKnitrBlock{exercise}


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q505"><strong>(\#exr:q505) </strong></span>Show that Householder reflections are orthogonal matrices.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{solution}<div class="solution">\iffalse{} <span class="solution"><em>Solution. </em></span>  \fi{}Show that $H^\prime H = I$. </div>\EndKnitrBlock{solution}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q506"><strong>(\#exr:q506) </strong></span>Show that $\begin{bmatrix} H_r \cdots h_1 \end{bmatrix}$ is orthogonal.</div>\EndKnitrBlock{exercise}

\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:q507"><strong>(\#exr:q507) </strong></span>Show that a Givens rotation is an orthonormal matrix when $\sigma^2 + \lambda^2 = 1$. </div>\EndKnitrBlock{exercise}

<!--chapter:end:02-homework_assignments.Rmd-->

