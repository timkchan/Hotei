//
//  OpenCVWrapper.m
//  Hotei
//
//  Created by Ryan Dowse on 14/03/2017.
//  Copyright © 2017 AppBee. All rights reserved.
//

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include "opencv2/imgcodecs.hpp"
#include <opencv2/highgui.hpp>
#include <opencv2/ml.hpp>

#import "OpenCVWrapper.h"

using namespace cv;
using namespace cv::ml;

@implementation OpenCVWrapper: NSObject

// Current trainied SVM model
Ptr<ml::SVM> curr_svm;

- (UIImage *) trainSVM: (double []) hr_arr
                andHRV:(double []) hrv_arr
              andState:(int []) label_arr
               andSize:(int) size{
    
    // Check samples are correct
    for(int i = 0; i < size; ++i){
        printf("Sample %d: hr %f, hrv %f, state %d \n",
               i, hr_arr[i], hrv_arr[i], label_arr[i]);
    }
    
    // --- Model training ---
    // Set up training data
    Mat labelsMat(size, 1, CV_32SC1, label_arr);
    float trainingData[size][2]; // x - hrv, y - hr
    for(int i = 0; i < size; ++i){
        trainingData[i][0] = hrv_arr[i];
        trainingData[i][1] = hr_arr[i];
    }
    Mat trainingDataMat(size, 2, CV_32FC1, trainingData);
    
    // Setup SVM parameters
    Ptr<ml::SVM> svm = ml::SVM::create();
    svm->setType(ml::SVM::C_SVC);
    svm->setKernel(ml::SVM::LINEAR);
    svm->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 100, 1e-6));
    svm->setGamma(3.0);
    
    // Train model
    Ptr<TrainData> td = TrainData::create(trainingDataMat, ROW_SAMPLE, labelsMat);
    svm->train(td);
    
    // Save the current model
    curr_svm = svm;
    
    // --- Visualize data ---
    int width = 200, height = 200; // Max scale for heart rate and HRV
    Mat image = Mat::zeros(height, width, CV_8UC3);
    
    
    Vec3b pos_area_color(135,206,250); // Color: light blue
    Vec3b neg_area_color (132,112,255); // Color: lilac
    // Show the decision regions given by the SVM
    for(int i = 0; i < image.rows; ++i) {
        for(int j = 0; j < image.cols; ++j)
        {
            Mat sampleMat = (Mat_<float>(1,2) << j,i);
            float response = svm->predict(sampleMat);
            
            if (response == 1)
                image.at<Vec3b>(i,j)  = pos_area_color;
            else if (response == -1)
                image.at<Vec3b>(i,j)  = neg_area_color;
        }
    }
    
    // Show the training data
    int thickness = -1;
    int lineType = 8;
    Vec3b pos_label_color(0,0,0), neg_label_color (255,255,255);
    for(int i = 0; i < size; ++i){
        circle( image, cv::Point(trainingData[i][0], trainingData[i][1]),
               5, label_arr[i] ? pos_label_color : neg_label_color, thickness, lineType );
    }
    
    // Show support vectors
    thickness = 2;
    lineType  = 8;
    Mat sv = svm->getSupportVectors();
    printf("Support Vector count:%d\n", sv.rows);
    Vec3b sv_color = {0,0,255};
    for (int i = 0; i < sv.rows; ++i)
    {
        const float* v = sv.ptr<float>(i);
        printf("Support vector: %d, %f, %f", i,v[0],v[1]);
        circle( image,  cv::Point( (int) v[0], (int) v[1]),   6,  sv_color, thickness, lineType);
    }
    
    return [self UIImageFromCVMat:image];
}

- (UIImage *) getPlot {
    Mat image = Mat::zeros(10, 10, CV_8UC3);
    return [self UIImageFromCVMat:image];
}

- (bool)predict: (double) hr andHRV: (double) hrv;{
    //curr_svm->predict(arr samples)
    return true;
}

/*
 test function, from the tutorial
 http://docs.opencv.org/3.0-beta/doc/tutorials/ml/introduction_to_svm/introduction_to_svm.html
 */
- (UIImage *) plotData {
    // Data for visual representation
    int width = 512, height = 512;
    Mat image = Mat::zeros(height, width, CV_8UC3);
    
    // Set up training data
    int labels[4] = {1, -1, -1, -1};
    Mat labelsMat(4, 1, CV_32SC1, labels);
    
    float trainingData[4][2] = { {501, 10}, {255, 10}, {501, 255}, {10, 501} };
    Mat trainingDataMat(4, 2, CV_32FC1, trainingData);
    
    // opencv 3.0
    // Set up SVM's parameters
    Ptr<ml::SVM> svm = ml::SVM::create();
    // edit: the params struct got removed,
    // we use setter/getter now:
    svm->setType(ml::SVM::C_SVC);
    svm->setKernel(ml::SVM::LINEAR);
    svm->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 100, 1e-6));
    svm->setGamma(3.0);
    
    Ptr<TrainData> td = TrainData::create(trainingDataMat, ROW_SAMPLE, labelsMat);
    svm->train(td);
    
    Vec3b pos_color(135,206,250), neg_color (132,112,255);
    // Show the decision regions given by the SVM
    for (int i = 0; i < image.rows; ++i)
        for (int j = 0; j < image.cols; ++j)
        {
            Mat sampleMat = (Mat_<float>(1,2) << j,i);
            float response = svm->predict(sampleMat);
            
            if (response == 1)
                image.at<Vec3b>(i,j)  = pos_color;
            else if (response == -1)
                image.at<Vec3b>(i,j)  = neg_color;
        }
    
    // Show the training data
    int thickness = -1;
    int lineType = 8;
    circle( image, cv::Point(trainingData[0][0],  trainingData[0][1]), 5, Scalar(  0,   0,   0), thickness, lineType );
    circle( image, cv::Point(trainingData[1][0],  trainingData[1][1]), 5, Scalar(255, 255, 255), thickness, lineType );
    circle( image, cv::Point(trainingData[2][0],  trainingData[2][1]), 5, Scalar(255, 255, 255), thickness, lineType );
    circle( image, cv::Point(trainingData[3][0],  trainingData[3][1]), 5, Scalar(255, 255, 255), thickness, lineType );
    
    // Show support vectors
    thickness = 2;
    lineType  = 8;
    Mat sv = svm->getSupportVectors();
    printf("Mat %d, %d\n", sv.rows,sv.cols);
    Vec3b sv_color = {0,0,255};
    for (int i = 0; i < sv.rows; ++i)
    {
        const float* v = sv.ptr<float>(i);
        printf("Support vector: %d, %f, %f", i,v[0],v[1]);
        circle( image,  cv::Point( (int) v[0], (int) v[1]),   6,  sv_color, thickness, lineType);
    }
    
    return [self UIImageFromCVMat:image];
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
