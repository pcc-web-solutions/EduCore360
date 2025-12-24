<?php
// Standalone landing page demo
// EduCore360 — Paramount Communication Centre
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduCore360 - Smart School Management</title>
    <link href="asset/css/icons.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="asset/css/font-awesome.min.css">

    <style>
    :root {
        --teal: #007a7c;
        --accent: #00c4b4;
        --light: #f9f9f9;
        --dark: #003b3d;
        --text: #333;
    }
    body {
        font-family: "Poppins", sans-serif;
        margin: 0;
        background: #fff;
        color: var(--text);
        overflow-x: hidden;
        scroll-behavior: smooth;
    }

    /* ===== NAVBAR ===== */
    header {
        background: var(--teal);
        color: #fff;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 2rem;
        flex-wrap: wrap;
    }
    header .logo {
        font-size: 1.4rem;
        font-weight: bold;
    }
    nav ul {
        list-style: none;
        display: flex;
        gap: 1.2rem;
        margin: 0;
        padding: 0;
    }
    nav ul li a {
        color: #fff;
        text-decoration: none;
        font-weight: 500;
    }
    nav ul li a:hover {
        text-decoration: underline;
    }
    .nav-btns a {
        background: #fff;
        color: var(--teal);
        text-decoration: none;
        padding: 0.4rem 0.9rem;
        border-radius: 4px;
        font-weight: 600;
        margin-left: 0.5rem;
    }

    /* ===== HERO ===== */
    .hero {
        background: linear-gradient(rgba(0,0,0,0.4),rgba(0,0,0,0.4)), url('assets/bg-school.jpg') center/cover no-repeat;
        color: #fff;
        text-align: center;
        padding: 5rem 1rem;
    }
    .hero h1 {
        font-size: 2.2rem;
    }
    .hero h1 span {
        color: var(--accent);
    }
    .hero p {
        max-width: 600px;
        margin: 0 auto 2rem;
    }
    .hero a {
        display: inline-block;
        margin: 0.5rem;
        padding: 0.7rem 1.4rem;
        border-radius: 4px;
        text-decoration: none;
        font-weight: 600;
        transition: 0.3s;
    }
    .btn-filled {
        background: var(--accent);
        color: #fff;
    }
    .btn-outline {
        border: 2px solid #fff;
        color: #fff;
    }
    .btn-filled:hover, .btn-outline:hover {
        opacity: 0.8;
    }

    /* ===== NEWS TICKER ===== */
    .news-ticker-wrapper {
        display: flex;
        align-items: center;
        background: #e6f4f4;
        color: var(--dark);
        border-left: 5px solid var(--teal);
        padding: 0.5rem 1rem;
        overflow: hidden;
    }
    .news-ticker-label {
        font-weight: 600;
        color: var(--teal);
        margin-right: 10px;
        white-space: nowrap;
    }
    .news-ticker {
        overflow: hidden;
        flex: 1;
    }
    .ticker-content {
        white-space: nowrap;
        display: inline-block;
        will-change: transform;
    }

    /* ===== CONTENT ===== */
    .container {
        width: 90%;
        margin: auto;
        padding: 2rem 0;
    }
    .section {
        margin-bottom: 2rem;
    }
    .features {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 1rem;
    }
    .feature-card {
        background: var(--light);
        padding: 1.5rem;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    /* ===== NEWSLETTER ===== */
    .newsletter {
        text-align: center;
        background: #e6f4f4;
        padding: 2rem;
        border-radius: 8px;
    }
    .newsletter form {
        margin-top: 1rem;
    }
    .newsletter input {
        padding: 0.6rem;
        border: 1px solid #ccc;
        border-radius: 4px;
        width: 60%;
        max-width: 300px;
    }
    .newsletter button {
        background: var(--teal);
        color: #fff;
        border: none;
        padding: 0.6rem 1.2rem;
        border-radius: 4px;
        cursor: pointer;
    }

    /* ===== FOOTER ===== */
    footer {
        background: var(--dark);
        color: #ccc;
        text-align: center;
        padding: 2rem 1rem;
    }
    .socials a {
        color: var(--accent);
        margin: 0 0.6rem;
        text-decoration: none;
        font-size: 1.4rem;
        transition: 0.3s;
    }
    .socials a:hover {
        color: #fff;
    }

    /* ===== CHAT WIDGET ===== */
    .chat-widget {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 999;
    }
    .chat-button {
        background: var(--teal);
        color: #fff;
        border-radius: 50%;
        padding: 15px;
        cursor: pointer;
        font-size: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }
    .chat-box {
        display: none;
        width: 250px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        position: absolute;
        bottom: 60px;
        right: 0;
    }
    .chat-box.show {
        display: block;
    }
    .chat-header {
        padding: 8px;
        font-weight: 600;
        background: var(--teal);
        color: #fff;
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .chat-body {
        padding: 10px;
        max-height: 150px;
        overflow-y: auto;
        font-size: 0.9rem;
        color: #444;
    }
    .chat-input {
        display: flex;
        border-top: 1px solid #ddd;
    }
    .chat-input input {
        border: none;
        flex: 1;
        padding: 0.5rem;
    }
    .chat-input button {
        background: var(--teal);
        color: #fff;
        border: none;
        padding: 0.5rem 0.8rem;
        cursor: pointer;
    }

    /* ===== DARK MODE ===== */
    .theme-toggle {
        position: fixed;
        bottom: 20px;
        left: 20px;
        background: #fff;
        border: 1px solid #ccc;
        border-radius: 50%;
        padding: 10px;
        cursor: pointer;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
    }
    body.dark-mode {
        background: #111;
        color: #eee;
    }
    body.dark-mode .feature-card {
        background: #222;
        color: #ddd;
    }
    </style>
</head>
<body class="dark-mode">

<header>
  <div class="logo"><i class="fa fa-graduation-cap"></i> EduCore360</div>
  <nav>
    <ul>
      <li><a href="#">Home</a></li>
      <li><a href="#about">About</a></li>
      <li><a href="#">Admissions</a></li>
      <li><a href="#">Careers</a></li>
      <li><a href="#newsletter">News</a></li>
      <li><a href="#">Contact</a></li>
    </ul>
  </nav>
  <?php if (!isset($user['userid'])) { ?>
  <div class="nav-btns">
    <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signin.php");?>"><i class="fa fa-sign-in"></i> Login</a>
    <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/signup.php");?>"><i class="fa fa-user-plus"></i> Register</a>
  </div>
  <?php } else { ?>
  <div class="nav-btns">
    <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/profile.php");?>"><i class="fa fa-user"></i> Profile</a>
    <a href="<?= "request.php?tkn=".$dmo->storeRoute("user/logout.php");?>"><i class="fa fa-sign-out"></i> Logout</a>
  </div>
  <?php } ?>
</header>

<section class="hero">
  <h1>Welcome to <span>EduCore360</span></h1>
  <p>A Smarter Way to Manage Schools — Admissions, HR, Finance, and Exams all in one MIS platform.</p>
  <a href="#" class="btn-filled"><i class="fa fa-file-pen"></i> Apply for Admission</a>
  <a href="#" class="btn-filled"><i class="fa fa-file-pen"></i> Apply for Job</a>
  <a href="#about" class="btn-outline"><i class="fa fa-circle-info"></i> Learn More</a>
</section>

<div class="news-ticker-wrapper">
  <div class="news-ticker-label"><i class="fa fa-newspaper"></i> Latest News:</div>
  <div class="news-ticker">
    <div class="ticker-content">
      Admissions 2025 now open &nbsp; | &nbsp;
      Teacher recruitment ongoing &nbsp; | &nbsp;
      EduCore360 mobile portal launching soon!
    </div>
  </div>
</div>

<!-- ===== MAIN CONTENT ===== -->
<div class="container">

  <section class="section features">
    <div class="feature-card">
      <h3><i class="fas fa-layer-group"></i> All-in-One Platform</h3>
      <p>Manage Admissions, HR, Finance, and Exams under one secure cloud system.</p>
    </div>
    <div class="feature-card">
      <h3><i class="fas fa-school"></i> Multi-School Support</h3>
      <p>Monitor multiple institutions from a single dashboard.</p>
    </div>
    <div class="feature-card">
      <h3><i class="fas fa-chart-line"></i> Real-Time Analytics</h3>
      <p>Access instant reports for smarter decisions.</p>
    </div>
    <div class="feature-card">
      <h3><i class="fas fa-lock"></i> Secure & Reliable</h3>
      <p>Advanced encryption ensures data protection.</p>
    </div>
  </section>

  <section id="about" class="section">
    <h2><i class="fa fa-circle-info"></i> About EduCore360</h2>
    <p>EduCore360 is a comprehensive School Management Information System developed by <strong>Paramount Communication Centre</strong>. It simplifies school operations and enhances efficiency across all departments.</p>
  </section>

  <section class="newsletter" class="section">
    <h3><i class="fa fa-envelope"></i> Subscribe to Our Newsletter</h3>
    <p>Get updates on admissions, features, and tech news.</p>
    <form>
      <input type="email" placeholder="Enter your email" required>
      <button type="submit"><i class="fa fa-paper-plane"></i> Subscribe</button>
    </form>
  </section>

</div>

<!-- ===== FOOTER ===== -->
<footer>
  <div class="socials">
    <a href="#"><i class="fab fa-facebook"></i></a>
    <a href="#"><i class="fab fa-x-twitter"></i></a>
    <a href="#"><i class="fab fa-instagram"></i></a>
    <a href="#"><i class="fab fa-linkedin"></i></a>
    <a href="#"><i class="fab fa-youtube"></i></a>
  </div>
  <p>&copy; <?php echo date('Y'); ?> EduCore360. All Rights Reserved.<br>Powered by <strong>Paramount Communication Centre</strong></p>
</footer>

<!-- ===== CHAT WIDGET ===== -->
<div class="chat-widget">
  <div class="chat-button" onclick="toggleChat()"><i class="fas fa-comment-dots"></i></div>
  <div class="chat-box" id="chatBox">
    <div class="chat-header">
      <i class="fas fa-headset"></i> Chat with us
      <span onclick="toggleChat()" style="cursor:pointer;"><i class="fas fa-xmark"></i></span>
    </div>
    <div class="chat-body" id="chatBody">
      <p>Hello! 👋 How can we assist you today?</p>
    </div>
    <div class="chat-input">
      <input type="text" id="chatMessage" placeholder="Type a message...">
      <button onclick="sendMessage()"><i class="fa fa-paper-plane"></i></button>
    </div>
  </div>
</div>

<!-- ===== DARK MODE TOGGLE ===== -->
<button id="theme-toggle" class="theme-toggle" title="Toggle Dark Mode"><i class="fa fa-moon"></i></button>

<script src="asset/libs/jquery-validation/jquery.validate.min.js"></script>
<script src="asset/libs/jquery-validation/additional-methods.min.js"></script>
<script src="asset/js/dms.js"></script>
<!-- ===== JS ===== -->
<script>
  // News ticker scroll
  const ticker = document.querySelector('.ticker-content');
  let offset = 0;
  setInterval(() => {
    offset -= 1;
    ticker.style.transform = `translateX(${offset}px)`;
    if (Math.abs(offset) > ticker.scrollWidth / 2) offset = 0;
  }, 30);

  // Chat widget toggle
  function toggleChat() {
    document.getElementById('chatBox').classList.toggle('show');
  }

  // Chat auto-response
  function sendMessage() {
    const input = document.getElementById('chatMessage');
    const chatBody = document.getElementById('chatBody');
    const msg = input.value.trim();
    if (!msg) return;
    const userMsg = document.createElement('p');
    userMsg.textContent = "You: " + msg;
    userMsg.style.textAlign = "right";
    userMsg.style.color = "#007a7c";
    chatBody.appendChild(userMsg);
    input.value = '';

    // Auto response
    setTimeout(() => {
      const botMsg = document.createElement('p');
      if (msg.toLowerCase().includes('hi') || msg.toLowerCase().includes('hello')) {
        botMsg.textContent = "Bot: Hi there! 👋 How can we help you today?";
      } else if (msg.toLowerCase().includes('admission')) {
        botMsg.textContent = "Bot: You can apply for admission through our portal. Would you like the link?";
      } else {
        botMsg.textContent = "Bot: Thank you for your message! Our support team will get back to you soon.";
      }
      chatBody.appendChild(botMsg);
      chatBody.scrollTop = chatBody.scrollHeight;
    }, 800);
  }

  // Dark mode toggle
  const toggle = document.getElementById('theme-toggle');
  toggle.addEventListener('click', () => {
    document.body.classList.toggle('dark-mode');
  });
</script>
</body>
</html>