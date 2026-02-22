import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Initialize Supabase
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

// Security middleware
app.use(helmet());
app.use(cors({
  origin: ['http://localhost:3000', 'https://anjali-furniture.vercel.app'],
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// ==================== PRODUCTS API ====================

// Get all products
app.get('/api/products', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get single product
app.get('/api/products/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('id', req.params.id)
      .single();
    
    if (error) throw error;
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Create product
app.post('/api/products', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('products')
      .insert([req.body])
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Update product
app.put('/api/products/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('products')
      .update(req.body)
      .eq('id', req.params.id)
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Delete product
app.delete('/api/products/:id', async (req, res) => {
  try {
    const { error } = await supabase
      .from('products')
      .delete()
      .eq('id', req.params.id);
    
    if (error) throw error;
    res.json({ success: true, message: 'Product deleted' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// ==================== WOODS API ====================

// Get all woods
app.get('/api/woods', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('woods')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Create wood
app.post('/api/woods', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('woods')
      .insert([req.body])
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Update wood
app.put('/api/woods/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('woods')
      .update(req.body)
      .eq('id', req.params.id)
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Delete wood
app.delete('/api/woods/:id', async (req, res) => {
  try {
    const { error } = await supabase
      .from('woods')
      .delete()
      .eq('id', req.params.id);
    
    if (error) throw error;
    res.json({ success: true, message: 'Wood deleted' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// ==================== CUSTOMER REQUESTS API ====================

// Create customer request
app.post('/api/requests', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('customer_requests')
      .insert([{
        ...req.body,
        created_at: new Date().toISOString()
      }])
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get all requests (admin only)
app.get('/api/requests', async (req, res) => {
  try {
    // Simple auth check (you should implement proper JWT auth)
    const authToken = req.headers.authorization;
    if (authToken !== `Bearer ${process.env.ADMIN_TOKEN}`) {
      return res.status(401).json({ success: false, error: 'Unauthorized' });
    }

    const { data, error } = await supabase
      .from('customer_requests')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Update request status
app.patch('/api/requests/:id', async (req, res) => {
  try {
    const { status } = req.body;
    const { data, error } = await supabase
      .from('customer_requests')
      .update({ status })
      .eq('id', req.params.id)
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Delete request
app.delete('/api/requests/:id', async (req, res) => {
  try {
    const { error } = await supabase
      .from('customer_requests')
      .delete()
      .eq('id', req.params.id);
    
    if (error) throw error;
    res.json({ success: true, message: 'Request deleted' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// ==================== CONFIG API ====================

// Get config
app.get('/api/config', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('config')
      .select('*')
      .limit(1)
      .single();
    
    if (error) throw error;
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Update config (admin only)
app.put('/api/config', async (req, res) => {
  try {
    const authToken = req.headers.authorization;
    if (authToken !== `Bearer ${process.env.ADMIN_TOKEN}`) {
      return res.status(401).json({ success: false, error: 'Unauthorized' });
    }

    const { data, error } = await supabase
      .from('config')
      .update({ ...req.body, updated_at: new Date().toISOString() })
      .eq('id', 1)
      .select();
    
    if (error) throw error;
    res.json({ success: true, data: data[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});