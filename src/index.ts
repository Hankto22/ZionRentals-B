import { Hono } from 'hono';
import { serve } from '@hono/node-server';

const app = new Hono();

app.get('/', (c) => c.text('Welcome to Zion Rental Backend!'));

app.get('/health', (c) => c.json({ status: 'OK' }));

serve({
  fetch: app.fetch,
  port: 3000,
});

console.log('Server running on http://localhost:3000');