import numpy as np
from PIL import Image
import os
import caffe
import scipy.io

#import matplotlib.pyplot as plt

# comment out the following two lines if not using GPU
#caffe.set_mode_gpu()
#caffe.set_device(0)

# load net
net = caffe.Net('deploy_16s_LMSun.prototxt', 'FCN_scene_parsing.caffemodel', caffe.TEST)

path_ = '/home/levicorpus/Documents/CVIT/scene_parsing_model/image.jpg';
# load image and resize to 500x500
im = Image.open(path_)
im = im.resize((500,500), Image.BICUBIC);

in_ = np.array(im, dtype=np.float32)
in_ = in_[:,:,::-1]
in_ -= np.array((104.00698793,116.66876762,122.67891434))
in_ = in_.transpose((2,0,1))

# shape for input (data blob is N x C x H x W), set data
net.blobs['data'].reshape(1, *in_.shape)
net.blobs['data'].data[...] = in_
# run net and take argmax for prediction
net.forward()

# save result
out = net.blobs['score'].data[0].argmax(axis=0)
#scipy.io.savemat('output.mat', dict(out=out))

#plt.imshow(out)
rescaled = out.astype(np.uint8)
result = Image.fromarray(rescaled)
result.save('output.png')


