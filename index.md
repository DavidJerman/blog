---
layout: page
title: David's Log
---

## Tech, Travel, and Everything In Between

Welcome! This is where I document my deep dives into tech stuff (mostly programming), mixed with stories from my travels across **Japan, Romania, and beyond**.

---

### ⭐ Featured Posts
<ul>
  {% for post in site.posts %}
    {% if post.featured == true %}
      <li><b><a href="{{ post.url | relative_url }}">{{ post.title }}</a></b> - <small>{{ post.date | date: "%b %Y" }}</small></li>
    {% endif %}
  {% endfor %}
</ul>

---

### ✈️ Specific Trips & Series

<details>
<summary>🗾 <b>Japan Guides</b></summary>
<ul>
  {% for post in site.tags.japanguides %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
</details>

<details>
<summary>🌸 <b>Japan 2025</b></summary>
<ul>
  {% for post in site.tags.japan2025 reversed %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
</details>

<details>
<summary>🍱 <b>Japan 2024</b></summary>
<ul>
  {% for post in site.tags.japan2024 reversed %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
</details>

<details>
<summary>⛩️ <b>Japan 2023</b></summary>
<ul>
  {% for post in site.tags.japan2023 reversed %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
</details>

<details>
<summary>🇷🇴 <b>Romania 2024</b></summary>
<ul>
  {% for post in site.tags.romania2024 reversed %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
</details>

---

### 🗄️ The Archives

<details>
<summary>🗺️ <b>All Travel Journals</b></summary>
<ul>
  {% for post in site.categories.travel %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> - <small>{{ post.date | date: "%b %Y" }}</small></li>
  {% endfor %}
</ul>
</details>

<details>
<summary>💻 <b>Tech & Low-Level Engineering</b> (Assembly, Hardware, Code)</summary>
<ul>
  {% for post in site.categories.tech %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> - <small>{{ post.date | date: "%b %Y" }}</small></li>
  {% endfor %}
</ul>
</details>

<details>
<summary>📝 <b>Other Posts</b></summary>
<ul>
  {% for post in site.posts %}
    {% unless post.categories contains "travel" or post.categories contains "tech" %}
      <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
    {% endunless %}
  {% endfor %}
</ul>
</details>

---
### 🕒 Recent Updates
{% for post in site.posts limit:3 %}
* [{{ post.title }}]({{ post.url | relative_url }}) ({{ post.date | date: "%b %d" }})
{% endfor %}
