shard1 = new Mongo('localhost:20000');
shard1DB = shard1.getDB('test');

shard2 = new Mongo('localhost:20001');
shard2DB = shard2.getDB('test');

shard3 = new Mongo('localhost:20002');
shard3DB = shard3.getDB('test');

printjson(shard1DB.ventas.count());
printjson(shard2DB.ventas.count());
printjson(shard3DB.ventas.count());