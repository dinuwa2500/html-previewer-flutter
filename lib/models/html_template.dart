import 'package:flutter/material.dart';

class HtmlTemplate {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String category;
  final String code;

  const HtmlTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.code,
  });

  static const String defaultHtml = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Page</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
      color: #f8fafc;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
    }
    .card {
      background: rgba(30, 41, 59, 0.8);
      backdrop-filter: blur(12px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 20px;
      padding: 36px;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
      text-align: center;
      transition: transform 0.3s ease;
    }
    .card:hover {
      transform: translateY(-4px);
    }
    .badge {
      display: inline-block;
      background: #6366f1;
      color: #fff;
      font-size: 12px;
      font-weight: 600;
      padding: 4px 12px;
      border-radius: 9999px;
      margin-bottom: 16px;
      letter-spacing: 0.5px;
      text-transform: uppercase;
    }
    h1 {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 12px;
      color: #ffffff;
    }
    p {
      color: #94a3b8;
      font-size: 15px;
      line-height: 1.6;
      margin-bottom: 24px;
    }
    .btn {
      background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
      color: white;
      border: none;
      padding: 12px 28px;
      font-size: 15px;
      font-weight: 600;
      border-radius: 12px;
      cursor: pointer;
      box-shadow: 0 4px 14px rgba(99, 102, 241, 0.4);
      transition: all 0.2s ease;
    }
    .btn:hover {
      filter: brightness(1.1);
      transform: scale(1.03);
    }
    .btn:active {
      transform: scale(0.98);
    }
    #status {
      margin-top: 20px;
      font-size: 14px;
      font-weight: 500;
      color: #10b981;
      min-height: 20px;
    }
  </style>
</head>
<body>
  <div class="card">
    <span class="badge">Live Preview</span>
    <h1>Hello World</h1>
    <p>Edit this HTML code in the editor on the left and click <strong>Run</strong> to see live interactive changes!</p>
    <button class="btn" onclick="handleClick()">Click Me</button>
    <div id="status"></div>
  </div>

  <script>
    let clicks = 0;
    function handleClick() {
      clicks++;
      const status = document.getElementById('status');
      status.textContent = 'Button clicked ' + clicks + ' ' + (clicks === 1 ? 'time' : 'times') + '! 🎉';
      console.log('Button clicked:', clicks);
    }
  </script>
</body>
</html>''';

  static const List<HtmlTemplate> templates = [
    HtmlTemplate(
      id: 'basic',
      title: 'Basic HTML',
      description: 'Clean starter template with typography, gradient card, and interactive button.',
      icon: Icons.code,
      category: 'Starter',
      code: defaultHtml,
    ),
    HtmlTemplate(
      id: 'login',
      title: 'Login Page',
      description: 'Modern glassmorphic login card with validation, animated gradient, and show/hide password.',
      icon: Icons.lock_outline,
      category: 'UI Components',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Glassmorphism Login</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(45deg, #1e1b4b, #312e81, #4c1d95);
      background-size: 400% 400%;
      animation: gradientBG 15s ease infinite;
      padding: 20px;
    }
    @keyframes gradientBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
    .login-box {
      background: rgba(255, 255, 255, 0.08);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid rgba(255, 255, 255, 0.15);
      border-radius: 24px;
      padding: 40px;
      width: 100%;
      max-width: 400px;
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
      color: #fff;
    }
    h2 {
      font-size: 26px;
      font-weight: 700;
      text-align: center;
      margin-bottom: 8px;
    }
    .subtitle {
      text-align: center;
      color: #c7d2fe;
      font-size: 14px;
      margin-bottom: 28px;
    }
    .input-group {
      margin-bottom: 20px;
    }
    label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      margin-bottom: 8px;
      color: #e0e7ff;
    }
    .input-wrapper {
      position: relative;
    }
    input {
      width: 100%;
      padding: 14px 16px;
      background: rgba(255, 255, 255, 0.07);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 12px;
      color: #fff;
      font-size: 15px;
      outline: none;
      transition: border-color 0.2s, background 0.2s;
    }
    input:focus {
      border-color: #818cf8;
      background: rgba(255, 255, 255, 0.12);
    }
    input::placeholder { color: #94a3b8; }
    .toggle-pass {
      position: absolute;
      right: 14px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: #c7d2fe;
      cursor: pointer;
      font-size: 12px;
    }
    .options {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
      margin-bottom: 24px;
    }
    .options a {
      color: #a5b4fc;
      text-decoration: none;
    }
    .submit-btn {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, #4f46e5, #7c3aed);
      border: none;
      border-radius: 12px;
      color: #fff;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      box-shadow: 0 4px 12px rgba(79, 70, 229, 0.35);
      transition: transform 0.1s, filter 0.2s;
    }
    .submit-btn:hover { filter: brightness(1.1); }
    .submit-btn:active { transform: scale(0.98); }
    .alert {
      padding: 12px;
      border-radius: 10px;
      font-size: 13px;
      margin-top: 16px;
      display: none;
      text-align: center;
    }
    .alert.success {
      background: rgba(16, 185, 129, 0.2);
      border: 1px solid #10b981;
      color: #6ee7b7;
      display: block;
    }
  </style>
</head>
<body>
  <div class="login-box">
    <h2>Welcome Back</h2>
    <p class="subtitle">Please enter your credentials to continue</p>
    <form id="loginForm" onsubmit="handleLogin(event)">
      <div class="input-group">
        <label>Email Address</label>
        <input type="email" id="email" placeholder="you@example.com" required>
      </div>
      <div class="input-group">
        <label>Password</label>
        <div class="input-wrapper">
          <input type="password" id="password" placeholder="••••••••" required>
          <button type="button" class="toggle-pass" onclick="togglePassword()">Show</button>
        </div>
      </div>
      <div class="options">
        <label style="display:flex; align-items:center; gap:6px; cursor:pointer;">
          <input type="checkbox" style="width:auto; margin:0;"> Remember me
        </label>
        <a href="#forgot" onclick="alert('Password reset link sent!')">Forgot?</a>
      </div>
      <button type="submit" class="submit-btn">Sign In</button>
      <div id="message" class="alert"></div>
    </form>
  </div>

  <script>
    function togglePassword() {
      const p = document.getElementById('password');
      const btn = event.target;
      if (p.type === 'password') {
        p.type = 'text';
        btn.textContent = 'Hide';
      } else {
        p.type = 'password';
        btn.textContent = 'Show';
      }
    }
    function handleLogin(e) {
      e.preventDefault();
      const email = document.getElementById('email').value;
      const msg = document.getElementById('message');
      msg.className = 'alert success';
      msg.textContent = 'Authenticated successfully as ' + email + ' ✨';
      console.log('User signed in:', email);
    }
  </script>
</body>
</html>''',
    ),
    HtmlTemplate(
      id: 'portfolio',
      title: 'Portfolio',
      description: 'Sleek dark developer portfolio with hero banner, tech stack pills, project cards, and contact form.',
      icon: Icons.person_pin_outlined,
      category: 'Websites',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alex Rivera | Software Engineer</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #090d16;
      color: #e2e8f0;
      line-height: 1.6;
    }
    nav {
      position: sticky;
      top: 0;
      background: rgba(9, 13, 22, 0.85);
      backdrop-filter: blur(12px);
      padding: 16px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08);
      z-index: 100;
    }
    .logo {
      font-weight: 800;
      font-size: 18px;
      color: #38bdf8;
      letter-spacing: -0.5px;
    }
    .nav-links a {
      color: #94a3b8;
      text-decoration: none;
      margin-left: 20px;
      font-size: 14px;
      transition: color 0.2s;
    }
    .nav-links a:hover { color: #fff; }
    .hero {
      padding: 60px 24px;
      max-width: 800px;
      margin: 0 auto;
      text-align: center;
    }
    .avatar {
      width: 96px;
      height: 96px;
      border-radius: 50%;
      background: linear-gradient(135deg, #38bdf8, #818cf8);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 36px;
      margin: 0 auto 20px;
      box-shadow: 0 10px 25px rgba(56, 189, 248, 0.3);
    }
    h1 {
      font-size: 36px;
      font-weight: 800;
      margin-bottom: 12px;
      color: #fff;
    }
    .role {
      color: #38bdf8;
      font-weight: 600;
      font-size: 18px;
      margin-bottom: 16px;
    }
    .bio {
      color: #94a3b8;
      font-size: 16px;
      max-width: 600px;
      margin: 0 auto 28px;
    }
    .skills {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      justify-content: center;
      margin-bottom: 48px;
    }
    .skill-pill {
      background: #1e293b;
      border: 1px solid rgba(255, 255, 255, 0.1);
      padding: 6px 16px;
      border-radius: 20px;
      font-size: 13px;
      color: #cbd5e1;
    }
    .projects {
      max-width: 900px;
      margin: 0 auto;
      padding: 0 24px 60px;
    }
    h2 {
      font-size: 22px;
      margin-bottom: 24px;
      color: #f1f5f9;
      border-left: 4px solid #38bdf8;
      padding-left: 12px;
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 20px;
    }
    .card {
      background: #131b2e;
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 16px;
      padding: 24px;
      transition: transform 0.2s, border-color 0.2s;
    }
    .card:hover {
      transform: translateY(-4px);
      border-color: #38bdf8;
    }
    .card h3 {
      font-size: 18px;
      margin-bottom: 8px;
      color: #fff;
    }
    .card p {
      font-size: 14px;
      color: #94a3b8;
      margin-bottom: 16px;
    }
    .tag {
      font-size: 11px;
      color: #38bdf8;
      text-transform: uppercase;
      font-weight: 700;
      letter-spacing: 0.5px;
    }
  </style>
</head>
<body>
  <nav>
    <div class="logo">&lt;Alex /&gt;</div>
    <div class="nav-links">
      <a href="#about">About</a>
      <a href="#projects">Projects</a>
      <a href="#contact" onclick="alert('Reach me at alex@example.com')">Contact</a>
    </div>
  </nav>

  <section class="hero" id="about">
    <div class="avatar">⚡</div>
    <h1>Alex Rivera</h1>
    <div class="role">Full-Stack Developer & Flutter Specialist</div>
    <p class="bio">Passionate about architecting responsive cross-platform mobile apps and high-performance cloud web services.</p>
    <div class="skills">
      <span class="skill-pill">Flutter</span>
      <span class="skill-pill">Dart</span>
      <span class="skill-pill">TypeScript</span>
      <span class="skill-pill">HTML5 & CSS3</span>
      <span class="skill-pill">GraphQL</span>
      <span class="skill-pill">Firebase</span>
    </div>
  </section>

  <section class="projects" id="projects">
    <h2>Featured Projects</h2>
    <div class="grid">
      <div class="card">
        <span class="tag">Mobile App</span>
        <h3>Pulse Tracker</h3>
        <p>Real-time analytics and biometric metrics dashboard built for high-performance devices.</p>
      </div>
      <div class="card">
        <span class="tag">Cloud Platform</span>
        <h3>CloudCast Studio</h3>
        <p>Collaborative audio streaming engine with sub-second peer-to-peer latency.</p>
      </div>
      <div class="card">
        <span class="tag">Dev Tool</span>
        <h3>CodeLens IDE</h3>
        <p>Lightweight in-browser code inspector and real-time live HTML/JS sandbox previewer.</p>
      </div>
    </div>
  </section>
</body>
</html>''',
    ),
    HtmlTemplate(
      id: 'landing',
      title: 'Landing Page',
      description: 'Vibrant modern SaaS landing page with hero CTA, metric stats, and feature cards.',
      icon: Icons.rocket_launch_outlined,
      category: 'Websites',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>NovaFlow - Work Smarter</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #0b0f19;
      color: #f3f4f6;
      line-height: 1.5;
    }
    header {
      padding: 24px 32px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      max-width: 1200px;
      margin: 0 auto;
    }
    .brand {
      font-size: 22px;
      font-weight: 800;
      background: linear-gradient(90deg, #ec4899, #8b5cf6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    .cta-header {
      background: #1f2937;
      color: #fff;
      border: 1px solid rgba(255,255,255,0.15);
      padding: 8px 18px;
      border-radius: 9999px;
      font-size: 14px;
      cursor: pointer;
    }
    .hero {
      text-align: center;
      padding: 60px 24px 40px;
      max-width: 800px;
      margin: 0 auto;
    }
    .badge {
      display: inline-block;
      background: rgba(139, 92, 246, 0.15);
      border: 1px solid rgba(139, 92, 246, 0.4);
      color: #c4b5fd;
      padding: 6px 16px;
      border-radius: 9999px;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 20px;
    }
    h1 {
      font-size: 42px;
      font-weight: 900;
      letter-spacing: -1px;
      margin-bottom: 20px;
      line-height: 1.2;
    }
    h1 span {
      background: linear-gradient(90deg, #ec4899, #8b5cf6, #3b82f6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    p.lead {
      color: #9ca3af;
      font-size: 18px;
      margin-bottom: 32px;
    }
    .actions {
      display: flex;
      gap: 16px;
      justify-content: center;
      flex-wrap: wrap;
    }
    .btn-primary {
      background: linear-gradient(90deg, #ec4899, #8b5cf6);
      color: #fff;
      border: none;
      padding: 14px 32px;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 700;
      cursor: pointer;
      box-shadow: 0 10px 25px rgba(236, 72, 153, 0.35);
      transition: transform 0.2s;
    }
    .btn-primary:hover { transform: scale(1.03); }
    .btn-secondary {
      background: #1f2937;
      color: #e5e7eb;
      border: 1px solid rgba(255,255,255,0.1);
      padding: 14px 28px;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
    }
    .stats {
      display: flex;
      justify-content: space-around;
      max-width: 700px;
      margin: 60px auto 40px;
      background: #111827;
      border: 1px solid rgba(255,255,255,0.06);
      border-radius: 20px;
      padding: 24px;
    }
    .stat-item h3 {
      font-size: 28px;
      font-weight: 800;
      color: #f9fafb;
    }
    .stat-item p {
      font-size: 13px;
      color: #9ca3af;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
  </style>
</head>
<body>
  <header>
    <div class="brand">NovaFlow</div>
    <button class="cta-header" onclick="alert('Starting free trial!')">Get Started</button>
  </header>

  <main class="hero">
    <div class="badge">🚀 v2.0 Released: Supercharged Workflows</div>
    <h1>The ultimate platform for <span>hyper-productive</span> engineering teams.</h1>
    <p class="lead">Automate boilerplate, preview changes in real-time, and ship resilient digital products 10x faster.</p>
    <div class="actions">
      <button class="btn-primary" onclick="alert('Welcome aboard! ✨')">Start Free 14-Day Trial</button>
      <button class="btn-secondary" onclick="alert('Viewing live demo walkthrough!')">Watch Demo</button>
    </div>

    <div class="stats">
      <div class="stat-item">
        <h3>99.99%</h3>
        <p>Uptime SLA</p>
      </div>
      <div class="stat-item">
        <h3>140K+</h3>
        <p>Developers</p>
      </div>
      <div class="stat-item">
        <h3>4.9 ★</h3>
        <p>Customer Rating</p>
      </div>
    </div>
  </main>
</body>
</html>''',
    ),
    HtmlTemplate(
      id: 'card',
      title: 'Card UI',
      description: 'Modern product card with star ratings, color selector, and add-to-cart animation.',
      icon: Icons.credit_card_outlined,
      category: 'UI Components',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Modern Product Card</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #f1f5f9;
      padding: 20px;
    }
    .card {
      background: #ffffff;
      border-radius: 24px;
      overflow: hidden;
      width: 100%;
      max-width: 360px;
      box-shadow: 0 20px 35px -10px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease;
    }
    .card:hover { transform: translateY(-6px); }
    .image-box {
      height: 220px;
      background: linear-gradient(135deg, #0ea5e9, #6366f1);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      color: #fff;
      font-size: 72px;
    }
    .badge {
      position: absolute;
      top: 16px;
      right: 16px;
      background: rgba(0,0,0,0.5);
      backdrop-filter: blur(8px);
      color: #fff;
      padding: 4px 10px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: 700;
    }
    .content { padding: 24px; }
    .rating {
      display: flex;
      align-items: center;
      gap: 4px;
      color: #f59e0b;
      font-size: 14px;
      margin-bottom: 8px;
    }
    .reviews { color: #64748b; font-size: 13px; margin-left: 4px; }
    h2 { font-size: 20px; font-weight: 700; color: #0f172a; margin-bottom: 6px; }
    .desc { font-size: 14px; color: #64748b; margin-bottom: 20px; line-height: 1.5; }
    .colors { display: flex; align-items: center; gap: 8px; margin-bottom: 20px; }
    .color-label { font-size: 13px; font-weight: 600; color: #334155; }
    .dot {
      width: 22px;
      height: 22px;
      border-radius: 50%;
      cursor: pointer;
      border: 2px solid transparent;
      transition: transform 0.2s;
    }
    .dot.active { border-color: #0f172a; transform: scale(1.15); }
    .footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding-top: 16px;
      border-top: 1px solid #f1f5f9;
    }
    .price { font-size: 24px; font-weight: 800; color: #0f172a; }
    .btn-buy {
      background: #0f172a;
      color: #ffffff;
      border: none;
      padding: 12px 20px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.2s, transform 0.1s;
    }
    .btn-buy:hover { background: #334155; }
    .btn-buy:active { transform: scale(0.96); }
  </style>
</head>
<body>
  <div class="card">
    <div class="image-box" id="cardImg">🎧
      <span class="badge">NEW</span>
    </div>
    <div class="content">
      <div class="rating">★★★★★ <span class="reviews">(128)</span></div>
      <h2>AeroPro Wireless ANC</h2>
      <p class="desc">Active noise cancellation, 40-hour battery life, and spatial lossless audio.</p>
      <div class="colors">
        <span class="color-label">Color:</span>
        <div class="dot active" style="background:#0ea5e9;" onclick="pickColor(this, '#0ea5e9')"></div>
        <div class="dot" style="background:#10b981;" onclick="pickColor(this, '#10b981')"></div>
        <div class="dot" style="background:#f43f5e;" onclick="pickColor(this, '#f43f5e')"></div>
        <div class="dot" style="background:#1e293b;" onclick="pickColor(this, '#1e293b')"></div>
      </div>
      <div class="footer">
        <div class="price">\$199</div>
        <button class="btn-buy" onclick="addToCart()">Add to Cart</button>
      </div>
    </div>
  </div>

  <script>
    function pickColor(elem, color) {
      document.querySelectorAll('.dot').forEach(d => d.classList.remove('active'));
      elem.classList.add('active');
      document.getElementById('cardImg').style.background = color;
      console.log('Selected color:', color);
    }
    function addToCart() {
      alert('AeroPro ANC added to cart! 🛒');
      console.log('Item added to cart');
    }
  </script>
</body>
</html>''',
    ),
    HtmlTemplate(
      id: 'calculator',
      title: 'Calculator',
      description: 'Fully functional interactive JavaScript calculator with CSS grid and math logic.',
      icon: Icons.calculate_outlined,
      category: 'Apps',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Calculator</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #0f172a;
      padding: 16px;
    }
    .calculator {
      background: #1e293b;
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 24px;
      padding: 24px;
      width: 100%;
      max-width: 320px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
    }
    .display {
      background: #0f172a;
      border-radius: 16px;
      padding: 20px 16px;
      margin-bottom: 20px;
      text-align: right;
      color: #fff;
      min-height: 76px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }
    .history { font-size: 13px; color: #64748b; min-height: 16px; margin-bottom: 4px; }
    .current { font-size: 32px; font-weight: 700; word-break: break-all; }
    .keys {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
    }
    button {
      height: 56px;
      border-radius: 14px;
      border: none;
      background: #334155;
      color: #f8fafc;
      font-size: 18px;
      font-weight: 600;
      cursor: pointer;
      transition: filter 0.15s, transform 0.1s;
    }
    button:hover { filter: brightness(1.2); }
    button:active { transform: scale(0.95); }
    .op { background: #6366f1; color: #fff; }
    .clear { background: #ef4444; color: #fff; }
    .equal { background: #10b981; color: #fff; grid-column: span 2; }
  </style>
</head>
<body>
  <div class="calculator">
    <div class="display">
      <div class="history" id="history"></div>
      <div class="current" id="current">0</div>
    </div>
    <div class="keys">
      <button class="clear" onclick="clearAll()">C</button>
      <button onclick="backspace()">⌫</button>
      <button class="op" onclick="appendOp('%')">%</button>
      <button class="op" onclick="appendOp('/')">÷</button>

      <button onclick="appendNum('7')">7</button>
      <button onclick="appendNum('8')">8</button>
      <button onclick="appendNum('9')">9</button>
      <button class="op" onclick="appendOp('*')">×</button>

      <button onclick="appendNum('4')">4</button>
      <button onclick="appendNum('5')">5</button>
      <button onclick="appendNum('6')">6</button>
      <button class="op" onclick="appendOp('-')">−</button>

      <button onclick="appendNum('1')">1</button>
      <button onclick="appendNum('2')">2</button>
      <button onclick="appendNum('3')">3</button>
      <button class="op" onclick="appendOp('+')">+</button>

      <button onclick="appendNum('0')">0</button>
      <button onclick="appendNum('.')">.</button>
      <button class="equal" onclick="compute()">=</button>
    </div>
  </div>

  <script>
    let currentInput = '0';
    let historyInput = '';
    const currentEl = document.getElementById('current');
    const historyEl = document.getElementById('history');

    function updateView() {
      currentEl.textContent = currentInput;
      historyEl.textContent = historyInput;
    }
    function appendNum(num) {
      if (currentInput === '0' && num !== '.') {
        currentInput = num;
      } else {
        if (num === '.' && currentInput.includes('.')) return;
        currentInput += num;
      }
      updateView();
    }
    function appendOp(op) {
      historyInput = currentInput + ' ' + op;
      currentInput = '0';
      updateView();
    }
    function clearAll() {
      currentInput = '0';
      historyInput = '';
      updateView();
    }
    function backspace() {
      if (currentInput.length > 1) {
        currentInput = currentInput.slice(0, -1);
      } else {
        currentInput = '0';
      }
      updateView();
    }
    function compute() {
      try {
        const expression = historyInput + ' ' + currentInput;
        const result = Function('"use strict"; return (' + expression + ')')();
        historyInput = expression + ' =';
        currentInput = String(Number(result.toFixed(6)));
        updateView();
        console.log('Result:', result);
      } catch (e) {
        currentInput = 'Error';
        updateView();
        console.error('Calculation error:', e);
      }
    }
  </script>
</body>
</html>''',
    ),
    HtmlTemplate(
      id: 'jsdemo',
      title: 'JavaScript Demo',
      description: 'Interactive DOM playground with live counter, color picker, dynamic list builder, and timer.',
      icon: Icons.javascript_outlined,
      category: 'Interactive',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JS Interactivity Playground</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #0d1117;
      color: #c9d1d9;
      padding: 24px;
    }
    .container { max-width: 600px; margin: 0 auto; }
    h1 { color: #58a6ff; font-size: 26px; margin-bottom: 20px; text-align: center; }
    .panel {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 16px;
      padding: 20px;
      margin-bottom: 20px;
    }
    h2 { font-size: 16px; color: #f0f6fc; margin-bottom: 12px; }
    .flex-row { display: flex; gap: 10px; align-items: center; }
    button {
      background: #238636;
      color: #fff;
      border: 1px solid rgba(240, 246, 252, 0.1);
      padding: 8px 16px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
    }
    button.alt { background: #21262d; border-color: #30363d; }
    button:hover { filter: brightness(1.1); }
    input[type="text"] {
      flex: 1;
      padding: 8px 12px;
      background: #0d1117;
      border: 1px solid #30363d;
      border-radius: 8px;
      color: #fff;
      font-size: 14px;
    }
    ul { list-style: none; margin-top: 12px; }
    li {
      background: #0d1117;
      border: 1px solid #21262d;
      padding: 8px 12px;
      border-radius: 6px;
      margin-bottom: 6px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 14px;
    }
    .del-btn {
      background: #da3633;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 11px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🚀 JavaScript Live Playground</h1>

    <!-- Counter Section -->
    <div class="panel">
      <h2>1. Interactive Counter & Timer</h2>
      <div class="flex-row">
        <span style="font-size: 22px; font-weight:700; color:#58a6ff; width:60px;" id="countVal">0</span>
        <button onclick="inc()">+1</button>
        <button onclick="dec()">-1</button>
        <button class="alt" onclick="resetCount()">Reset</button>
        <span style="margin-left:auto; font-size:13px; color:#8b949e;">Uptime: <span id="timer">0s</span></span>
      </div>
    </div>

    <!-- Color Changer -->
    <div class="panel">
      <h2>2. Live DOM Background Color</h2>
      <div class="flex-row">
        <button onclick="randomizeBg()">🎲 Randomize Color</button>
        <button class="alt" onclick="testError()">⚠️ Trigger Error (Console)</button>
      </div>
    </div>

    <!-- Todo / Item List -->
    <div class="panel">
      <h2>3. Dynamic Item List</h2>
      <div class="flex-row">
        <input type="text" id="todoInput" placeholder="Enter a task or note...">
        <button onclick="addTodo()">Add</button>
      </div>
      <ul id="todoList">
        <li><span>Explore HTML Editor features</span> <button class="del-btn" onclick="this.parentElement.remove()">✕</button></li>
      </ul>
    </div>
  </div>

  <script>
    let count = 0;
    function inc() { count++; document.getElementById('countVal').textContent = count; console.log('Count:', count); }
    function dec() { count--; document.getElementById('countVal').textContent = count; console.log('Count:', count); }
    function resetCount() { count = 0; document.getElementById('countVal').textContent = count; }

    let seconds = 0;
    setInterval(() => {
      seconds++;
      document.getElementById('timer').textContent = seconds + 's';
    }, 1000);

    function randomizeBg() {
      const colors = ['#0d1117', '#1a2332', '#1a1b26', '#261c28', '#1a2e26'];
      const c = colors[Math.floor(Math.random() * colors.length)];
      document.body.style.backgroundColor = c;
      console.log('Background updated to', c);
    }

    function addTodo() {
      const input = document.getElementById('todoInput');
      const text = input.value.trim();
      if (!text) return;
      const li = document.createElement('li');
      li.innerHTML = '<span>' + text + '</span> <button class="del-btn" onclick="this.parentElement.remove()">✕</button>';
      document.getElementById('todoList').appendChild(li);
      input.value = '';
      console.log('Added task:', text);
    }

    function testError() {
      console.warn('Simulating developer warning...');
      // Intentional error for console inspection
      nonExistentFunction();
    }
  </script>
</body>
</html>''',
    ),
    HtmlTemplate(
      id: 'cssanimation',
      title: 'CSS Animation',
      description: 'Hypnotic 3D glowing sphere, pulsing particle rings, neon glow keyframes, and speed slider.',
      icon: Icons.animation_outlined,
      category: 'Interactive',
      code: '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CSS 3D Animation Sphere</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: #05050a;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      color: #fff;
    }
    .scene {
      width: 220px;
      height: 220px;
      perspective: 1000px;
      position: relative;
    }
    .sphere {
      width: 100%;
      height: 100%;
      position: absolute;
      transform-style: preserve-3d;
      animation: rotateSphere var(--speed, 10s) linear infinite;
    }
    @keyframes rotateSphere {
      0% { transform: rotateX(0deg) rotateY(0deg) rotateZ(0deg); }
      100% { transform: rotateX(360deg) rotateY(360deg) rotateZ(360deg); }
    }
    .ring {
      position: absolute;
      width: 100%;
      height: 100%;
      border-radius: 50%;
      border: 2px solid;
      box-shadow: 0 0 15px currentColor;
    }
    .ring:nth-child(1) { border-color: #38bdf8; transform: rotateY(0deg); }
    .ring:nth-child(2) { border-color: #818cf8; transform: rotateY(36deg); }
    .ring:nth-child(3) { border-color: #c084fc; transform: rotateY(72deg); }
    .ring:nth-child(4) { border-color: #f472b6; transform: rotateY(108deg); }
    .ring:nth-child(5) { border-color: #34d399; transform: rotateY(144deg); }
    .ring:nth-child(6) { border-color: #fbbf24; transform: rotateX(90deg); }

    .controls {
      margin-top: 48px;
      text-align: center;
      background: rgba(255,255,255,0.06);
      backdrop-filter: blur(8px);
      padding: 16px 24px;
      border-radius: 16px;
      border: 1px solid rgba(255,255,255,0.1);
    }
    .controls label { font-size: 13px; color: #94a3b8; display: block; margin-bottom: 8px; }
    input[type="range"] {
      accent-color: #818cf8;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="scene">
    <div class="sphere" id="sphere">
      <div class="ring"></div>
      <div class="ring"></div>
      <div class="ring"></div>
      <div class="ring"></div>
      <div class="ring"></div>
      <div class="ring"></div>
    </div>
  </div>

  <div class="controls">
    <label>⚡ Animation Speed</label>
    <input type="range" min="1" max="20" value="10" oninput="changeSpeed(this.value)">
  </div>

  <script>
    function changeSpeed(val) {
      const dur = (21 - val) + 's';
      document.getElementById('sphere').style.setProperty('--speed', dur);
      console.log('Rotation duration set to:', dur);
    }
  </script>
</body>
</html>''',
    ),
  ];
}
