# ECCV16-CBN

Released on Aug 19, 2016

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
The codes are based on Dr. Yuanjun Xiong et al.'s modified version of multi-GPU caffe ([https://github.com/yjxiong/caffe](https://github.com/yjxiong/caffe)). We would really like to thank for their wonderful job!

This implementation has been modified toward a pure deep solution with slightly more robust results, also for the convenience of code release. The original implementation used the internal SIFT API when aligning faces. Hence we no longer provide its [VLFeat](https://github.com/vlfeat/vlfeat) retrained demo version for aligning faces.

## Installation

1. Install Dr. Yuanjun Xiong et al's [modified caffe](https://github.com/yjxiong/caffe). Please note that matlab binary should also be compiled. 
2. Copy all the folders from this repo into the installed caffe, e.g. put folder `codes` in the root directory, put folder `examples/sr1` in the `examples` folder, and all other things in the root directory.
3. Run the script `initial.sh` to obtain the models and the provided test data. You can of course use your own test data by putting them into the folder `examples/sr1/demo/image_source`.
4. Get the the directory of `examples/sr1/demo` and in Matlab, run `demoCBN.m` to view results.

## Handling other input size
The current input face size in the demo is 5pxIOD. In our paper we claimed the input size is better not smaller than 5pxIOD. If the input face size is between 5pxIOD and 10pxIOD, we still go through the whole hallucination process (its slightly higher resolution compared to 5pxIOD is useful for face alignment but for hallucination we still need to go from 5pxIOD). If the input face size is larger than 10pxIOD, we would suggest to first perform face alignment and then use the fixed alignment result for hallucination (We observed that some alignment approaches like [CFSS](https://github.com/zhusz/CVPR15-CFSS) with the [VJ-detector model?](a) would suffice that resolution). All the face alignment network as well as the first cascade of hallucination would thus not be gone through.

## Matlab Version
The code can be run on Unix Matlab with version lower or equal to R2014b. We appologize for the inconvenience caused. The problem is in the image rigid transformation functions and they are not readjusted to the new functions like `imwarp` begin from R2015a. We will give it refactored soon.

## Feedback
Suggestions and opinions of this work (both positive and negative) are greatly welcome. Please contact the author by sending email to `zhshzhutah2@gmail.com`.

## License
BSD-3, see `LICENSE` file for details.


