sh.enableSharding('test');
db.ventas.ensureIndex({Factura : 1});
sh.shardCollection('test.ventas', {Factura : 1});
sh.setBalancerState(true);

dbConfig = db.getSiblingDB('config');
dbConfig.settings.save( {_id: 'chunksize', value: 1} );