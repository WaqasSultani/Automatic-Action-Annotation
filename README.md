# Automatic-Action-Annotation

This folder contains demo code for our Journal of Computer Vision and Image Understanding (CVIU) paper: “Automatic Action Annotation using Weakly Labeled Videos".

Since our code has several components, we have included separate files for each component; some of them can be run side by side.
Please follow the following steps to run code files


1. Use "Script_Saliency image.m" to compute Saliency in each frame of the video. To compute Saliency, please code available at: http://www.vision.caltech.edu/~harel/share/gbvs.php  (Section 3.2 of the paper)
2. Use "Calculate_opticalflow_flowMask.m"  to compute optical_flow Mask in each frame of the video.  (Section 3.2 of the paper)
3. Use "Calculate_3DMRF_MotionSaliency.m" to compute smoothed motion saliency in each frame of the video  (Section 3.2 of the paper)
4. Compute Action proposal in each video using code here: https://github.com/jvgemert/apt  (Section 3.1 of the paper)
5. Use "Calculate_Motion_Score_CV16IA.m" to compute motion score for each proposal in the video. (Section 3.2 of the paper)
6. Compute Improved dense Trajectory features in each video using code here: http://lear.inrialpes.fr/~wang/improved_trajectories (Section 3.3 of the paper)
7. Compute Bag of Words representation of each of top ranked proposal. You can use code "Script_Kmeans_CodeBook.m" to make codebook and "Proposal_Histogram_SPM.m" to make histogram of each proposal. For this purpose, you can also use Online available codes (e.g., vlfeat).(Section 3.3 of the paper)
8. Compute distance between histograms across different videos of the same action, use "Compute_Distance_Matrcies." (Section 3.3 of the paper)
9.***
10. Use "Compute_ProposalClus_forHung.m" to cluster features within each action proposal.(Section 3.3 of the paper)
11. Use "Compute_Distance_Hung.m" to do Bipartite matching and find the distance between proposals between different video.(Section 3.3 of the paper)
12. Use "Compute_Shape_Similarity.m" to compute shape matching between different proposal shapes.(Section 3.3 of the paper)
13. Use "Compute_Location_Pairwise_Similarity.m" to compute location and temporal length between different proposal shapes.(Section 3.3 of the paper)
14. Use "GMCP_S" to get the final Top ranked proposal (Annotation).(Section 3.4 of the paper)

We are still updating the code.

 
In case, you find some bug, could not understand any part of the code, and other any comments, please drop me an email at waqas5163@gmail.com.


If you find this code useful in your research, please cite the following paper:

@article{SULTANI2017,
title = "Automatic action annotation in weakly labeled videos",
journal = "Computer Vision and Image Understanding",
volume = "",
number = "",
pages = "",
year = "2017",
note = "",
issn = "1077-3142",
doi = "http://dx.doi.org/10.1016/j.cviu.2017.05.005",
url = "http://www.sciencedirect.com/science/article/pii/S1077314217300796",
author = "Waqas Sultani and Mubarak Shah",
keywords = "Weakly supervised",
keywords = "Action annotation",
keywords = "Generalized maximum clique graph"
}

Thank you!
