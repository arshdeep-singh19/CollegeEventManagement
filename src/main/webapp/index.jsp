<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusConnect | College Events</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>


<!-- Navigation Bar -->
<header class="navbar">
    <a href="${pageContext.request.contextPath}/" class="logo">
        Campus<span>Connect</span>
    </a>

    <nav class="nav-links">
        <a href="${pageContext.request.contextPath}/" class="active">Home</a>
        <a href="#events">Events</a>
        <a href="#categories">Categories</a>
        <a href="#about">About</a>
    </nav>


<div class="nav-actions">
    <a href="${pageContext.request.contextPath}/student/login.jsp" class="btn btn-outline">Login</a>
    <a href="${pageContext.request.contextPath}/student/register.jsp" class="btn btn-primary">Register</a>
    <a href="${pageContext.request.contextPath}/admin/login.jsp" class="btn btn-outline">Admin Login</a>
</div>


</header>

<main>
    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <p class="eyebrow">YOUR CAMPUS. YOUR COMMUNITY.</p>
            <h1>Make Every Campus Moment <span>Count.</span></h1>
            <p class="hero-description">
                Discover exciting college events, connect with fellow students
                and make memories that last beyond the classroom.
            </p>

            <div class="hero-actions">
                <a href="#events" class="btn btn-primary">Explore Events &rarr;</a>
                <a href="#about" class="btn btn-light">Discover More</a>
            </div>

            <div class="hero-note">
                <span class="status-dot"></span>
                Discover what's happening on your campus
            </div>
        </div>

        <div class="hero-card">
            <div class="hero-card-top">
                <span class="event-label">FEATURED EVENT</span>
                <span class="event-icon">&#9733;</span>
            </div>
            <div class="hero-illustration" aria-hidden="true">&#127891;</div>
            <p class="hero-card-category">CULTURAL FEST</p>
            <h2>Campus Fest 2026</h2>
            <p class="hero-card-description">
                Music, creativity and unforgettable campus memories.
            </p>
            <div class="hero-card-footer">
                <span>&#128197; Coming Soon</span>
                <a href="#events" aria-label="Explore featured event">&#8599;</a>
            </div>
        </div>
    </section>

    <!-- Highlights -->
    <section class="highlights" aria-label="Platform highlights">
        <div class="highlight-item">
            <span class="highlight-icon">&#127891;</span>
            <div>
                <h3>For Students</h3>
                <p>Find your next experience</p>
            </div>
        </div>

        <div class="highlight-item">
            <span class="highlight-icon">&#127919;</span>
            <div>
                <h3>Explore Interests</h3>
                <p>Technical, cultural and more</p>
            </div>
        </div>

        <div class="highlight-item">
            <span class="highlight-icon">&#129309;</span>
            <div>
                <h3>Build Connections</h3>
                <p>Make campus memories</p>
            </div>
        </div>
    </section>

    <!-- Events Section -->
    <section class="section events-section" id="events">
        <div class="section-heading">
            <div>
                <p class="eyebrow">WHAT'S HAPPENING</p>
                <h2>Explore Campus Events</h2>
                <p class="section-description">
                    Find something exciting to learn, create or experience.
                </p>
            </div>
            <span class="sample-note">DEMO EVENTS</span>
        </div>

        <div class="event-grid">
            <article class="event-card">
                <div class="event-art art-tech">
                    <span class="event-category">TECHNICAL</span>
                    <span class="event-art-icon">&#128187;</span>
                </div>
                <div class="event-card-body">
                    <p class="event-meta">DATE TO BE ANNOUNCED</p>
                    <h3>CodeSprint Hackathon</h3>
                    <p>Team up, solve real-world problems and bring your ideas to life.</p>
                    <a href="${pageContext.request.contextPath}/student/login.jsp" class="event-link">
                        Login to Register <span>&rarr;</span>
                    </a>
                </div>
            </article>

            <article class="event-card">
                <div class="event-art art-culture">
                    <span class="event-category">CULTURAL</span>
                    <span class="event-art-icon">&#127926;</span>
                </div>
                <div class="event-card-body">
                    <p class="event-meta">DATE TO BE ANNOUNCED</p>
                    <h3>Campus Cultural Fest</h3>
                    <p>Celebrate music, dance, art and the spirit of college life.</p>
                    <a href="${pageContext.request.contextPath}/student/login.jsp" class="event-link">
                        Login to Register <span>&rarr;</span>
                    </a>
                </div>
            </article>

            <article class="event-card">
                <div class="event-art art-sports">
                    <span class="event-category">SPORTS</span>
                    <span class="event-art-icon">&#127936;</span>
                </div>
                <div class="event-card-body">
                    <p class="event-meta">DATE TO BE ANNOUNCED</p>
                    <h3>Inter-College Sports Meet</h3>
                    <p>Bring your team spirit and enjoy the thrill of competition.</p>
                    <a href="${pageContext.request.contextPath}/student/login.jsp" class="event-link">
                        Login to Register <span>&rarr;</span>
                    </a>
                </div>
            </article>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="section categories-section" id="categories">
        <div class="section-heading">
            <div>
                <p class="eyebrow">FIND YOUR INTEREST</p>
                <h2>Something for Everyone</h2>
            </div>
        </div>

        <div class="category-grid">
            <a class="category-card" href="#events">
                <span>&#128187;</span>
                <h3>Technical</h3>
                <p>Hackathons, coding and workshops</p>
            </a>

            <a class="category-card" href="#events">
                <span>&#127926;</span>
                <h3>Cultural</h3>
                <p>Music, dance and creative arts</p>
            </a>

            <a class="category-card" href="#events">
                <span>&#9917;</span>
                <h3>Sports</h3>
                <p>Games, tournaments and fitness</p>
            </a>

            <a class="category-card" href="#events">
                <span>&#128218;</span>
                <h3>Academic</h3>
                <p>Seminars, talks and learning</p>
            </a>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section" id="about">
        <div class="about-symbol" aria-hidden="true">&#127891;</div>
        <div class="about-content">
            <p class="eyebrow">ABOUT CAMPUSCONNECT</p>
            <h2>Your campus life, all in one place.</h2>
            <p>
                CampusConnect is a college event management platform concept
                designed to help students discover campus activities and make
                participation easier. Our goal is to bring campus opportunities
                together in one convenient place.
            </p>
            <a href="#events" class="btn btn-primary">Explore Events &rarr;</a>
        </div>
    </section>
</main>

<!-- Footer -->
<footer class="footer">
    <a href="${pageContext.request.contextPath}/" class="logo footer-logo">
        Campus<span>Connect</span>
    </a>
    <p>Discover events. Connect with people. Make memories.</p>
    <p class="footer-bottom">
        &copy; 2026 CampusConnect. College Event Management System — Student Project.
    </p>
</footer>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
```

</body>
</html>
