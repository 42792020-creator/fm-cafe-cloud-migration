// app/server.js
const express = require('express');
const getFeatureFlags = require('./readFeatureFlags');
let flags = {};

async function refreshFlags(){
  try {
    flags = await getFeatureFlags();
    console.log('Flags refreshed', flags);
  } catch (e) { console.warn('Refresh error', e.message); }
}

const REFRESH_INTERVAL = 30 * 1000;
refreshFlags();
setInterval(refreshFlags, REFRESH_INTERVAL);

const app = express();
app.get('/', (req, res) => {
  if (flags.maintenance_mode) return res.status(503).send('Maintenance mode active');
  if (flags.enable_new_checkout) return res.send('NEW checkout flow enabled');
  return res.send('Old checkout flow');
});

app.get('/flags', (req, res) => res.json(flags));

app.listen(8080, '0.0.0.0', () => console.log('✅ App listening on port 8080'));
