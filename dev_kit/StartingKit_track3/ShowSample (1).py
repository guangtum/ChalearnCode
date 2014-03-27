import os
import cv2
import zipfile
from ChalearnLAPSample import GestureSample

data='./data/'
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
gesturenumonly=1
waittime = 1
for file in fileList:
        samplename=file.split('.')[0]
	if file.endswith(".zip"): #and samplename=='Sample0149':
		gestureid=[]
		gesturena=[]
		gesturestart=[]
		gestureend=[]
		gesturelen=[]
                datapath=os.path.join(data,file)
		gestureSample = GestureSample(datapath)
                gestureinfor = gestureSample.getGestures()
                for ila in range(len(gestureinfor)):
                	gestureid.append(gestureinfor[ila][0]) # get the id of the label
                	gesturena.append(gestureSample.getGestureName(gestureinfor[ila][0])) # get the name of the label
                	gesturestart.append(gestureinfor[ila][1]) # get the start frame
                	gestureend.append(gestureinfor[ila][2])   # get the end frame
                	gesturelen.append(gestureinfor[ila][2]-gestureinfor[ila][1]+1)   # get the end frame
		if gesturenumonly == 1:
                        print samplename, gestureid, len(set(gestureid))
                        print gesturelen
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
				waittime = 1
                        if x == gestureend[getid] and getid !=len(gestureinfor)-1:
                        	getid=getid+1
			cv2.imshow(samplename,img)
			cv2.waitKey(waittime)
		del gestureSample
		cv2.destroyAllWindows() 
