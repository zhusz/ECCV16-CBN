# ECCV16-CBN

Released on August 19, 2016

## Description

This is the demo implementation of Shizhan Zhu et al.'s ECCV-16 work [Deep Cascaded Bi-Network for Face Hallucination](http://arxiv.org/pdf/1607.05046.pdf). We appologize for not providing the training code because the training process actually requires lots of manual efforts for analyzing and manipulating the intermediate result, and hence it is difficult to provide a one-script training code. But we are happy to share any training details. Please write emails to Shizhan Zhu `zhshzhutah2@gmail.com` for details if you wish.

The project is open source under BSD-3 license (see the `LICENSE` file). Codes can be used freely only for academic purpose. If you want to apply it to industrial products, please send an email to Shizhan Zhu at `zhshzhutah2@gmail.com` first.

## Citation
If you use the codes as part of your research project, please cite our work as follows:
```
@inproceedings{zhu2016deep,
  title={Deep Cascaded Bi-Network for Face Hallucination},
  author={Zhu, Shizhan and Liu, Sifei and Loy, Chen Change and Tang, Xiaoou},
  booktitle={European Conference on Computer Vision},
  year={2016}
}
```

## Dependency
The codes are based on [caffe](https://github.com/BVLC/caffe).

This implementation has been modified toward a pure deep solution with slightly more robust results, also for the convenience of code release. The original implementation used the internal SIFT API when aligning faces. Hence we no longer provide its [VLFeat](https://github.com/vlfeat/vlfeat) retrained demo version for aligning faces and the codes are only depedent to caffe.

## Installation and Running

1. Install [caffe](https://github.com/BVLC/caffe). Please note that matlab binary should also be compiled. 
2. Copy all the folders and files from this repo into the installed caffe, e.g. put folder `codes` in the root directory, put folder `examples/sr1` in the `examples` folder, and all other things in the root directory.
3. Run the script `initial.sh` to obtain the models and the provided test data. You can of course use your own test data by putting them into the folder `examples/sr1/demo/image_source`.
4. Get into the the directory of `examples/sr1/demo` and in Matlab, run `demoCBN.m` to view results.

Note that the main algorithm presented in our [paper](http://arxiv.org/pdf/1607.05046.pdf) is only run by [CBN.m](https://github.com/zhusz/ECCV16-CBN/blob/master/examples/sr1/demo/CBN.m).

[demoCBN.m](https://github.com/zhusz/ECCV16-CBN/blob/master/examples/sr1/demo/demoCBN.m) only provides a way to generate the input LR samples. In [demoCBN.m](https://github.com/zhusz/ECCV16-CBN/blob/master/examples/sr1/demo/demoCBN.m) we begin from HR image only in order to get the VJ face detection box. If you want to test LR faces (not downsampled from HR) then you need to think of your own way to get the VJ face detection box.

In reality, you can feed any LR faces to [CBN.m](https://github.com/zhusz/ECCV16-CBN/blob/master/examples/sr1/demo/CBN.m) and view the output. What you need to be careful is that all the facial parts need to be presented in the input LR images (including face contour). On the other hand, the face cannot be too small (smaller than 5pxIOD). This is why it is recommendted to provide the input just in the same way as in [demoCBN.m](https://github.com/zhusz/ECCV16-CBN/blob/master/examples/sr1/demo/demoCBN.m). 

## Ghosting Effect Observation Experiment

One of probably the most interesting findings of this paper might be related to the so-called **ghosting effect**. To give an illustration, run the following codes (after finishing Step 1-3 of the [Installation](https://github.com/zhusz/ECCV16-CBN#installation-and-running) part).

```matlab
>> clear; addpath(genpath('../../../matlab')); addpath(genpath('../../../codes'));
>> h4 = CBN_ghosting(ones([16 16 1 2],'single')/3);
>> subplot(121); imshow(ones([16 16])/3); title('Input to CBN');
>> subplot(122); imshow(h4(:,:,:,1)); title('Output (Ghosting Effect)');
```

And you would expect to see the following input and output.

Input 
![alt tag](https://github.com/zhusz/ECCV16-CBN/raw/master/A.png)
Output 
![alt tag](https://github.com/zhusz/ECCV16-CBN/raw/master/B.png)

Enjoy! :P

## Matlab Version
The code can be run on Unix Matlab with version lower or equal to R2014b. We appologize for the inconvenience caused. The problem is in the image rigid transformation functions and they are not readjusted to the new functions like `imwarp` begin from R2015a. We will give it refactored soon.

## Handling other input size
The current input face size in the demo is 5pxIOD. In our paper we claimed the input size is better not smaller than 5pxIOD. If the input face size is between 5pxIOD and 10pxIOD, we still go through the whole hallucination process (its slightly higher resolution compared to 5pxIOD is useful for face alignment but for hallucination we still need to go from 5pxIOD). If the input face size is larger than 10pxIOD, we would suggest to first perform face alignment and then use the fixed alignment result for hallucination (We observed that some alignment approaches like [CFSS](https://github.com/zhusz/CVPR15-CFSS) with [its model trained for the  VJ-detector](https://www.dropbox.com/s/jvoylj8tpgo6yj4/CFSS_Model_VJ.tar.gz) would suffice that resolution). All the face alignment network as well as the first cascade of hallucination would thus not be gone through.

## Acknowledgement

In training, we use Dr. Yuanjun Xiong et al's [modified version of caffe](https://github.com/yjxiong/caffe). We would like to thank for their wonderful job!

## Feedback
Suggestions and opinions of this work (both positive and negative) are greatly welcome. Please contact the author by sending email to `zhshzhutah2@gmail.com`.

## License
BSD-3, see `LICENSE` file for details.


