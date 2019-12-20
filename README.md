About
============
MATLAB code of our DICTA 2019 paper:

"Visual Localization Under Appearance Change: A Filtering Approach" - DICTA 2019 **(Best paper award)**. [Anh-Dzung Doan](https://sites.google.com/view/dzungdoan/home), [Yasir Latif](http://ylatif.github.io/), [Thanh-Toan Do](https://sites.google.com/view/thanhtoando/home), [Yu Liu](https://sites.google.com/site/yuliuunilau/home), Shin-Fang Ch’ng, [Tat-Jun Chin](https://cs.adelaide.edu.au/~tjchin/doku.php), and [Ian Reid](https://cs.adelaide.edu.au/~ianr/) [[pdf]](https://arxiv.org/abs/1811.08063)

If you use/adapt our code, please kindly cite our paper.

Dependencies
============

+ VLFeat library, version 0.9.21 (http://www.vlfeat.org/)
+ yael library (http://yael.gforge.inria.fr/)
+ Piotr's Computer Vision Matlab Toolbox (https://pdollar.github.io/toolbox/)
+ Some codes adapted from Akihiko Torii and Relja Arandjelovic (http://www.ok.ctrl.titech.ac.jp/~torii/project/247/)

We included, compiled and tested all 3rh party libraries on MATLAB R2018a, Ubuntu 16.04 LTS 64 bit

Dataset
============

+ Please download dataset.zip and workdir.zip from [here](https://drive.google.com/open?id=1TNvcd6RWPydm6Z2dTvZ90FHZ2uZevwt1), and unzip them in the source code's directory
+ Projection and whitening matrices are adapted from DenseVLAD paper of Torii et al. (http://www.ok.ctrl.titech.ac.jp/~torii/project/247/)

Currently, we only publish the code to test Oxford RobotCar dataset with alternate route.
We will publish code for RobotCar's full route and GTA dataset soon

Feature Extraction
============

Run extractFeatures.m to extract features

If you are lazy, we included precomputed features in the work_dir/ with the name format: <sequence_name>.mat


Localization
============

Run doLocalization.m

For altenate route, it takes around 10 minute to finish. After finishing, it will show mean and median errors, and plot the predicted trajectory same as Figure 8d within the paper

Support
============

If you have any questions, feel free to contact me
