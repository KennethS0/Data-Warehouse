setConfig: 
	mongo --port 20006 shardConfigFile.js
status:
	mongo --port 20006 --eval "printjson(sh.status())"
test:
	mongo --nodb shardTestFile.js
runJob:
	python CheckerJob.py
