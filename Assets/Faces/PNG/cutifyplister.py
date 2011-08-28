import os

filename = "test.plist"

# Create a file object:
# in "write" mode
FILE = open(filename,"w")

FILE.write('<?xml version="1.0" encoding="UTF-8"?>\n')
FILE.write('<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n')
FILE.write('<plist version="1.0">\n')
FILE.write('<array>\n')

for eachdir in os.listdir(os.path.curdir):

	if eachdir.endswith('plist') or eachdir.endswith('py') or eachdir == 'OriginalFaces':
		#no files plz!
		continue
		
	FILE.write('<dict>\n')
	FILE.write('<key>Name</key>\n')
	FILE.write('<string>')
	FILE.write(eachdir)
	FILE.write('</string>\n')
	FILE.write('<key>Image</key>\n')
	FILE.write('<string>CutifyPack1.png</string>\n')
	FILE.write('<key>Type</key>\n')
	FILE.write('<string>Pack</string>\n')
	FILE.write('<key>Categories</key>\n')
	FILE.write('<array>\n')
	
	# delve deeper
	
	for eachsubdir in os.listdir(os.path.join(eachdir, os.path.curdir)):
			
		FILE.write('<dict>\n')
		
		FILE.write('<key>Name</key>\n')
		FILE.write('<string>')
		FILE.write(eachsubdir)
		FILE.write('</string>\n')
		
		FILE.write('<key>Image</key>\n')
		FILE.write('<string>CutifyPack1.png</string>\n')
		FILE.write('<key>Stickers</key>\n')
		FILE.write('<array>\n')
		
		#deeper!
		for eachfile in os.listdir(os.path.join(eachdir, os.path.join(eachsubdir, os.path.curdir))):
			FILE.write('<dict>\n')
			FILE.write('<key>Name</key>\n')
			FILE.write('<string>')
			FILE.write(eachfile)
			FILE.write('</string>')
			FILE.write('<key>Image</key>\n')
			FILE.write('<string>')
			FILE.write(eachfile)
			FILE.write('</string>')
			FILE.write('<key>Type</key>\n')
			FILE.write('<string>Sticker</string>\n')
			FILE.write('</dict>\n')
		
		#wrap categories
		FILE.write('</array>\n')
		FILE.write('</dict>\n')
	
	#wrap packs
	FILE.write('</array>\n')
	FILE.write('</dict>\n')

#closing tags
FILE.write('</array>\n')
FILE.write('</plist>\n')        
