# Neighbor-Sensitive Hashing

## Overview

Neighbor-Sensitive Hashing is a state-of-the-art approximate k-Nearest Neighbor search algorithm in high-dimensional space. The searching capability in high-dimensional space enables us to search images or documents, both of which can be represented by high-dimensional vectors.

Our work is based on the intuition that we do not have to capture the distances to distant objects (i.e., the objects that are not likely to be queries' k-nearest neighbors). Instead, we use the limited resource (hash bits) for more accurately discerning the comparative distances to close objects (i.e., the objects that are likely to be queries' k-nearest neighbors). Counter-intuitively, this is possible by increasing the distances between nearby objects in a hashed-space (or equivalently, Hamming space), which contrasts to the objectives of many existing algorithms.

## Superior Performance

Our work has shown superior performances over other state-of-the-art techniques such as [Spectral Hashing](http://papers.nips.cc/paper/3383-spectral-hashing), [Spherical Hashing](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=6248024), [Complementary Projection Hashing](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=6751141), and so on, according to our comprehensive experiments. Our experiments not only include "codesize vs. recall" analysis in many machine learning literatures, but also include "latency vs. recall" analysis. Find more detail in [our paper](http://www.vldb.org/pvldb/vol9/p144-park.pdf) published in PVLDB 2016.

## Demonstration (only in 10 secs)

Anyone who has Matlab installed on her machine can download and run our code in less than 10 seconds. For comparison, we also ship our code with two state-of-the-art learning-based hashing-algorithms.

Download code in this repository, and run a demo by typing `runDemo` in Matlab console.
A simple example of using our module.

  % train our model for b-bit hashcode
  model = trainNSH(X, b);

  % compress a dataset and a query set
  % note: a single byte holds eight bits; so may be hard to interpret
  XB = model.hash(X);
  QB = model.hash(Q);

### Misc.

[Link to author's website](http://web.eecs.umich.edu/~pyongjoo/#nsh)

