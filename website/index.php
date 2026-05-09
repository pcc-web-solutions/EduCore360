<?php
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
    <link rel="stylesheet" href="asset/css/website.css">
    <link rel="shortcut icon" href="asset/images/app-icon.png">
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