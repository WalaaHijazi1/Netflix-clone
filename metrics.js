const client = require('prom-client');
const register = new client.Registry();

// Collect default metrics like memory/cpu usage
client.collectDefaultMetrics({ register });

module.exports = register;
