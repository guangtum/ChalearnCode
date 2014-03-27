import os
import cv2
import zipfile
from ChalearnLAPSample import GestureSample,Skeleton

data='/home/guang/work/Copy/Project/Chalearn2014/ChalearnData/Traindata'
#data='./Train2/'
fileList = os.listdir(data)
# Filter input files (only ZIP files)
sampleList=[]
gestureid=[]
gesturena=[]
gesturestart=[]
gestureend=[]
datapath=''
samplename=''
windowname=''
gesturenumonly=0
gesturenumframe=0
waittime = 1
for file in fileList:
        samplename=file.split('.')[0]
	if file.endswith(".zip") and samplename=='Sample0002':
		gestureid=[]
		gesturena=[]
		gesturestart=[]
		gestureend=[]
		gesturelen=[]
                gesturespace=[]
                datapath=os.path.join(data,file)
		gestureSample = GestureSample(datapath)
                #print skeletonpixelpos['HipCenter']
                gestureinfor = gestureSample.getGestures()
		gesturenumframe =gestureSample.getNumFrames()
                avghipw=0
                avghiph=0
                avgheadw=0
                avgheadh=0
                topleftw=0
                toplefth=0
                bottomrightw=0
                bottomrighth=0
                countnozero=0
		for nu in range(1, gestureSample.getNumFrames()):
                        skeletonframe=gestureSample.getSkeleton(nu)
                        skelepixel=skeletonframe.getPixelCoordinates()
                        #print skelepixel['HipCenter']
                        if skelepixel['HipCenter'][0]!=0 and skelepixel['HipCenter'][1]!=0:
                        	countnozero = countnozero+1
                                avghipw = avghipw+skelepixel['HipCenter'][0]
                                avghiph = avghiph+skelepixel['HipCenter'][1]
                                avgheadw = avgheadw+skelepixel['Head'][0]
                                avgheadh = avgheadh+skelepixel['Head'][1]
                avghipw=avghipw/countnozero
                avghiph=avghiph/countnozero
                avgheadw=avgheadw/countnozero
                avgheadh=avgheadh/countnozero
                topleftw=int(max(1,avghipw-(avghiph-avgheadh)*1))
                toplefth=int(max(1,avgheadh-(avghiph-avgheadh)*0.4))
                bottomrightw=int(min(639,avghipw+(avghiph-avgheadh)*1))
                bottomrighth=int(min(479,avghiph+(avghiph-avgheadh)*0.68))         

                print bottomrightw-topleftw
                for ila in range(len(gestureinfor)):
                	gestureid.append(gestureinfor[ila][0]) # get the id of the label
                	gesturena.append(gestureSample.getGestureName(gestureinfor[ila][0])) # get the name of the label
                	gesturestart.append(gestureinfor[ila][1]) # get the start frame
                	gestureend.append(gestureinfor[ila][2])   # get the end frame
                	gesturelen.append(gestureinfor[ila][2]-gestureinfor[ila][1]+1)   # get the length of the gesture
                        if ila!=len(gestureinfor)-1:
				gesturespace.append(gestureinfor[ila+1][1]-gestureinfor[ila][2]+1)   # get the length of the gesture
			else:
				gesturespace.append(gesturenumframe-gestureinfor[ila][2]+1)   # get the length of the gesture
		if gesturenumonly == 1:
                        print samplename, gestureid, len(set(gestureid))
                        print gesturelen
			print gesturespace
		        del gestureSample
			continue
		cv2.namedWindow(samplename,cv2.WINDOW_NORMAL)
                getid=0
		for x in range(1, gestureSample.getNumFrames()):
			img=gestureSample.getComposedFrame(x)
                        if x >= gesturestart[getid] and x <= gestureend[getid]:
                                windowname= 'start ' + gesturena[getid] + ': '+ str(x) + \
                                ' in ' + '[' + str(gesturestart[getid]) + ', ' + str(gestureend[getid]) + ']' 
                                cv2.putText(img, windowname, (30,50), cv2.FONT_HERSHEY_SIMPLEX, 2, (0,0,255),thickness=2)
                        else:
                                cv2.putText(img, 'no gesture: ' + str(x) , (30,50), cv2.FONT_HERSHEY_SIMPLEX, 2, (0,0,255),thickness=2)
                        if x == gesturestart[getid] or x == gestureend[getid]:
				waittime = 500
			else:
				waittime = 30
                        if x == gestureend[getid] and getid !=len(gestureinfor)-1:
                        	getid=getid+1
                        cv2.rectangle(img,(topleftw,toplefth),(bottomrightw,bottomrighth),(0,255,0),3)
			cv2.imshow(samplename,img)
			cv2.waitKey(waittime)
		del gestureSample
		cv2.destroyAllWindows() 
