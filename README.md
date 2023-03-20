# Identifying Interpretable Link Communities with User Interactions and Messages in Social Networks

This repository provides a reference matlab implementation of *SLCD* introduced in the paper entitled "Identifying Interpretable Link Communities with User Interactions and Messages in Social Networks", which has been accepted by **ISPA/BDCloud/SocialCom/SustainCom 2019**.

### Abstract
Community detection is a fundamental step in social network analysis. In this study, we focus on the hybrid identification of overlapping communities with network topology (e.g., user interaction) and edge-induced content (e.g., user messages). Conventional hybrid methods tend to combine topology and node-induced content to explore disjoint communities, but fail to integrate edge-induced content and to derive overlapping communities. Moreover, although several semantic community detection approaches have been developed, which can generate the semantic description for each community besides the partition result, they can only incorporate the word-level content to derived coarse-grained descriptions. We propose a novel Semantic Link Community Detection (SLCD) model based on non-negative matrix factorization (NMF). It adopts the perspective of link communities to integrate topology and edge-induced content, where the partitioned link communities can be further transformed into an overlapping node-induced membership. Moreover, SLCD incorporates both the word-level and sentence-level content while considering the diversity of user messages. Hence, it can also derive strongly interpretable and multi-view community descriptions simultaneously when community partition is finished. SLCD’s superior performance and powerful application ability over other state-of-the-art competitors are further demonstrated in our experiments on a series of real social networks.

### Usage
Descriptions of the demonstration code are as follows.
1. **SLCD_demo_R27.m**: demonstration of SLCD on the Reddit27 dataset. The evaluation results (with different parameter settings) will be saved in 'res/'.
2. **SLCD_demo_R26.m**: demonstration of SLCD on the Reddit26 dataset. The evaluation results (with different parameter settings) will be saved in 'res/'.
3. **SLCD_demo_R25**: demonstration of SLCD on the Reddit25 dataset. The evaluation results (with different parameter settings) will be saved in 'res/'.
4. **SLCD_demo_EN**: demonstration of SLCD on the Enron dataset. The evaluation results (with different parameter settings) will be saved in 'res/'.
5. The preprocessed Reddit27, Reddit26, Reddit25, and Enron are given in 'data/' with format '.mat'. The (overlapping) ground-truth of Reddit27, Reddit26, Reddit25, and Enron are also given in 'data/' with format '.txt'. The raw data details of the 4 datasets can be found in 'res/raw'.


Better performance can be achieved by using the random initialization strategy to replace the NNDSVD initialization. Note that multiple runs of SLCD with random initialization may have different overlapping community detection results. If you adopt the random initialization strategy, we recomend to independently run SLCD 10 times (with different random initialization settings) and report the result with minimum loss for the evaluation.

### Citing
Please cite the following paper if you use *SLCD* in your research:
```
@inproceedings{qin2019identifying,
  title={Identifying Interpretable Link Communities with User Interactions and Messages in Social Networks},
  author={Qin, Meng and Li, Wei and Lei, Kai},
  booktitle={2019 IEEE International Conference on Parallel \& Distributed Processing with Applications, Big Data \& Cloud Computing, Sustainable Computing \& Communications, Social Computing \& Networking (ISPA/BDCloud/SocialCom/SustainCom)},
  pages={271--278},
  year={2019},
  organization={IEEE}
}
```

If you have any questions regarding this project, please contact the authors via [mengqin_az@foxmail.com].
