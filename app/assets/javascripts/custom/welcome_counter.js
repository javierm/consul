document.addEventListener('DOMContentLoaded', function(event) {
  document.querySelectorAll('.welcome-counter').forEach(function(element) {
    new WelcomeCounter(element);
  });
});

class WelcomeCounter {
  constructor(element) {
    this.element = element;
    this.countTo = parseInt(element.innerHTML);

    this.countUp.bind(this);
    this.countFetch.bind(this);
    this.random.bind(this);

    this.current = Math.max(this.countTo - this.random(100, 200), 0);
    this.countInterval = setInterval(this.countUp.bind(this), 10);
  }

  countUp() {
    if(this.current == this.countTo) {
      clearInterval(this.countInterval);
      this.countFetchInterval = setInterval(this.countFetch.bind(this), 10000);
    }
    this.element.innerHTML = this.current++;
  }

  countFetch() {
    $.ajax({
      url: '/users_count.json',
      dataType: 'json',
      success: function(data) {
        if (data.count > this.countTo) {
          clearInterval(this.countFetchInterval);
          this.countTo = data.count;
          this.countInterval = setInterval(this.countUp.bind(this), 10);
        }
      }.bind(this)
    });
  }

  random(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }
}
