document.addEventListener('DOMContentLoaded', function(event) {
  document.querySelectorAll('.welcome-counter').forEach(function(element) {
    new WelcomeCounter(element);
  });
});

class WelcomeCounter {
  constructor(element) {
    this.element = element;
    this.count = parseInt(element.innerHTML);

    this.countUp.bind(this);
    this.random.bind(this);

    this.current = Math.max(this.count - this.random(100, 200), 0);

    this.countInterval = setInterval(this.countUp.bind(this), 1);
  }

  countUp() {
    if(this.current == this.count) {
      clearInterval(this.countInterval);
    }
    this.element.innerHTML = this.current;
    this.current++;
  }

  random(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }
}
